import 'dart:io';

import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/views/edit_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../utils/app_colors.dart';

class ImageUploads extends StatefulWidget {
  Image? displayImage;

  ImageUploads({Key? key, this.displayImage}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState(displayImage);
}

class _ImageUploadsState extends State<ImageUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late DataController dataController;
  FirebaseAuth auth = FirebaseAuth.instance;

  File? photo;
  Image? displayImage;

  _ImageUploadsState(Image? displayImage) {
    this.displayImage = displayImage;
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
      photo = File(pickedFile.path);
      //await dataController.uploadProfilePic(_photo!);
      return photo;
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<File?> imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      photo = File(pickedFile.path);
      print("photo selected: " + photo.toString());
      return photo;
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
          backgroundImage: displayImage != null
              ? displayImage!.image
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
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () async {
                        File? photo = await imgFromGallery();
                        print("photo from image gallery: " + photo.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditAccountScreen(
                                      userInfo: dataController.getLocalData(),
                                      delete: false,
                                      photo: photo,
                                      displayImage: photo.isNull
                                          ? null
                                          : Image.file(photo!),
                                    )));
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      File? photo = await imgFromCamera();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditAccountScreen(
                                    userInfo: dataController.getLocalData(),
                                    delete: false,
                                    photo: photo,
                                    displayImage: photo.isNull
                                        ? null
                                        : Image.file(photo!),
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
                              builder: (context) => EditAccountScreen(
                                    userInfo: dataController.getLocalData(),
                                    delete: true,
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
