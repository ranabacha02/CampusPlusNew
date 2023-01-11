import 'dart:io';

import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/views/chat_image_preview.dart';
import 'package:campus_plus/views/edit_account_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:page_transition/page_transition.dart';

import '../utils/app_colors.dart';

class ChatFileUploads extends StatefulWidget {
  String chatId;
  String chatName;
  String? imageUrl;
  bool privateChat;

  ChatFileUploads(
      {required this.chatId,
      required this.chatName,
      required this.imageUrl,
      required this.privateChat});

  @override
  _ChatFileUploadsState createState() => _ChatFileUploadsState();
}

class _ChatFileUploadsState extends State<ChatFileUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late DataController dataController;
  FirebaseAuth auth = FirebaseAuth.instance;

  File? photo;

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
    return IconButton(
      icon: Icon(Icons.photo_camera),
      onPressed: () {
        _showPicker(context);
      },
    );
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
                          PageTransition(
                            type: PageTransitionType.topToBottomPop,
                            child: ChatImagePreview(
                              image: photo!,
                              chatName: widget.chatName,
                              chatId: widget.chatId,
                              imageUrl: widget.imageUrl,
                              privateChat: widget.privateChat,
                            ),
                            childCurrent: EditAccountScreen(
                                userInfo: dataController.getLocalData(),
                                delete: false),
                          ),
                        );
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () async {
                      File? photo = await imgFromCamera();
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.topToBottomPop,
                          child: ChatImagePreview(
                            image: photo!,
                            chatName: widget.chatName,
                            chatId: widget.chatId,
                            imageUrl: widget.imageUrl,
                            privateChat: widget.privateChat,
                          ),
                          childCurrent: EditAccountScreen(
                              userInfo: dataController.getLocalData(),
                              delete: false),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
