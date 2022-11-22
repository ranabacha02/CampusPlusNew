import 'package:campus_plus/widgets/app_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/auth_controller.dart';
import '../controller/chat_controller.dart';
import '../controller/data_controller.dart';
import '../utils/app_colors.dart';
import 'nav_bar.dart';

class NewChatScreen extends StatefulWidget {
  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('Users').snapshots();
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  FirebaseAuth auth = FirebaseAuth.instance;

  late ChatController chatController;
  late AuthController authController;
  late DataController dataController;
  late final userInfo;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "New Chat",
              style: TextStyle(
                fontSize: 30,
                color: AppColors.aubRed,
              ),
            )),
        body: Material(
          type: MaterialType.transparency,
          child: Container(
              color: AppColors.white,
              child: StreamBuilder<QuerySnapshot>(
                stream: users,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading');
                  }
                  final data = snapshot.requireData;
                  return ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      if (data.docs[index]['userId'] != auth.currentUser!.uid) {
                        return userProfile(
                            data.docs[index]['firstName'] +
                                " " +
                                data.docs[index]['lastName'],
                            data.docs[index]['major'],
                            data.docs[index]['graduationYear'],
                            data.docs[index]['userId']);
                      } else {
                        return SizedBox(
                          height: 0,
                        );
                      }
                    },
                  );
                },
              )),
        ));
  }

  userProfile(String userName, String major, int graduationYear, String uid) {
    return Container(
        height: 105,
        child: Column(
          children: [
            ListTile(
                leading: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/default_profile.jpg"),
                  backgroundColor: AppColors.circle,
                  foregroundColor: AppColors.white,
                ),
                title: Text(
                  userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                subtitle: Row(
                  children: [
                    SizedBox(width: 5),
                    Text(
                      major + " | " + graduationYear.toString(),
                      style: TextStyle(color: AppColors.grey, fontSize: 15),
                    ),
                    new Spacer(),
                    elevatedButton(
                        text: "Chat",
                        onpress: () {
                          //create a new chat between the users and redirect them to the chat page
                          chatController.newChat(false, null, [uid]);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavBarView(
                                        index: 3,
                                      )));
                        })
                  ],
                )),
            Divider(),
          ],
        ));
  }
}
