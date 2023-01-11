import 'package:campus_plus/widgets/app_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/auth_controller.dart';
import '../controller/chat_controller.dart';
import '../controller/data_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/nav_bar.dart';

class NewChatScreen extends StatefulWidget {
  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
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
  late final userInfo;

  @override
  void initState() {
    super.initState();
    chatController = Get.put(ChatController());
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
    print(userInfo["chatsId"]);
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
        body: Material(
          type: MaterialType.transparency,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  onTap: () {
                    popUpDialog(context);
                  },
                  child: Container(
                    height: 60,
                    color: AppColors.greychat,
                    child: Row(
                      children: [
                        SizedBox(
                          width: Get.width * 0.1,
                        ),
                        Icon(
                          Icons.add_box_outlined,
                          color: AppColors.blue,
                        ),
                        SizedBox(
                          width: Get.width * 0.07,
                        ),
                        Text(
                          "Create a group chat",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.blue,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
                Flexible(
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
                        print(data.docs[index]['userId'] +
                            "_" +
                            data.docs[index]['firstName'] +
                            " " +
                            data.docs[index]['lastName']);
                        if (data.docs[index]['userId'] !=
                                auth.currentUser!.uid &&
                            !userInfo["chatsId"].contains(data.docs[index]
                                    ['userId'] +
                                "_" +
                                data.docs[index]['firstName'] +
                                " " +
                                data.docs[index]['lastName'])) {
                          return userProfile(
                              data.docs[index]['firstName'] +
                                  " " +
                                  data.docs[index]['lastName'],
                              data.docs[index]['major'],
                              data.docs[index]['graduationYear'],
                              data.docs[index]['userId']);
                        } else {
                          return SizedBox(
                            height: 0,
                          );
                        }
                      },
                    );
                  },
                )),
                SizedBox(
                  width: 0,
                ),
                Text(
                  "Groups",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
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
                        return groupProfile(
                          data.docs[index]['groupName'],
                          data.docs[index]['groupIcon'],
                          data.docs[index]['chatId'],
                          userInfo['firstName'] + " " + userInfo['lastName'],
                        );
                      },
                    );
                  },
                )),
              ]),
        ));
  }

  groupProfile(
      String groupName, String groupIcon, String groupId, String userName) {
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                subtitle: Row(
                  children: [
                    SizedBox(width: 5),
                    new Spacer(),
                    elevatedButton(
                        text: "Join",
                        onpress: () {
                          //create a new chat between the users and redirect them to the chat page
                          chatController.joinGroup(
                              groupId, userName, groupName);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavBarView(
                                        index: 3,
                                      )));
                        })
                  ],
                )),
            Divider(),
          ],
        ));
  }

  userProfile(String userName, String major, int graduationYear, String uid) {
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
                  userName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                subtitle: Row(
                  children: [
                    SizedBox(width: 5),
                    Text(
                      major + " | " + graduationYear.toString(),
                      style: TextStyle(color: AppColors.grey, fontSize: 15),
                    ),
                    new Spacer(),
                    elevatedButton(
                        text: "Chat",
                        onpress: () {
                          //create a new chat between the users and redirect them to the chat page
                          chatController.createChat(
                              userInfo["firstName"] +
                                  " " +
                                  userInfo["lastName"],
                              auth.currentUser!.uid,
                              uid);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NavBarView(
                                        index: 3,
                                      )));
                        })
                  ],
                )),
            Divider(),
          ],
        ));
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
                          userInfo["firstName"] + " " + userInfo["lastName"],
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
