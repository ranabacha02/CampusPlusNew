import 'dart:io';

import 'package:campus_plus/controller/auth_controller.dart';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/widgets/image_file_picker.dart';
import 'package:campus_plus/views/account_settings_screen.dart';
import 'package:campus_plus/views/tutoring_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../utils/app_colors.dart';
import '../widgets/app_widgets.dart';
import 'package:get/get.dart';

import 'edit_account_screen.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

  Image? displayImage;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
  }

  @override
  Widget build(BuildContext context) {
    //print(userInfo.toString());
    //print(auth.currentUser!.photoURL);
    if (auth.currentUser!.photoURL != null) {
      displayImage = Image.network(auth.currentUser!.photoURL!);
    } else {
      AssetImage("assets/default_profile.jpg");
    }

    //print("display image in profile screen: " + displayImage.toString());
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
        body: Material(
            type: MaterialType.transparency,
            child: SingleChildScrollView(
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                        Text(
                          "Profile",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 25,
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () => {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: EditAccountScreen(
                                          userInfo: userInfo,
                                          delete: false,
                                          // photo: auth.currentUser!.photoURL != null ?
                                          //  _fileFromImageUrl(auth.currentUser!.photoURL ):
                                          // null,
                                          displayImage: displayImage,
                                        ),
                                      ))
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: AppColors.black,
                                ))
                          ],
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
                                backgroundImage: auth.currentUser!.photoURL != null
                                    ? NetworkImage(auth.currentUser!.photoURL!)
                                    : AssetImage("assets/default_profile.jpg")
                                as ImageProvider,
                                radius: 60,
                                backgroundColor: AppColors.circle,
                                foregroundColor: AppColors.white,
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
                                "" +
                                    userInfo?["major"] +
                                    " | " +
                                    userInfo["graduationYear"].toString() ??
                                "",
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
                              userInfo?["description"] == ""
                                  ? "Description here..."
                                  : userInfo?["description"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.grey,
                                  fontStyle: FontStyle.italic))
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
                            onpress: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccountSettingsScreen()))
                            },
                            //width: 0.492,
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
                            onpress: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AccountSettingsScreen()))
                            },
                            //width: 0.512,
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
                            onpress: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          TutoringProfileScreen()))
                            },
                            // width: 0.482,
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
                        onpress: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AccountSettingsScreen()))
                        }, //0.513
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
            ))));
  }

  Future<File> _fileFromImageUrl(var url) async {
    final response = await http.get(Uri.parse(url));

    final documentDirectory = await getApplicationDocumentsDirectory();

    final file = File(join(documentDirectory.path, auth.currentUser!.uid));

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }
}
