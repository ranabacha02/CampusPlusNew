import 'dart:io';

import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/views/profile_screen.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:page_transition/page_transition.dart';

import '../views/edit_account_screen.dart';

class EditProfileController extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;

  updateProfile(
      {String? firstName,
      String? lastName,
      String? major,
      int? graduationYear,
      int? mobileNumber,
      required BuildContext context,
      required Map<String, dynamic> userInfo,
      File? photo,
      required bool delete}) async {
    DataController dataController = Get.put(DataController());
    users.doc(auth.currentUser!.uid).set({
      'email': userInfo["email"],
      'firstName': firstName,
      'lastName': lastName,
      'major': major,
      'mobilePhoneNumber': mobileNumber,
      'graduationYear': graduationYear,
      'userId': auth.currentUser!.uid,
    }).then((value) async {
      print("user updated");

      userInfo["firstName"] = firstName;
      userInfo["lastName"] = lastName;
      userInfo["major"] = major;
      userInfo["graduationYear"] = graduationYear;
      userInfo["mobilePhoneNumber"] = mobileNumber;

      if (delete) {
        await dataController.deleteProfilePicture();
      }
      print("delete = " + delete.toString());
      print(photo);
      if (!delete && photo != null) {
        print("will upload the picture");
        await dataController
            .uploadProfilePic(photo)
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
              displayImage: photo.isNull ? null : Image.file(photo!),
            ),
          ));
    }).catchError(
        (error) => print("Failed to update user info: " + error.toString()));
  }
}
