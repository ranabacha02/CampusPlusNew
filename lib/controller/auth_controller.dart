
import 'dart:async';

import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


import '../views/signIn_signUp_screen.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  var isLoading = false.obs;

  void login({String? email, String? password}) {
    isLoading(true);

    auth
        .signInWithEmailAndPassword(email: email!, password: password!)
        .then((value) {
      /// Login Success
      isLoading(false);
      print("logged in");
      Get.to(() => NavBarView());
    }).catchError((e) {
      isLoading(false);
      Get.snackbar('Error', "$e");

      ///Error occurred
    });
  }
  void signUp(
      {String? email,
      String? password,
      String? firstName,
      String? lastName,
      int? graduationYear,
      String? major,
      int? mobileNumber}) {
    ///here we have to provide two things
    ///1- email
    ///2- password
    Timer timer;
    isLoading(true);

    auth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .then((value) async {
      isLoading(false);
      await auth.currentUser?.sendEmailVerification().then((value){
        Get.snackbar("Email verification sent to: "+email, "Please verify your e-mail.");
        
        timer = Timer.periodic(Duration(seconds: 3), (timer) async {
          auth.currentUser!.reload();
          if (auth.currentUser!.emailVerified){
            users.add({
              'email': email,
              'firstName': firstName,
              'lastName':lastName,
              'major': major,
              'mobilePhoneNumber':  mobileNumber,
              'graduationYear':graduationYear,
              'userId': auth.currentUser!.uid,
            }).then((value) => print("user added")).catchError((error) => print("Faile to add user: "+ error.toString()));
            /// Navigate user to profile screen
            Get.to(() => NavBarView());
            print("email verified");
            timer.cancel();
          }
          print("i am here");
        });
      });


    }).catchError((e) {
      /// print error information
      Get.snackbar("Error in authentication:", "$e");
      isLoading(false);
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

  void signOut() {
    isLoading(true);

    auth.signOut().then((value) {
      isLoading(false);
      Get.to(() => LoginView());
    }).catchError((e) {
      Get.snackbar('Error', "$e");
    });
    ;
  }
}
