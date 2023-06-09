import 'dart:async';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../localStorage/realm/data_models/chat.dart';
import '../localStorage/realm/realm_firestore_syncing.dart';
import '../views/signIn_signUp_screen.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  var isLoading = false.obs;

  Future signIn(
      {String? email, String? password, required BuildContext context}) async {
    isLoading(true);
    SharedPreferences pref = await SharedPreferences.getInstance();

    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) async {
      //Login Success
      isLoading(false);
      DataController dataController = Get.put(DataController());
      await dataController.getUserInfo();
      if (!auth.currentUser!.emailVerified) {
        Get.snackbar('Warning',
            'E-mail is not verified.\nPlease verify your email before proceeding.',
            colorText: Colors.white, backgroundColor: Colors.blue);
      } else {
        realmSyncing(auth.currentUser!.uid);
        pref.setString("email", email);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => NavBarView(
              index: 2,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }).catchError((e) {
      isLoading(false);
      //Get.snackbar('Error', "$e");
      throw (e);

      ///Error occurred
    });
  }

  void signUp(
      {String? email,
      String? password,
      String? firstName,
      String? lastName,
      String? gender,
      String? department,
      int? graduationYear,
      String? major,
      int? mobileNumber,
        String? nickname,}) {
    ///here we have to provide two things
    ///1- email
    ///2- password
    Timer timer;
    DataController dataController = Get.put(DataController());
    isLoading(true);

    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) async {
      isLoading(false);
      await auth.currentUser?.sendEmailVerification().then((value) {
        Get.snackbar("Email verification sent to: " + email,
            "Please verify your e-mail.");
        Get.to(() => LoginView());
        dataController.addUser(
            email, firstName, lastName, gender, department, graduationYear, major, mobileNumber, nickname);
      }).catchError((e) {
        /// print error information
        Get.snackbar("Error in authentication:", "$e");
        isLoading(false);
      });
    });
  }

  void verifyingEmail(
      {String? email,
      String? password,
      String? firstName,
      String? lastName,
      String? gender,
      String? department,
      int? graduationYear,
      String? major,
      int? mobileNumber,
        String? nickname}) {
    DataController dataController = Get.put(DataController());
    int n = 0;
    Timer timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      n++;
      auth.currentUser!.reload();
      if (auth.currentUser!.emailVerified) {
        dataController.addUser(
            email, firstName, lastName, gender, department, graduationYear, major, mobileNumber, nickname);
        auth.currentUser?.updateDisplayName(firstName! + " " + lastName!);

        /// Navigate user to profile screen
        Get.to(() => NavBarView(index: 2));
        print("email verified");
        timer.cancel();
      }
      if (n > 100) {
        timer.cancel();
      }
    });
  }

  void forgetPassword(String email) {
    auth.sendPasswordResetEmail(email: email).then((value) {
      Get.back();
      Get.snackbar('Email Sent', 'We have sent password reset email');
    }).catchError((e) {
      print("Error in sending password reset email is $e");
    });
  }

  Future<void> signOut() async {
    isLoading(true);
    SharedPreferences pref = await SharedPreferences.getInstance();

    cancelStreams();

    //DO NOT UNCOMMENT UNLESS YOU WANT TO DELETE ALL THE CHATS IN THE REALM DATABASE

// final realm =getRealmObject();
//
//     realm.write(() {
//       realm.deleteAll<RealmChat>();
//       realm.deleteAll<RealmMessage>();
//     });

    print(realm.all<RealmChat>());
    print(realm.all<RealmMessage>());

    auth.signOut().then((value) {
      isLoading(false);
      pref.remove("email");
      DataController dataController = Get.put(DataController());
      dataController.clearLocalData();
    }).catchError((e) {
      Get.snackbar('Error', "$e");
    });
  }
}

class EmailFieldValidator {
  static String? validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String? validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}
