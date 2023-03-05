import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_plus/controller/auth_controller.dart';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/localStorage/realm/data_models/chat.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:editable_image/editable_image.dart';
import 'package:page_transition/page_transition.dart';
import 'package:realm/realm.dart';

import '../controller/chat_controller.dart';
import '../localStorage/realm/realm_firestore_syncing.dart';
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

  late ChatController chatController;

  RealmChat? realmChat;

  Image? displayImage;

  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
    chatController = Get.put(ChatController());
    realmChat = getChatRealmObject(widget.chatId)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Group Info",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.black),
          ),
          leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: AppColors.white,
          centerTitle: true,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EditableImage(
                            imageDefaultColor: AppColors.grey,
                            imageDefaultBackgroundColor: AppColors.whitegrey,
                            onChange: (file) => _updateGroupPicture(file),
                            image: realmChat!.chatIcon != null &&
                                    realmChat!.chatIcon != ""
                                ? Image(
                                    image: CachedNetworkImageProvider(
                                        realmChat!.chatIcon))
                                : null,
                          ),
                          // CircleAvatar(
                          //   // to be changed
                          //   backgroundImage:
                          //       const AssetImage("assets/default_profile.jpg"),
                          //   radius: 60,
                          //   backgroundColor: AppColors.circle,
                          //   foregroundColor: AppColors.white,
                          // ),
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
                    const Text(
                      "Members",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      height: Get.height * 0.4,
                      child: ListView.builder(
                          itemCount: realmChat!.members.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return MemberTile(realmChat!.members[index]);
                          }),
                    ),
                    GestureDetector(
                      onTap: () {
                        chatController.leaveGroup(realmChat!.chatId,
                            auth.currentUser!.uid, realmChat!.chatName);
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRightPop,
                                child: NavBarView(index: 3),
                                childCurrent: GroupInfoScreen(
                                  chatId: widget.chatId,
                                )));
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.1,
                            ),
                          ),
                          child: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.redAccent,
                                ),
                                Text(
                                  "Leave ${realmChat!.chatName}",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ]))),
                    )
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

  Widget MemberTile(String member) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          margin: EdgeInsets.all(10),
          child: Text(
            member.split("_")[1],
            style: TextStyle(fontSize: 16),
          )),
      const Divider(),
    ]);
  }

  _updateGroupPicture(File? file) {
    if (file != null) {
      chatController.updateGroupIcon(file, widget.chatId);
      setState(() {
        displayImage = Image.file(file);
      });
    }
  }
}
