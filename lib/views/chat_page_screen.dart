import 'package:campus_plus/model/user_model.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/views/chat_info_page.dart';
import 'package:campus_plus/widgets/chat_date_tile.dart';
import 'package:campus_plus/widgets/chat_file_picker.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:campus_plus/widgets/received_message_tile.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:realm/realm.dart' as Realm;
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../controller/chat_controller.dart';
import '../controller/data_controller.dart';
import '../model/message_model.dart';
import '../localStorage/realm/data_models/chat.dart';
import '../widgets/app_widgets.dart';
import '../widgets/forum_widget.dart';
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
  final GroupedItemScrollController itemScrollController =
      GroupedItemScrollController();

  late ChatController chatController;
  late DataController dataController;
  late final MyUser userInfo;
  late final userName;
  List<Message> cachedMessages = [];
  Stream? chats;
  bool isChat = true;
  late List<RealmMessage> realMessages;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
    userName = "${userInfo.firstName} ${userInfo.lastName}";
    realMessages = chatController.getLocalChatMessages(widget.chatId);
  }

  getChat() {
    chatController.getChatMessages(widget.chatId).then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
                extendBody: true,
                bottomNavigationBar: SizedBox(
                  height: 1,
                ),
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        chatController.markRead(widget.chatId);
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRightPop,
                                child: NavBarView(index: 3),
                                childCurrent: ChatPageScreen(
                                  imageURL: widget.imageURL,
                                  privateChat: widget.privateChat,
                                  chatId: widget.chatId,
                                  chatName: widget.chatName,
                                )));
                      }),
                  title: Row(
                    children: [
                      widget.imageURL != null && widget.imageURL != ""
                          ? UserProfilePicture(
                              imageURL: widget.imageURL!,
                              caption: widget.chatName,
                              radius: 25,
                            )
                          : const CircleAvatar(
                              backgroundImage:
                                  AssetImage("assets/default_profile.jpg"),
                            ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRightPop,
                                  child: GroupInfoScreen(chatId: widget.chatId),
                                  childCurrent: ChatPageScreen(
                                    imageURL: widget.imageURL,
                                    privateChat: widget.privateChat,
                                    chatId: widget.chatId,
                                    chatName: widget.chatName,
                                  )));
                        },
                        child: Text(
                          widget.chatName,
                          style:
                              TextStyle(color: AppColors.aubRed, fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.white,
                ),
                body: widget.privateChat
                    ? Column(
                        //mainAxisSize: MainAxisSize.min,
                        children: [
                          TabBar(
                            labelPadding: EdgeInsets.all(Get.height * 0.01),
                            unselectedLabelColor: Colors.grey,
                            labelColor: Colors.black,
                            indicatorColor: Colors.black,
                            onTap: (v) {
                              setState(() {
                                isChat = !isChat;
                              });
                            },
                            tabs: [
                              myText(
                                text: 'Chat',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              myText(
                                text: 'Forum',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            child: TabBarView(
                              children: [
                                chatWidget(context),
                                ForumWidget(
                                  chatId: widget.chatId,
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    : chatWidget(context))));
  }

  Widget chatWidget(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            // chat messages here
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight - 80,
              ),
              child: chatMessagesUpdate(widget.privateChat),
            ),
            //type bar
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                height: 80,
                padding: const EdgeInsets.only(
                    left: 20, top: 12, right: 20, bottom: 20),
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
                            ChatFileUploads(
                              imageUrl: widget.imageURL,
                              chatName: widget.chatName,
                              chatId: widget.chatId,
                              privateChat: widget.privateChat,
                            ),
                          ],
                        )),
                  ),
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
            ),
          ],
        ),
      );
    });
  }

  chatMessagesUpdate(bool privateChat) {
    final config =
        Realm.Configuration.local([RealmChat.schema, RealmMessage.schema]);
    final realm = Realm.Realm(config);
    realm.write(() => realm
        .find<RealmChat>(widget.chatId)
        ?.messages
        .sort((RealmMessage b, RealmMessage a) => a.time.compareTo(b.time)));
    return StreamBuilder(
        stream: realm.find<RealmChat>(widget.chatId)?.changes,
        builder: (context,
            AsyncSnapshot<Realm.RealmObjectChanges<RealmChat>> snapshot) {
          String previousSender = "";
          if (snapshot.hasError) {
            return Center(
              child: Text("There was an error: ${snapshot.error}"),
            );
          }
          return snapshot.hasData
              ? Container(
                  height: privateChat
                      ? MediaQuery.of(context).size.height * 0.73
                      : MediaQuery.of(context).size.height * 0.783,
              // child: stickyGroupedList(snapshot.requireData.object.messages, privateChat),
                  child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.requireData.object.messages.length,
                      itemBuilder: (context, index) {
                        DateTime dateTime =
                            snapshot.requireData.object.messages[index].time;
                        DateTime dateTime2 = DateTime.now();
                        String time = "";
                        if (dateTime.minute < 10) {
                          time = "${dateTime.hour}:0${dateTime.minute}";
                        } else {
                          time = dateTime.hour.toString() +
                              ":" +
                              dateTime.minute.toString();
                        }

                        String currentDate =
                            DateFormat.yMMMEd().format(dateTime);

                        String currentSender =
                            snapshot.requireData.object.messages[index].sender;
                        String nextSender = "";
                        try {
                          nextSender = snapshot
                              .requireData.object.messages[index + 1].sender;
                          dateTime2 = snapshot
                              .requireData.object.messages[index + 1].time;
                        } catch (e) {
                          nextSender = "";
                        }
                        String nextDate = DateFormat.yMMMEd().format(dateTime2);

                        bool sameSender = currentSender == nextSender;
                        bool sameDate = currentDate == nextDate;

                        if (currentSender.split("_")[1] == userInfo.userId) {
                          // if (snapshot
                          //     .requireData.object.messages[index].type == "image" ) {
                          //   print("IMAGE URL "+ snapshot
                          //     .requireData.object.messages[index].imageUrl.toString());
                          // }
                          return Column(children: [
                            sameDate ? Container() : chatDateTile(currentDate),
                            MessageTile(
                              message: snapshot
                                  .requireData.object.messages[index].message,
                              sender: snapshot
                                  .requireData.object.messages[index].sender,
                              privateChat: privateChat,
                              time: time,
                              type: snapshot
                                  .requireData.object.messages[index].type,
                              imageUrl: snapshot
                                  .requireData.object.messages[index].imageUrl,
                            )
                          ]);
                        } else {
                          // print(snapshot
                          //     .requireData.object.messages[index].imageUrl);
                          return Column(children: [
                            sameDate ? Container() : chatDateTile(currentDate),
                            ReceivedMessageTile(
                              message: snapshot
                                  .requireData.object.messages[index].message,
                              sender: snapshot
                                  .requireData.object.messages[index].sender,
                              privateChat: privateChat,
                              sameSender: sameSender,
                              time: time,
                              type: snapshot
                                  .requireData.object.messages[index].type,
                              imageUrl: snapshot
                                  .requireData.object.messages[index].imageUrl,
                            )
                          ]);
                        }
                      }))
              : const Center(
                  child: Text("data not loaded yet"),
                );
        });
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": userName + "_" + userInfo.userId,
        "time": DateTime.now().millisecondsSinceEpoch,
        "type": "text",
        "imageURL": "",
      };

      chatController.sendMessage(widget.chatId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }

// stickyGroupedList(Realm.RealmList<RealmMessage> _elements, bool privateChat) {
//
//   return StickyGroupedListView<RealmMessage, String>(
//     floatingHeader: true,
//     elements: _elements.toList(),
//     groupBy: (RealmMessage element) =>
//         DateFormat.yMMMEd().format(element.time),
//     groupSeparatorBuilder: (RealmMessage element) =>
//         chatDateTile(DateFormat.yMMMEd().format(element.time)),
//     itemBuilder: (context, RealmMessage element) {
//       DateTime dateTime = element.time;
//       DateTime dateTime2 = DateTime.now();
//       String time = "";
//       if (dateTime.minute < 10) {
//         time = "${dateTime.hour}:0${dateTime.minute}";
//       } else {
//         time = "${dateTime.hour}:${dateTime.minute}";
//       }
//
//       String currentSender = element.sender;
//       String nextSender = "";
//       try {
//         nextSender = element.sender;
//         dateTime2 = element.time;
//       } catch (e) {
//         nextSender = "";
//       }
//
//       bool sameSender = currentSender == nextSender;
//       return currentSender.split("_")[1] == userInfo.userId
//           ? MessageTile(
//               message: element.message,
//               sender: element.sender,
//               privateChat: privateChat,
//               time: time,
//               type: element.type,
//               imageUrl: element.imageUrl,
//             )
//           : ReceivedMessageTile(
//               message: element.message,
//               sender: element.sender,
//               privateChat: privateChat,
//               sameSender: sameSender,
//               time: time,
//               type: element.type,
//               imageUrl: element.imageUrl,
//             );
//     },
//     itemComparator: (e1, e2) => e1.time.compareTo(e2.time), // optional
//     itemScrollController: itemScrollController, // optional
//     order: StickyGroupedListOrder.DESC,
//     reverse: true,// optional
//   );
// }
}
