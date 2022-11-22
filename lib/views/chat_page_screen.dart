import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/chat_controller.dart';
import '../controller/data_controller.dart';
import '../widgets/message_tile.dart';

class ChatPageScreen extends StatefulWidget {
  String chatId;
  String chatName;

  ChatPageScreen({super.key, required this.chatId, required this.chatName});

  @override
  _ChatPageScreenState createState() => _ChatPageScreenState();
}

class _ChatPageScreenState extends State<ChatPageScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;

  TextEditingController messageController = TextEditingController();

  late ChatController chatController;
  late DataController dataController;
  late final userInfo;
  late final userName;
  Stream? chats;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
    userName = userInfo['firstName'] + " " + userInfo['lastName'];
    getChat();
  }

  getChat() {
    chatController.getChats(widget.chatId).then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => NavBarView(index: 3))),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/default_profile.jpg"),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              widget.chatName,
              style: TextStyle(color: AppColors.aubRed, fontSize: 24),
            ),
          ],
        ),
        backgroundColor: AppColors.white,
      ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Send a message...",
                    hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  print("the message is: " +
                      snapshot.data.docs[index]['message']);
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: userName + "_" + userInfo['userId'] ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": userName + "_" + userInfo['userId'],
        "time": DateTime.now().millisecondsSinceEpoch,
      };

      chatController.sendMessage(widget.chatId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
