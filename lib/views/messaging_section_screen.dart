import 'package:campus_plus/controller/auth_controller.dart';
import 'package:campus_plus/controller/chat_controller.dart';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/views/new_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/app_colors.dart';
import '../widgets/chat_tile.dart';

class MessagingSectionScreen extends StatefulWidget {
  @override
  _MessagingSectionScreenState createState() => _MessagingSectionScreenState();
}

class _MessagingSectionScreenState extends State<MessagingSectionScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;

  late ChatController chatController;
  late AuthController authController;
  late DataController dataController;
  late final userInfo;
  Stream? chats;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
    gettingChats();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingChats() async {
    await ChatController().getChatsId().then((snapshot) {
      setState(() {
        chats = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.white,
          title: Text(
            "Chats",
            style: TextStyle(
              fontSize: 30,
              color: AppColors.aubRed,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewChatScreen())).then((value) {
                    setState(() {
                      gettingChats();
                    });
                  });
                },
                icon: Icon(
                  Icons.add,
                  color: AppColors.aubRed,
                  size: 35,
                ))
          ],
        ),
        body: Material(
          type: MaterialType.transparency,
          child: groupList(),
        ));
  }

  groupList() {
    return StreamBuilder(
      initialData: chats,
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        // make some checks
        if (snapshot.hasData) {
          if (snapshot.data['chatsId'] != null) {
            if (snapshot.data['chatsId'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['chatsId'].length,
                itemBuilder: (context, index) {
                  int reverseIndex =
                      snapshot.data['chatsId'].length - index - 1;
                  return ChatTile(
                    groupId: getId(snapshot.data['chatsId'][reverseIndex]),
                    groupName: getName(snapshot.data['chatsId'][reverseIndex]),
                    // lastMessage:  getLastMessage(snapshot.data['chatsId'][reverseIndex]),
                    // lastSender: getLastMessage(snapshot.data['chatsId'][reverseIndex]),
                  );
                },
              );
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor),
          );
        }
      },
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Text(
          "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
