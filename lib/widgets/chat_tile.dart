import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/views/chat_page_screen.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import '../controller/data_controller.dart';

class ChatTile extends StatefulWidget {
  //final String userName;
  final String chatId;
  final String expected;

  //final String groupName;

  const ChatTile({Key? key, required this.chatId, required this.expected
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
  String? chatName;

  late ChatController chatController;
  late DataController dataController;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    dataController = Get.put(DataController());
    initializing(widget.chatId);
  }

  initializing(String chatId) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    var chat = await chatCollection.doc(chatId).get();
    String recipientId = "";
    for (String member in chat["members"]) {
      if (member.split("_")[0] != auth.currentUser!.uid) {
        recipientId = member.split("_")[0];
        break;
      }
    }

    if (recipientId != "") {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Users');
      var data = await users.where("userId", isEqualTo: recipientId).get();
      var data2 = data.docs.first.data() as Map<String, dynamic>;

      setState(() {
        message = chatCollection.doc(chatId).snapshots();
        readStatus = chatCollection
            .doc(chatId)
            .collection("readStatus")
            .doc(auth.currentUser!.uid)
            .snapshots();
        if (chat["isGroup"] as bool) {
          chatName = chat["chatName"];
          imageURL = chat["chatIcon"];
        } else {
          chatName = "${data2["firstName"]} ${data2["lastName"]}";
          imageURL = data2["profilePictureURL"];
        }
      });
    } else {
      chatName = chat["chatName"];
      setState(() {
        message = chatCollection.doc(chatId).snapshots();
        readStatus = chatCollection
            .doc(chatId)
            .collection("readStatus")
            .doc(auth.currentUser!.uid)
            .snapshots();
        imageURL = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expected == "" ||
        chatName!.toLowerCase().contains(widget.expected.toLowerCase())) {
      return StreamBuilder(
          stream: readStatus,
          builder: (context, AsyncSnapshot snapshot1) {
            return StreamBuilder(
                stream: message,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData & snapshot1.hasData) {
                    try {
                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                          int.parse(snapshot.data["recentMessageTime"]));
                      if (dateTime.minute < 10) {
                        time = "${dateTime.hour}:0${dateTime.minute}";
                      } else {
                        time = "${dateTime.hour}:${dateTime.minute}";
                      }
                    } catch (e) {
                      time = "";
                    }

                    return GestureDetector(
                      onTap: () {
                        chatController.markRead(widget.chatId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPageScreen(
                                      imageURL: imageURL,
                                      privateChat: snapshot.data["isGroup"],
                                      chatId: widget.chatId,
                                      chatName: chatName!,
                                    )));
                      },
                      onLongPress: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                  child: Wrap(children: <Widget>[
                                ListTile(
                                    leading: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      'Delete "$chatName"',
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    onTap: () async {})
                              ]));
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
                            caption: chatName!,
                            radius: 25,
                            preview: false,
                          ),
                          title: Text(
                            chatName!,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            recentMessage(snapshot),
                            maxLines: 2,
                            style: const TextStyle(fontSize: 13),
                          ),
                          trailing: snapshot1.data["unreadNumber"] == 0
                              ? time == null
                                  ? const Text("")
                                  : Text(time!)
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    time == null ? const Text("") : Text(time!),
                                    Container(
                                        padding: const EdgeInsets.only(top: 5),
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
                    return const SizedBox(width: 0);
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
    if (recentMessageSender.isNotEmpty) {
      if (snapshot.data["recentMessageType"] == "image") {
        result =
            "${recentMessageSender.split("_")[0]}: 📷 ${snapshot.data["recentMessage"]}";
      } else {
        result =
            "${recentMessageSender.split("_")[0]}: ${snapshot.data["recentMessage"]}";
      }
    }
    return result;
  }
}