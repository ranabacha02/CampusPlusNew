import 'dart:io';

import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/views/edit_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:page_transition/page_transition.dart';

import '../utils/app_colors.dart';
import '../views/edit_avatar_screen.dart';

class AvatarImageUploads extends StatefulWidget {
  Image? displayAvatarImage;

  AvatarImageUploads({Key? key, this.displayAvatarImage}) : super(key: key);

  @override
  _AvatarImageUploadsState createState() => _AvatarImageUploadsState(displayAvatarImage);
}

class _AvatarImageUploadsState extends State<AvatarImageUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late DataController dataController;
  FirebaseAuth auth = FirebaseAuth.instance;

  File? avatarphoto;
  Image? displayAvatarImage;

  _AvatarImageUploadsState(Image? displayAvatarImage) {
    this.displayAvatarImage = displayAvatarImage;
  }

  @override
  void initState() {
    super.initState();
    dataController = Get.put(DataController());
  }

  final ImagePicker _picker = ImagePicker();

  Future<File?> imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      avatarphoto = File(pickedFile.path);
      //await dataController.uploadProfilePic(_photo!);
      return avatarphoto;
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<File?> imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      avatarphoto = File(pickedFile.path);
      print("photo selected: " + avatarphoto.toString());
      return avatarphoto;
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future deleteImage() async {}

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
          children: [
            CircleAvatar(
              // to be changed
              backgroundImage: displayAvatarImage != null
                  ? displayAvatarImage!.image
                  : AssetImage("assets/default_profile.jpg"),
              radius: 60,
              backgroundColor: AppColors.circle,
              foregroundColor: AppColors.white,
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 40,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 4,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    color: Colors.green,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.white,
                    onPressed: () {
                      _showPicker(context);
                    },
                  ),
                ))
          ],
        ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () async {
                        File? avatarphoto = await imgFromGallery();
                        print("photo from image gallery: $avatarphoto");
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.topToBottomPop,
                            child: EditAvatarScreen(
                              userInfo: dataController.getLocalData(),
                              deleteavatar: false,
                              avatarphoto: avatarphoto,
                              displayAvatarImage:
                              avatarphoto.isNull ? null : Image.file(avatarphoto!),
                            ),
                            childCurrent: EditAvatarScreen(
                                userInfo: dataController.getLocalData(),
                                deleteavatar: false),
                          ),
                        );
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      File? avatarphoto = await imgFromCamera();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditAvatarScreen(
                                userInfo: dataController.getLocalData(),
                                deleteavatar: false,
                                avatarphoto: avatarphoto,
                                displayAvatarImage: avatarphoto.isNull
                                    ? null
                                    : Image.file(avatarphoto!),
                              )));
                    },
                  ),
                  new ListTile(
                    leading: new Icon(Icons.delete_forever, color: Colors.red),
                    title: new Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      dataController.deleteProfilePicture();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditAvatarScreen(
                                userInfo: dataController.getLocalData(),
                                deleteavatar: true,
                              )));
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}
