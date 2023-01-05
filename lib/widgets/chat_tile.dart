import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/views/chat_page_screen.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatTile extends StatefulWidget {
  //final String userName;
  final String groupId;
  final String groupName;

  ChatTile({
    Key? key,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  late bool privateChat;

  @override
  State<ChatTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<ChatTile> {
  String? lastMessage;
  String? lastSender;
  String? imageURL;
  String? time;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
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
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    var data = await users.where("userId", isEqualTo: recipientId).get();
    var data2 = data.docs.first.data() as Map<String, dynamic>;
    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(
        int.parse(value["recentMessageTime"]));
    setState(() {
      lastMessage = value["recentMessage"];
      lastSender = value["recentMessageSender"].split("_")[0];
      if (dateTime.minute < 10) {
        time = dateTime.hour.toString() + ":0" + dateTime.minute.toString();
      } else {
        time = dateTime.hour.toString() + ":" + dateTime.minute.toString();
      }
      widget.privateChat = !(value["isGroup"] as bool);
      imageURL = data2["profilePictureURL"];
      //print ("data2: " + data2.toString());
      if (!widget.privateChat) imageURL = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPageScreen(
                      imageURL: imageURL,
                      privateChat: widget.privateChat,
                      chatId: widget.groupId,
                      chatName: widget.groupName,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: AppColors.circle,
            width: 1,
          ),
        )),
        // color: AppColors.greychat,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: imageURL != null && imageURL != ""
              ? UserProfilePicture(
                  imageURL: imageURL,
                )
              : CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/default_profile.jpg"),
                ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: lastMessage.isNull
              ? Text("")
              : Text(
                  lastSender! + ": " + lastMessage!,
                  style: const TextStyle(fontSize: 13),
                ),
          trailing: time == null ? Text("") : Text(time!),
        ),
      ),
    );
  }
}
