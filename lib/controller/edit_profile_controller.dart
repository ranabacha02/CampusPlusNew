import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/views/profile_screen.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:page_transition/page_transition.dart';

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
      required Map<String, dynamic> userInfo}) async {
    // DataController dataController = DataController();
    // var userInfo = dataController.getLocalData();
    users.doc(auth.currentUser!.uid).set({
      'email': userInfo["email"],
      'firstName': firstName,
      'lastName': lastName,
      'major': major,
      'mobilePhoneNumber': mobileNumber,
      'graduationYear': graduationYear,
      'userId': auth.currentUser!.uid,
    }).then((value) {
      print("user updated");
      // dataController.setLocalData({
      //   'email': userInfo["email"],
      //   'firstName': firstName,
      //   'lastName': lastName,
      //   'major': major,
      //   'mobilePhoneNumber': mobileNumber,
      //   'graduationYear': graduationYear,
      //   'userId': auth.currentUser!.uid,
      // });
      userInfo["firstName"] = firstName;
      userInfo["lastName"] = lastName;
      userInfo["major"] = major;
      userInfo["graduationYear"] = graduationYear;
      userInfo["mobilePhoneNumber"] = mobileNumber;
      //dataController.getUserInfo();
      Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.topToBottom,
            child: NavBarView(index: 4),
          ));
    }).catchError(
        (error) => print("Failed to update user info: " + error.toString()));
  }
}
