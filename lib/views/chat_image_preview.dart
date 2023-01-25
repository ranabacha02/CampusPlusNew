import 'dart:io';

import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:page_transition/page_transition.dart';

import '../controller/chat_controller.dart';
import '../controller/data_controller.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart';
import 'chat_page_screen.dart';

class ChatImagePreview extends StatefulWidget {
  String chatId;
  String chatName;
  String? imageUrl;
  bool privateChat;
  final File image;

  ChatImagePreview(
      {required this.image,
      required this.chatId,
      required this.chatName,
      required this.imageUrl,
      required this.privateChat});

  @override
  _ChatImagePreviewState createState() => _ChatImagePreviewState();
}

class _ChatImagePreviewState extends State<ChatImagePreview> {
  TextEditingController messageController = TextEditingController();

  late ChatController chatController;
  late DataController dataController;
  late final MyUser userInfo;
  late final userName;
  Stream? chats;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
    userName = userInfo.firstName + " " + userInfo.lastName;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.white,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: AppColors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              "To " + widget.chatName,
              style: TextStyle(
                fontSize: 24,
                color: AppColors.black,
              ),
            ),
          ),
          body: Stack(children: [
            Center(
              child: Image.file(widget.image),
            ),
            Container(
              child: Column(
                children: [
                  Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 18),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[700],
                    child: Row(children: [
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.only(
                              left: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(35.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: messageController,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 5,
                                    minLines: 1,
                                    decoration: const InputDecoration(
                                      hintText: "Send a message...",
                                      hintStyle: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      GestureDetector(
                        onTap: () {
                          sendImage();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: AppColors.blueChat,
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
                ],
              ),
            ),
          ]),
        ));
  }

  sendImage() {
    // if (messageController.text.isNotEmpty) {
    Map<String, dynamic> chatMessageMap = {
      "image": widget.image,
      "message": messageController.text,
      "sender": userName + "_" + userInfo.userId,
      "time": DateTime.now().millisecondsSinceEpoch,
    };

    chatController.sendImage(widget.chatId, chatMessageMap);
    setState(() {
      messageController.clear();
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.topToBottomPop,
            child: ChatPageScreen(
              imageURL: widget.imageUrl,
              privateChat: widget.privateChat,
              chatId: widget.chatId,
              chatName: widget.chatName,
            ),
            childCurrent: ChatImagePreview(
              image: widget.image,
              chatId: widget.chatId,
              chatName: widget.chatName,
              imageUrl: widget.imageUrl,
              privateChat: widget.privateChat,
            )),
      );
    });
  }
//}
}
