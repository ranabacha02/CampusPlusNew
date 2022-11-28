import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/model/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../model/message_model.dart';

class ChatController {
  //CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');

  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection("chats");
  FirebaseAuth auth = FirebaseAuth.instance;
  DataController dataController = Get.put(DataController());

  Future createGroup(String userName, String id, String groupName) async {
    Chat group = new Chat(
        chatName: groupName, isGroup: true, admin: id + "_" + userName);
    group.createGroup();
  }

  Future createChat(String userName, String id, String recipientId) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');

    var data =
        await userCollection.where("userId", isEqualTo: recipientId).get();
    var recipientInfo = data.docs.first.data() as Map<String, dynamic>;

    print(recipientInfo);
    String recipientName =
        recipientInfo["firstName"] + " " + recipientInfo["lastName"];
    Chat chat =
        new Chat(chatName: recipientName + "_" + userName, isGroup: false);
    chat.createChat(userName, recipientName, recipientId);
  }

  getChatsId() async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    return userCollection.doc(auth.currentUser!.uid).snapshots();
  }

  getChats(String groupId) async {
    Chat chat = new Chat(chatId: groupId);
    return chat.getChats();
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    Chat chat = new Chat(chatId: groupId);
    chat.sendMessage(chatMessageData);
  }

  joinGroup(String groupId, String userName, String groupName) async {
    Chat chat = new Chat(chatId: groupId);
    chat.joinGroup(userName);

    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    userCollection.doc(auth.currentUser!.uid).update({
      "chatsId": FieldValue.arrayUnion(["${groupId}_$groupName"])
    });
  }
}
