import 'package:campus_plus/controller/data_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ChatController {
  //CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');

  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection("chats");
  FirebaseAuth auth = FirebaseAuth.instance;
  DataController dataController = Get.put(DataController());

  newChat(bool isGroup, String? groupName, List<String> members) {
    //create the chat in chat collection
    var userInfo = dataController.getLocalData();
    String userName = userInfo["firstName"] + " " + userInfo["lastName"];
    if (isGroup) {
      createGroup(userName, auth.currentUser!.uid, groupName!);
    } else {
      createChat(userName, auth.currentUser!.uid, members[0]);
    }
  }

  Future createGroup(String userName, String id, String groupName) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    DocumentReference groupDocumentReference = await chatCollection.add({
      "isGroup": true,
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "chatId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${auth.currentUser!.uid}_$userName"]),
      "chatId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference =
        userCollection.doc(auth.currentUser!.uid);
    return await userDocumentReference.update({
      "chatsId":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
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
    DocumentReference groupDocumentReference = await chatCollection.add({
      "isGroup": false,
      "chatName": recipientName + "_" + userName,
      "chatIcon": "",
      //"admin": "${id}_$userName",
      //"members": [],
      "chatId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${auth.currentUser!.uid}_$userName"]),
      "chatId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference =
        userCollection.doc(auth.currentUser!.uid);
    await userDocumentReference.update({
      "chatsId":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$recipientName"])
    });

    DocumentReference recipientDocumentReference =
        userCollection.doc(recipientId);
    await recipientDocumentReference.update({
      "chatsId":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$userName"])
    });
  }

  getChatsId() async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    return userCollection.doc(auth.currentUser!.uid).snapshots();
  }

  getChats(String groupId) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    return chatCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    chatCollection.doc(groupId).collection("messages").add(chatMessageData);
    chatCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}
