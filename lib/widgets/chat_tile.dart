import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/views/chat_page_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatTile extends StatefulWidget {
  //final String userName;
  final String groupId;
  final String groupName;

  const ChatTile({Key? key, required this.groupId, required this.groupName})
      : super(key: key);

  @override
  State<ChatTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<ChatTile> {
  String? lastMessage;
  String? lastSender;

  @override
  void initState() {
    super.initState();
    getLastMessage(widget.groupId);
    getLastMessageSender(widget.groupId);
  }

  getLastMessage(String chatId) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    var value = await chatCollection.doc(chatId).get();
    //return value["recentMessage"];
    setState(() {
      lastMessage = value["recentMessage"];
    });
  }

  getLastMessageSender(String chatId) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    var value = await chatCollection.doc(chatId).get();
    //return value["recentMessage"];
    setState(() {
      lastSender = value["recentMessageSender"].split("_")[0];
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
                      chatId: widget.groupId,
                      chatName: widget.groupName,
                    )));
      },
      child: Container(
        color: AppColors.greychat,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500),
            ),
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
        ),
      ),
    );
  }
}
