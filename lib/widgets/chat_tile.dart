import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/views/chat_page_screen.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';

class ChatTile extends StatefulWidget {
  //final String userName;
  final String groupId;
  final String groupName;

  ChatTile({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

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

  late ChatController chatController;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
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
    // try{
    // var readStatusSnap = await chatController.getReadStatus(chatId);
    // readStatus  = readStatusSnap["unread"];}catch(e){
    //   print("field not found" + widget.groupName);
    // }
    // print("readStatus");
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    var data = await users.where("userId", isEqualTo: recipientId).get();
    var data2 = data.docs.first.data() as Map<String, dynamic>;
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(value["recentMessageTime"]));
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
    return StreamBuilder(
        stream: readStatus,
        builder: (context, AsyncSnapshot snapshot1) {
          return StreamBuilder(
              stream: message,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(
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
                                    chatName: widget.groupName,
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
                                    'Delete \'' + widget.groupName + "\'",
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
                          caption: widget.groupName,
                          radius: 25,
                          preview: false,
                        ),
                        title: Text(
                          widget.groupName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: snapshot.data["recentMessageSender"]
                                    .split("_")[0] ==
                                null
                            ? Text("")
                            : Text(
                                snapshot.data["recentMessageSender"]
                                        .split("_")[0]! +
                                    ": " +
                                    snapshot.data["recentMessage"]!,
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
                                  Text(time!),
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
  }
}
