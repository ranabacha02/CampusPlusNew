import 'package:campus_plus/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../widgets/app_widgets.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;

  late AuthController authController;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Container(
            color: AppColors.grey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: Text(
                  "Profile Screen In Progress...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                )),
                Obx(() => authController.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(
                          vertical: Get.height * 0.03,
                        ),
                        width: Get.width,
                        child: elevatedButton(
                            text: 'Sign out',
                            onpress: () {
                              authController.signOut();
                            }))),
                Text(
                  "User Name: " +
                      users
                          .where("userId", isEqualTo: auth.currentUser!.uid)
                          .get()
                          .then((value) => value.docs.first.data())
                          .toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                )
              ],
            )));
  }
}
