import 'package:campus_plus/controller/auth_controller.dart';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/views/account_settings_screen.dart';
import 'package:campus_plus/views/tutoring_profile.dart';
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

  late DataController dataController;
  late final userInfo;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0.2,
          title: Text(
            "CAMPUS+",
            style: TextStyle(
              fontSize: 30,
              color: AppColors.aubRed,
            ),
          ),
        ),
        body:  Material(
                    type: MaterialType.transparency,
                    child: Container(
                      color: AppColors.white,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Text(
                              "Profile",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 25,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Divider(
                              color: AppColors.black,
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    // to be changed
                                    radius: 50,
                                    backgroundColor: AppColors.circle,
                                    foregroundColor: AppColors.white,
                                    child: Text(
                                      userInfo?["firstName"][0] +  userInfo?["lastName"][0],
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 40,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.01,
                                  ),
                                  Text(
                                    userInfo?["firstName"] +
                                        " " +
                                        userInfo?["lastName"],
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "" + userInfo?["major"] + " | " +userInfo["graduationYear"].toString()??"",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.01,
                                  ),
                                  Text(
                                    "Description here...",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.grey,
                                      fontStyle: FontStyle.italic
                                    )
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(
                                vertical: Get.height * 0.005,
                              ),
                              width: Get.width,
                              child: buttonWithRightIcon(
                                text: "Recent Activity",
                                onpress:() => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  AccountSettingsScreen())
                                  )
                                },
                                width: 0.492,
                              ),
                            ),
                            Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(
                                vertical: Get.height * 0.005,
                              ),
                              width: Get.width,
                              child: buttonWithRightIcon(
                                text: "Followed Tags",
                                onpress:() => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  AccountSettingsScreen())
                                  )
                                },
                                width: 0.512,
                              ),
                            ),

                            Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(
                                vertical: Get.height * 0.005,
                              ),
                              width: Get.width,
                              child: buttonWithRightIcon(
                                text: "Tutoring Profile",
                                onpress:() => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  TutoringProfileScreen())
                                  )
                                },
                                width: 0.482,
                              ),
                            ),
                            Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(
                                vertical: Get.height * 0.005,
                              ),
                              width: Get.width,
                              child: buttonWithRightIcon(
                                text: "Rental Profile",
                                onpress:() => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  AccountSettingsScreen())
                                  )
                                },
                                width: 0.513,
                              ),
                            ),


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
                                    child: buttonWithLeftIcon(
                                        text: 'Sign out',
                                        onpress: () {
                                          authController.signOut();
                                        },
                                      icon: Icons.logout,
                                    ))),
                          ],
                        ),
                      ),
                    )
                )
            );
  }
}
