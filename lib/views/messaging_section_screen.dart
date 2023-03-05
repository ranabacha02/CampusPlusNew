import 'package:campus_plus/controller/auth_controller.dart';
import 'package:campus_plus/controller/chat_controller.dart';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/model/chat_model.dart';
import 'package:campus_plus/views/new_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:realm/realm.dart';

import '../model/user_model.dart';
import '../localStorage/realm/data_models/chat.dart';
import '../localStorage/realm/data_models/realmUser.dart';
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
  late final MyUser userInfo;
  Stream? userSnapshot;
  List<Chat> chats = [];
  String name = "";
  Stream<RealmObjectChanges<RealmUser>>? realmStreamUser;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
    gettingChats();
   // chatController.getLocalChatMessagesSizes();
    getLiveObject();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingChats() {
    ChatController().getChatsId().then((snapshot) {
      setState(() {
        userSnapshot = snapshot;
      });
    });
  }

  getLiveObject() async {
    realmStreamUser = await dataController.getLiveRealmUserObject();
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
          child: Column(
            children: [
              Card(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                ),
                elevation: 0,
              ),
              groupList(name),
            ],
          ),
        ));
  }

  groupList(String name) {
    if (realmStreamUser != null) {
      return StreamBuilder(
        stream: realmStreamUser,
        builder:
            (context, AsyncSnapshot<RealmObjectChanges<RealmUser>> snapshot) {
          // make some checks
          if (snapshot.hasData) {
            if (snapshot.requireData.object.chatsId != null) {
              if (snapshot.requireData.object.chatsId.isNotEmpty) {
                return Expanded(
                    child: ListView.builder(
                  itemCount: snapshot.requireData.object.chatsId.length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.requireData.object.chatsId.length - index - 1;
                    return ChatTile(
                      groupId: getId(
                          snapshot.requireData.object.chatsId[reverseIndex]),
                      expected: name,
                    );
                  },
                ));
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
    } else {
      return Expanded(
          child: Center(
        child: CircularProgressIndicator(color: AppColors.aubRed),
      ));
    }
  }

  noGroupWidget() {
    return const Expanded(
      child: Center(
        child: Text(
          "You don't have any chat at the moment. Press on the add icon to search for other students or groups.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
