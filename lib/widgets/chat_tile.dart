import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/views/chat_page_screen.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import '../controller/data_controller.dart';

class ChatTile extends StatefulWidget {
  //final String userName;
  final String groupId;
  final String expected;

  //final String groupName;

  ChatTile({Key? key, required this.groupId, required this.expected
      // required this.groupName,
      })
      : super(key: key);

  //late bool privateChat;

  @override
  State<ChatTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<ChatTile> {
  String? lastMessage;
  String? lastSender;
  String? imageURL;
  String? time;
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream? message;
  Stream? user;
  Stream? readStatus;
  String? groupName;

  late ChatController chatController;
  late DataController dataController;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    dataController = Get.put(DataController());
    initializing(widget.groupId);
  }

  initializing(String chatId) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    var value = await chatCollection.doc(chatId).get();
    String recipientId = "";
    for (String member in value["members"]) {
      if (member.split("_")[0] != auth!.currentUser!.uid) {
        recipientId = member.split("_")[0];
        break;
      }
    }
    var user = dataController.getLocalData();
    if (!value["isGroup"]) {
      if (value["chatName"].split("_")[0] ==
          user.firstName + " " + user.lastName) {
        groupName = value["chatName"].split("_")[1];
      } else {
        groupName = value["chatName"].split("_")[0];
      }
    } else {
      groupName = value["groupName"];
    }

    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    var data = await users.where("userId", isEqualTo: recipientId).get();
    print(recipientId);
    var data2 = data.docs.first.data() as Map<String, dynamic>;

    setState(() {
      message = chatCollection.doc(chatId).snapshots();
      readStatus = chatCollection
          .doc(chatId)
          .collection("readStatus")
          .doc(auth.currentUser!.uid)
          .snapshots();
      bool temp = !(value["isGroup"] as bool);
      imageURL = data2["profilePictureURL"];
      if (!temp) imageURL = null;
      // print(temp);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expected == null ||
        widget.expected == "" ||
        groupName!.toLowerCase().contains(widget.expected.toLowerCase())) {
      return StreamBuilder(
          stream: readStatus,
          builder: (context, AsyncSnapshot snapshot1) {
            return StreamBuilder(
                stream: message,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    try {
                      DateTime dateTime =
                          new DateTime.fromMillisecondsSinceEpoch(
                              int.parse(snapshot.data["recentMessageTime"]));
                      String time = "";
                      if (dateTime.minute < 10) {
                        time = dateTime.hour.toString() +
                            ":0" +
                            dateTime.minute.toString();
                      } else {
                        time = dateTime.hour.toString() +
                            ":" +
                            dateTime.minute.toString();
                      }
                    } catch (e) {
                      time = "";
                    }

                    return GestureDetector(
                      onTap: () {
                        chatController.markRead(widget.groupId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPageScreen(
                                      imageURL: imageURL,
                                      privateChat: snapshot.data["isGroup"],
                                      chatId: widget.groupId,
                                      chatName: groupName!,
                                    )));
                      },
                      onLongPress: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                  child: Container(
                                      child: new Wrap(children: <Widget>[
                                new ListTile(
                                    leading: new Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    title: new Text(
                                      'Delete \'' + groupName! + "\'",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onTap: () async {})
                              ])));
                            });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.circle,
                                width: 1,
                              ),
                            ),
                            color: snapshot1.hasData
                                ? snapshot1.data["unread"]
                                    ? AppColors.whitegrey
                                    : AppColors.white
                                : AppColors.white),
                        // color: AppColors.greychat,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: ListTile(
                          leading: UserProfilePicture(
                            imageURL: imageURL,
                            caption: groupName!,
                            radius: 25,
                            preview: false,
                          ),
                          title: Text(
                            groupName!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            recentMessage(snapshot),
                            maxLines: 2,
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: snapshot1.data["unreadNumber"] == 0
                              ? time == null
                                  ? Text("")
                                  : Text(time!)
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    time == null ? Text("") : Text(time!),
                                    Container(
                                        padding: EdgeInsets.only(top: 5),
                                        child: CircleAvatar(
                                          backgroundColor: AppColors.aubRed,
                                          radius: 10,
                                          child: Text(
                                            snapshot1.data["unreadNumber"]
                                                .toString(),
                                            style: TextStyle(
                                              color: AppColors.white,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(width: 0);
                  }
                });
          });
    } else {
      return Container();
    }
  }

  String recentMessage(AsyncSnapshot snapshot) {
    String result = "";

    String recentMessageSender = snapshot.data["recentMessageSender"];
    if (recentMessageSender != null && !recentMessageSender.isEmpty) {
      if (snapshot.data["recentMessageType"] == "image") {
        result = recentMessageSender.split("_")[0] +
            ": 📷 " +
            snapshot.data["recentMessage"];
      } else {
        result = recentMessageSender.split("_")[0] +
            ": " +
            snapshot.data["recentMessage"];
      }
    }
    return result;
  }
}
