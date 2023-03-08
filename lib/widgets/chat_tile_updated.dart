import 'package:campus_plus/localStorage/realm/realm_firestore_syncing.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../controller/chat_controller.dart';
import '../controller/data_controller.dart';
import '../localStorage/realm/data_models/chat.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart';
import '../views/chat_page_screen.dart';

class ChatTileUpdated extends StatefulWidget {
  //final String userName;
  final String chatId;
  final String expected;

  //final String groupName;

  const ChatTileUpdated({Key? key, required this.chatId, required this.expected
      // required this.groupName,
      })
      : super(key: key);

  //late bool privateChat;

  @override
  State<ChatTileUpdated> createState() => _ChatTileUpdatedState();
}

class _ChatTileUpdatedState extends State<ChatTileUpdated> {
  String? lastMessage;
  String? lastSender;
  String? imageURL;
  String? time;
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream? message;
  Stream? user;
  Stream? readStatus;
  String chatName = "";
  Stream<RealmObjectChanges<RealmChat>>? realmChatStream;
  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');
  RealmChat? realmChat;

  late ChatController chatController;
  late DataController dataController;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    dataController = Get.put(DataController());
    gettingLiveRealmChatObject();
    gettingReadStatuStream();
    chatInitializing();
  }

  void gettingLiveRealmChatObject() {
    setState(() {
      realmChatStream = getLiveRealmChatObject(widget.chatId);
    });
  }

  void gettingReadStatuStream() {
    setState(() {
      readStatus = chatCollection
          .doc(widget.chatId)
          .collection("readStatus")
          .doc(auth.currentUser!.uid)
          .snapshots();
    });
  }

  void chatInitializing() async {
    realmChat = getChatRealmObject(widget.chatId);
    if (realmChat != null) {
      if (realmChat!.isGroup) {
        setState(() {
          chatName = realmChat!.chatName;
          imageURL = realmChat!.chatIcon;
        });
      } else {
        String recipientId = "";
        for (String member in realmChat!.members) {
          if (member.split("_")[0] != auth.currentUser!.uid) {
            recipientId = member.split("_")[0];
            break;
          }
        }
        if (recipientId != "") {
          MyUser recipient = await getUserInfo(recipientId);
          setState(() {
            chatName = "${recipient.firstName} ${recipient.lastName}";
            imageURL = recipient.profilePictureURL;
          });
        }
      }
    }
  }

  Future<MyUser> getUserInfo(String userId) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    var data = await users.where("userId", isEqualTo: userId).get();
    var data2 = data.docs.first.data() as Map<String, dynamic>;
    return MyUser.fromFirestore(data2);
  }

  @override
  Widget build(BuildContext context) {
    if (realmChat != null &&
        realmChatStream != null &&
        (widget.expected == "" ||
            chatName!.toLowerCase().contains(widget.expected.toLowerCase()))) {
      return StreamBuilder(
          stream: getLiveRealmChatObject(widget.chatId),
          builder: (context,
              AsyncSnapshot<RealmObjectChanges<RealmChat>> chatSnapshot) {
            return StreamBuilder(
                stream: readStatus,
                builder: (context, AsyncSnapshot readStatusSnapshot) {
                  if (chatSnapshot.hasData & readStatusSnapshot.hasData) {
                    try {
                      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                          int.parse(chatSnapshot
                              .requireData.object.recentMessageType));
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
                                        privateChat: chatSnapshot
                                            .requireData.object.isGroup,
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
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      onTap: () async {})
                                ]));
                              });
                        },
                        child: Slidable(
                          // Specify a key if the Slidable is dismissible.
                          key: const ValueKey(0),

                          // The end action pane is the one at the right or the bottom side.
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) => {},
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          // The child of the Slidable is what the user sees when the
                          // component is not dragged.
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.circle,
                                    width: 1,
                                  ),
                                ),
                                color: readStatusSnapshot.hasData
                                    ? readStatusSnapshot.data["unread"]
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                chatSnapshot.requireData.object.recentMessage,
                                maxLines: 2,
                                style: const TextStyle(fontSize: 13),
                              ),
                              trailing: readStatusSnapshot
                                          .data["unreadNumber"] ==
                                      0
                                  ? time == null
                                      ? const Text("")
                                      : Text(time!)
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        time == null
                                            ? const Text("")
                                            : Text(time!),
                                        Container(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: CircleAvatar(
                                              backgroundColor: AppColors.aubRed,
                                              radius: 10,
                                              child: Text(
                                                readStatusSnapshot
                                                    .data["unreadNumber"]
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
                        ));
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
