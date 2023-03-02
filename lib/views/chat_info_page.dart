import 'dart:io';

import 'package:campus_plus/controller/auth_controller.dart';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/localStorage/realm/data_models/chat.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:realm/realm.dart';

import '../utils/app_colors.dart';
import 'package:get/get.dart';


import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class GroupInfoScreen extends StatefulWidget {
  final String chatId;

  GroupInfoScreen({Key? key, required this.chatId}) : super(key: key);
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;

  @override
  _GroupInfoScreenState createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  late AuthController authController;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;

  late DataController dataController;

  late RealmChat? realmChat;

  Image? displayImage;

  @override
  void initState() {
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    final config = Configuration.local([RealmChat.schema, RealmMessage.schema]);
    final realm = Realm(config);
    realmChat = realm.find<RealmChat>(widget.chatId)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          centerTitle: false,
          elevation: 0.2,
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
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            // to be changed
                            backgroundImage:
                                AssetImage("assets/default_profile.jpg")
                                    as ImageProvider,
                            radius: 60,
                            backgroundColor: AppColors.circle,
                            foregroundColor: AppColors.white,
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Text(
                            realmChat != null ? realmChat!.chatName : "",
                            style: TextStyle(
                                fontSize: 30,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Text(
                      "Members",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ListView.builder(itemBuilder: (context, index) {
                      return Text(realmChat!.members[index]);
                    }),
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
