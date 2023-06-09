import 'dart:io';

import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:campus_plus/views/profile_screen.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:page_transition/page_transition.dart';
import 'package:realm/realm.dart';

import '../localStorage/realm/data_models/realmUser.dart';
import '../views/edit_account_screen.dart';

class EditAvatarController extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;

  updateAvatar(
      {String? nickname,
        required BuildContext context,
        required MyUser userInfo,
        File? avatarphoto,
        required bool deleteavatar}) async {
    DataController dataController = Get.put(DataController());
    users.doc(auth.currentUser!.uid).set({
      'email': userInfo.email,
      'nickname': nickname,
      'userId': auth.currentUser!.uid,
      'chatsId': userInfo.chatsId,
    }).then((value) async {
      userInfo.nickname = nickname ?? userInfo.nickname;


      if (deleteavatar) {
        await dataController.deleteAvatarPicture();
      }
      if (!deleteavatar && avatarphoto != null) {
        await dataController
            .uploadAvatarPic(avatarphoto)
            .whenComplete(() => print("image uploaded"))
            .catchError(() => print("error uploading image"));
      }

      //dataController.getUserInfo();
      Navigator.pushReplacement(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTopJoined,
            child: NavBarView(index: 4),
            childCurrent: EditAccountScreen(
              userInfo: userInfo,
              delete: false,
              displayImage: avatarphoto.isNull ? null : Image.file(avatarphoto!),
            ),
          ));
    }).catchError(
            (error) => print("Failed to update user info: " + error.toString()));
  }
}
