import 'package:campus_plus/views/chat_page_screen.dart';
import 'package:campus_plus/widgets/app_widgets.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
    //print(userInfo["chatsId"]);
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
      appBar: AppBar(
          backgroundColor: AppColors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "New Chat",
            style: TextStyle(
              fontSize: 30,
              color: AppColors.aubRed,
            ),
          )),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Card(
              child: TextField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
              elevation: 0,
            ),
            GestureDetector(
              onTap: () {
                popUpDialog(context);
              },
              child: Container(
                  alignment: Alignment.centerRight,
                  height: 20,
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    "New Group",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                    textAlign: TextAlign.end,
                  )),
            ),
            Divider(),
            Flexible(
                fit: FlexFit.loose,
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
                        print(data.docs[index]['email']);
                        if (data.docs[index]['userId'] !=
                                auth.currentUser!.uid &&
                            !usersWithChat
                                .contains(data.docs[index]['email'])) {
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
            Flexible(
                fit: FlexFit.loose,
                child: StreamBuilder<QuerySnapshot>(
                  stream: groups,
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
                        if (!usersWithChat
                            .contains(data.docs[index]['groupName'])) {
                          return groupProfile(
                            data.docs[index]['groupName'],
                            data.docs[index]['groupIcon'],
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
      String userName, List<String> members) {
    String memberNames = "";
    for (String s in members) {
      memberNames += s.split("_")[0];
    }
    return Container(
        height: 105,
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/default_profile.jpg"),
                backgroundColor: AppColors.circle,
                foregroundColor: AppColors.white,
              ),
              title: Text(
                groupName,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
          //create a new chat between the users and redirect them to the chat page
          String userName = userInfo.firstName + " " + userInfo.lastName;
          Chat chat = await chatController.createChat(
              userName, auth.currentUser!.uid, uid, userInfo.email);
          String groupName = "";
          String temp = chat.chatName.split("_")[0];
          if (temp == userName) {
            groupName = chat.chatName.split("_")[1];
          } else {
            groupName = temp;
          }

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPageScreen(
                      chatId: chat.chatId,
                      chatName: groupName,
                      privateChat: !chat.isGroup,
                      imageURL: chat.chatIcon)));
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
                      SizedBox(width: 5),
                      Text(
                        major + " | " + graduationYear.toString(),
                        style: TextStyle(color: AppColors.grey, fontSize: 12),
                      ),
                      new Spacer(),
                    ],
                  ),
                ),
                Divider(),
              ],
            )));
  }

  popUpDialog(BuildContext context) {
    bool _isLoading = false;
    String groupName = "";
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // _isLoading == true
                  //     ? Center(
                  //   child: CircularProgressIndicator(
                  //       color: Theme.of(context).primaryColor),
                  // )
                  //     :
                  TextField(
                    onChanged: (val) {
                      setState(() {
                        groupName = val;
                      });
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      chatController.createGroup(
                          userInfo.firstName + " " + userInfo.lastName,
                          auth.currentUser!.uid,
                          groupName);

                      Navigator.of(context).pop();
                      print("group created successfully");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
  }
}
