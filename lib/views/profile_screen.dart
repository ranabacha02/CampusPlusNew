import 'package:campus_plus/controller/auth_controller.dart';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/views/account_settings_screen.dart';
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

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
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
        body: FutureBuilder(
            future: dataController.getUserInfo(),
            builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              String graduationYear= snapshot.data?["graduationYear"].toString()??"";

              if (snapshot.connectionState == ConnectionState.done) {
                return Material(
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
                                      'XX',
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
                                    snapshot.data?["firstName"] +
                                        " " +
                                        snapshot.data?["lastName"],
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "" + snapshot.data?["major"] + " | " +graduationYear,
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
                                vertical: Get.height * 0.03,
                              ),
                              width: Get.width,
                              child: buttonWithRightIcon(
                                text: "Account Settings",
                                onpress:() => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  AccountSettingsScreen())
                                  )
                                },
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
                                    child: elevatedButton(
                                        text: 'Sign out',
                                        onpress: () {
                                          authController.signOut();
                                        }))),
                            Text(
                              // "User Name: " + dataController.getUserInfo().then((value) => print(value)).toString(),
                              "User Name: " + snapshot.data?["firstName"],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                    ));
              } else if (snapshot.connectionState == ConnectionState.none) {
                return const Text("No data");
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
}
