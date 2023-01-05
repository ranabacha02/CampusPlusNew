import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/widgets/chat_date_tile.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:campus_plus/widgets/received_message_tile.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';

import '../controller/chat_controller.dart';
import '../controller/data_controller.dart';
import '../widgets/message_tile.dart';

class ChatPageScreen extends StatefulWidget {
  String chatId;
  String chatName;
  bool privateChat;
  String? imageURL;

  ChatPageScreen(
      {super.key,
      required this.chatId,
      required this.chatName,
      required this.privateChat,
      required this.imageURL});

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
            onPressed: () => Navigator.push(
                context,
                //MaterialPageRoute(builder: (context) => NavBarView(index: 3))),
                PageTransition(
                    type: PageTransitionType.leftToRightPop,
                    child: NavBarView(index: 3),
                    childCurrent: ChatPageScreen(
                      imageURL: widget.imageURL,
                      privateChat: widget.privateChat,
                      chatId: widget.chatId,
                      chatName: widget.chatName,
                    )))),
        title: Row(
          children: [
            widget.imageURL != null
                ? UserProfilePicture(
                    imageURL: widget.imageURL,
                  )
                : CircleAvatar(
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
        fit: StackFit.passthrough,
        children: <Widget>[
          // chat messages here
          chatMessages(widget.privateChat),
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

  chatMessages(bool privateChat) {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        String previousSender = "";
        return snapshot.hasData
            ? Container(
                height: Get.height - 170,
                child: ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    print("the message is: " +
                        snapshot.data.docs[index]['message']);
                    DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(
                        snapshot.data.docs[index]['time']);
                    DateTime dateTime2 = DateTime.now();
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

                    String currentDate = DateFormat.yMMMEd().format(dateTime);

                    String currentSender = snapshot.data.docs[index]['sender'];
                    String nextSender = "";
                    try {
                      nextSender = snapshot.data.docs[index + 1]['sender'];
                      dateTime2 = new DateTime.fromMillisecondsSinceEpoch(
                          snapshot.data.docs[index + 1]['time']);
                    } catch (e) {
                      nextSender = "";
                    }
                    String nextDate = DateFormat.yMMMEd().format(dateTime2);

                    if (userName + "_" + userInfo['userId'] != currentSender) {
                      bool temp = nextSender == currentSender;
                      previousSender = currentSender;
                      if (nextDate != currentDate) {
                        return Column(
                          children: [
                            chatDateTile(currentDate),
                            ReceivedMessageTile(
                              privateChat: privateChat,
                              message: snapshot.data.docs[index]['message'],
                              sender: snapshot.data.docs[index]['sender'],
                              time: time,
                              sameSender: temp,
                            )
                          ],
                        );
                      }
                      return ReceivedMessageTile(
                        privateChat: privateChat,
                        message: snapshot.data.docs[index]['message'],
                        sender: snapshot.data.docs[index]['sender'],
                        time: time,
                        sameSender: temp,
                      );
                    }

                    previousSender = currentSender;
                    print("time:" + time);
                    if (nextDate != currentDate) {
                      return Column(
                        children: [
                          chatDateTile(currentDate),
                          MessageTile(
                              privateChat: privateChat,
                              message: snapshot.data.docs[index]['message'],
                              sender: snapshot.data.docs[index]['sender'],
                              time: time)
                        ],
                      );
                    }
                    return MessageTile(
                        privateChat: privateChat,
                        message: snapshot.data.docs[index]['message'],
                        sender: snapshot.data.docs[index]['sender'],
                        time: time);
                  },
            ))
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
