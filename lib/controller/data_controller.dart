import 'dart:collection';
import 'dart:io';
import 'dart:ui';

import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import '../views/edit_account_screen.dart';
import '../widgets/nav_bar.dart';

class DataController extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  Future getUserInfo() async {
    var data =
        await users.where("userId", isEqualTo: auth.currentUser!.uid).get();
    var data2 = data.docs.first.data() as Map<String, dynamic>;

    users.doc(auth.currentUser!.uid).update({
      'profilePictureURL': auth!.currentUser!.photoURL,
    });

    storedData = data2;

    return storedData;
  }

  late Map<String, dynamic> storedData = {};

  addUser(String? email, String? firstName, String? lastName,
      int? graduationYear, String? major, int? mobileNumber) {
    MyUser user = new MyUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      graduationYear: graduationYear,
      major: major,
      mobileNumber: mobileNumber,
    );
    user.addUser();
  }

  updateProfile(
      {String? firstName,
      String? lastName,
      String? major,
      int? graduationYear,
      int? mobileNumber,
      String? description,
      required BuildContext context,
      File? photo,
      required bool delete}) async {
    Map<dynamic, dynamic> userInfo = new HashMap();
    userInfo = getLocalData();
    MyUser user = new MyUser();
    user.updateUser(
        firstName: firstName,
        lastName: lastName,
        major: major,
        graduationYear: graduationYear,
        mobileNumber: mobileNumber,
        description: description);

    updateLocalData(
        firstName: firstName,
        lastName: lastName,
        major: major,
        graduationYear: graduationYear,
        mobileNumber: mobileNumber,
        description: description);

    if (delete) {
      await deleteProfilePicture();
    }
    print("delete = " + delete.toString());
    print(photo);
    if (!delete && photo != null) {
      print("will upload the picture");
      await uploadProfilePic(photo)
          .whenComplete(() => print("image uploaded"))
          .catchError(() => print("error uploading image"));
    }
    //dataController.getUserInfo();
    Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.topToBottomPop,
          child: NavBarView(index: 4),
          childCurrent: EditAccountScreen(
            userInfo: userInfo,
            delete: false,
            displayImage: photo == null ? null : Image.file(photo),
          ),
        ));
  }

  Map getLocalData() {
    if (storedData["description"] == null) {
      storedData["description"] = "";
    }
    return storedData;
  }

  updateLocalData({
    String? firstName,
    String? lastName,
    String? major,
    int? graduationYear,
    int? mobileNumber,
    String? description,
  }) {
    storedData["firstName"] = firstName;
    storedData["lastName"] = lastName;
    storedData["major"] = major;
    storedData["graduationYear"] = graduationYear;
    storedData["mobileNumber"] = mobileNumber;
    storedData["description"] = description;
  }

  clearLocalData() {
    storedData.clear();
  }

  Future<String> uploadProfilePic(File image) async {
    MyUser user = new MyUser();
    return user.uploadProfilePic(image);
  }

  deleteProfilePicture() async {
    MyUser user = new MyUser();
    user.deleteProfilePicture();
  }
}