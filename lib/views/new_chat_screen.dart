import 'package:animation_search_bar/animation_search_bar.dart';
import 'package:campus_plus/views/chat_page_screen.dart';
import 'package:campus_plus/widgets/app_widgets.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../controller/auth_controller.dart';
import '../controller/chat_controller.dart';
import '../controller/data_controller.dart';
import '../model/chat_model.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart';
import '../widgets/nav_bar.dart';

class NewChatScreen extends StatefulWidget {
  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  TextEditingController controller = TextEditingController();
  List<String> usersWithChat = [];
  String name = "";
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('Users').snapshots();
  final Stream<QuerySnapshot> groups = FirebaseFirestore.instance
      .collection('chats')
      .where('isGroup', isEqualTo: true)
      .snapshots();
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  FirebaseAuth auth = FirebaseAuth.instance;

  late ChatController chatController;
  late AuthController authController;
  late DataController dataController;
  late final MyUser userInfo;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
    usersWithChat = getUsersList(userInfo);
  }

  getUsersList(MyUser userInfo) {
    List<String> res = [];
    for (String s in userInfo.chatsId) {
      res.add(s.split("_")[1]);
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createGroupDialog();
        },
        backgroundColor: AppColors.grey,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 65),
          child: SafeArea(
              child: Container(
            alignment: Alignment.center,
            child: AnimationSearchBar(
                backIconColor: Colors.black,
                centerTitle: 'New chat',
                onChanged: (text) {
                  setState(() {
                    name = text;
                  });
                },
                searchTextEditingController: controller,
                horizontalPadding: 5),
          ))),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: const Text(
                "People",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: users,
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }
                final data = snapshot.requireData;

                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    if (data.docs[index]['userId'] != auth.currentUser!.uid &&
                        !usersWithChat.contains(data.docs[index]['email']) &&
                        (name == "" ||
                            "${data.docs[index]['firstName']} ${data.docs[index]['lastName']}"
                                .toLowerCase()
                                .contains(name.toLowerCase()))) {
                      String? imageUrl = null;
                      try {
                        imageUrl = data.docs[index]['profilePictureUrl'];
                      } catch (e) {}
                      return userProfile(
                          data.docs[index]['firstName'] +
                              " " +
                              data.docs[index]['lastName'],
                          data.docs[index]['major'],
                          data.docs[index]['graduationYear'],
                          data.docs[index]['userId'],
                          imageUrl);
                    } else {
                      return Container();
                    }
                  },
                );
              },
            )),
            Container(
              padding: EdgeInsets.all(10),
              child: const Text(
                "Groups",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: groups,
              builder: (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot,
              ) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading');
                }
                final data = snapshot.requireData;
                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    if (!usersWithChat.contains(data.docs[index]['chatName']) &&
                        (name == "" ||
                            data.docs[index]['chatName']
                                .toString()
                                .toLowerCase()
                                .contains(name.toLowerCase()))) {
                      return groupProfile(
                        data.docs[index]['chatName'],
                        data.docs[index]['chatIcon'],
                        data.docs[index]['chatId'],
                        "${userInfo.firstName} ${userInfo.lastName}",
                        data.docs[index]['members'],
                      );
                    } else {
                      return SizedBox(height: 0, width: 0);
                    }
                  },
                );
              },
            )),
          ]),
    );
  }

  groupProfile(String groupName, String groupIcon, String groupId,
      String userName, List<dynamic> members) {
    String memberNames = "";
    if (members.length > 3) {
      memberNames =
          "${members[0].split("_")[1]}, ${members[1].split("_")[1]} + ${members.length - 2} others";
    } else if (members.length == 3) {
      memberNames =
          "${members[0].split("_")[1]}, ${members[1].split("_")[1]} + 1 other";
      memberNames =
          "${members[0].split("_")[1]} and ${members[1].split("_")[1]} ";
    } else if (members.length == 1) {
      memberNames = "${members[0].split("_")[1]}";
    }

    return Container(
        height: 105,
        child: Column(
          children: [
            ListTile(
              leading: UserProfilePicture(
                imageURL: groupIcon,
                caption: userName,
                preview: false,
                radius: 20,
              ),
              title: Text(
                groupName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              subtitle: Row(
                children: [
                  Text(
                    memberNames,
                    overflow: TextOverflow.fade,
                  )
                ],
              ),
              trailing: elevatedButton(
                  text: "Join",
                  onpress: () {
                    //create a new chat between the users and redirect them to the chat page
                    chatController.joinGroup(groupId, userName, groupName);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NavBarView(
                              index: 3,
                            )));
                  }),
            ),
            Divider(),
          ],
        ));
  }

  userProfile(String userName, String major, int graduationYear, String uid,
      String? imageUrl) {
    return GestureDetector(
        onTap: () async {
          //create a new chat between the users and redirect them to the chat pag
          Chat chat = await chatController.createChat(uid);
          String chatName = userName;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPageScreen(
                      chatId: chat.chatId,
                      chatName: chatName,
                      privateChat: true,
                      imageURL: imageUrl)));
        },
        child: Container(
            height: 88,
            child: Column(
              children: [
                ListTile(
                  leading: UserProfilePicture(
                    imageURL: imageUrl,
                    caption: userName,
                    preview: false,
                    radius: 20,
                  ),
                  title: Text(
                    userName,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Row(
                    children: [
                      const SizedBox(width: 5),
                      Text(
                        "$major | $graduationYear",
                        style: TextStyle(color: AppColors.grey, fontSize: 12),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Divider(),
              ],
            )));
  }

  createGroupDialog() {
    var groupName = "";
    QuickAlert.show(
      context: context,
      type: QuickAlertType.custom,
      barrierDismissible: true,
      confirmBtnText: 'Save',
      confirmBtnColor: AppColors.whitegrey,
      customAsset: 'assets/chat.gif',
      widget: TextFormField(
        decoration: const InputDecoration(
          alignLabelWithHint: true,
          hintText: 'Enter GroupName',
          prefixIcon: Icon(
            Icons.group,
          ),
        ),
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        onChanged: (value) => groupName = value,
      ),
      onConfirmBtnTap: () async {
        if (groupName.isEmpty) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Please input something',
          );
          return;
        }
        Navigator.pop(context);
        await chatController.createGroup(
            "${userInfo.firstName} ${userInfo.lastName}",
            auth.currentUser!.uid,
            groupName);
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: "Group '$groupName' has been created!",
        );
      },
    );
  }
}
