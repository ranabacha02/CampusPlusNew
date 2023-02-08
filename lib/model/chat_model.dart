import 'dart:ui';

import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controller/data_controller.dart';
import 'message_model.dart';

class Chat {
  String chatId;
  String chatName;
  bool isGroup;
  List<String> members;
  String recentMessage;
  String recentSender;
  DateTime recentMessageTime;
  String chatIcon;
  String admin;
  FirebaseAuth auth = FirebaseAuth.instance;

  Chat({
    String? chatName,
    bool? isGroup,
    List<String>? members,
    String? recentMessage,
    String? recentSender,
    DateTime? recentMessageTime,
    String? chatIcon,
    String? chatId,
    String? admin,
  })  : members = members ?? [],
        recentMessage = recentMessage ?? "",
        recentSender = recentSender ?? "",
        recentMessageTime = recentMessageTime ?? DateTime.now(),
        chatIcon = chatIcon ?? "",
        chatId = chatId ?? "",
        admin = admin ?? "",
        chatName = chatName ?? "",
        isGroup = isGroup ?? false;

  Chat.fromJson(Map<String, Object?> json)
      : this(
    chatId: json['chatId'] as String,
    chatName: json['chatName'] as String,
    isGroup: json['isGroup'] as bool,
    members: json['members'] as List<String>?,
    recentMessage: json['recentMessage'] as String?,
    recentSender: json['recentSender'] as String?,
    recentMessageTime: json['recentMessageTime'] as DateTime?,
  );

  Future<Chat> createChat(String email, String recipientName,
      String recipientId, String recipientEmail) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    final CollectionReference chatCollection =
        FirebaseFirestore.instance.collection("chats");

    DataController dataController = Get.put(DataController());
    MyUser myUser = dataController.getLocalData();
    for (String id in myUser.chatsId) {
      if (id.split("_")[1] == recipientEmail) {
        chatId = id.split("_")[0];
        return this;
      }
    }

    DocumentReference groupDocumentReference = await chatCollection.add({
      "isGroup": isGroup,
      "chatName": chatName,
      "chatIcon": chatIcon,
      "chatId": "",
      "recentMessage": recentMessage,
      "recentMessageSender": recentSender,
      "recentMessageTime": recentMessageTime,
    });
    // update the members
    chatId = groupDocumentReference.id;
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion([
        "${auth.currentUser!.uid}_$email",
        "${recipientId}_${recipientName}"
      ]),
      "chatId": chatId,
    });

    //creating the read status of the recipient
    await groupDocumentReference.collection("readStatus").doc(recipientId).set({
      "userId": recipientId,
      "unread": false,
      "unreadNumber": 0,
    });

    //creating the read status of the user (the one who created the chat)
    await groupDocumentReference
        .collection("readStatus")
        .doc(auth.currentUser!.uid)
        .set({
      "userId": auth.currentUser!.uid,
      "unread": false,
      "unreadNumber": 0,
    });

    DocumentReference userDocumentReference =
        userCollection.doc(auth.currentUser!.uid);
    await userDocumentReference.update({
      "chatsId": FieldValue.arrayUnion(
          ["${groupDocumentReference.id}_$recipientEmail"])
    });

    DocumentReference recipientDocumentReference =
        userCollection.doc(recipientId);
    await recipientDocumentReference.update({
      "chatsId": FieldValue.arrayUnion(["${groupDocumentReference.id}_$email"])
    });

    dataController.getUserInfo();

    return this;
  }

  Future createGroup() async {
    final CollectionReference chatCollection =
    FirebaseFirestore.instance.collection("chats");
    CollectionReference userCollection =
    FirebaseFirestore.instance.collection('Users');
    DocumentReference groupDocumentReference = await chatCollection.add({
      "isGroup": true,
      "groupName": chatName,
      "groupIcon": "",
      "admin": admin,
      "members": [],
      "chatId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "recentMessageTime": "",
      "recentMessageType": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion([admin]),
      "chatId": groupDocumentReference.id,
    });

    //creating the read status of the user (the one who created the chat)
    await groupDocumentReference
        .collection("readStatus")
        .doc(auth.currentUser!.uid)
        .set({
      "userId": auth.currentUser!.uid,
      "unread": false,
      "unreadNumber": 0,
    });

    DocumentReference userDocumentReference =
        userCollection.doc(auth.currentUser!.uid);
    return await userDocumentReference.update({
      "chatsId":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$chatName"])
    });
  }

  getChats() async {
    CollectionReference chatCollection =
    FirebaseFirestore.instance.collection('chats');
    return chatCollection
        .doc(chatId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  sendMessage(Map<String, dynamic> chatMessageData) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    chatCollection.doc(chatId).collection("messages").add(chatMessageData);
    chatCollection.doc(chatId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
      "recentMessageType": 'text',
    });
    markUnread();
  }

  joinGroup(String userName) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    chatCollection.doc(chatId).update({
      "members": FieldValue.arrayUnion(["${auth.currentUser!.uid}_$userName"]),
    });

    chatCollection
        .doc(chatId)
        .collection("readStatus")
        .doc(auth.currentUser!.uid)
        .set({
      "userId": auth.currentUser!.uid,
      "unread": false,
      "unreadNumber": 0
    });
  }

  sendImage(Map<String, dynamic> chatMessageData) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    DocumentReference documentReference =
        await chatCollection.doc(chatId).collection("messages").add({
      "message": chatMessageData["message"],
      "sender": chatMessageData["sender"],
      "time": chatMessageData["time"],
      "type": "image",
    });
    chatCollection.doc(chatId).update({
      "recentMessage": chatMessageData["message"],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
      "recentMessageType": 'image',
    });
    final storage = FirebaseStorage.instance;
    var storageRef = storage
        .ref()
        .child("chats/attachments/${chatId}/${documentReference.id}");
    var uploadTask = await storageRef.putFile(chatMessageData['image']);
    var downloadURL = await uploadTask.ref.getDownloadURL();
    documentReference.update({
      "imageUrl": downloadURL,
    });
    print("image uploaded");
    markUnread();
  }

  deleteChat() {}

  getReadStatus(String userId) {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    return chatCollection
        .doc(chatId)
        .collection("readStatus")
        .doc(userId)
        .get();
  }

  markRead(String memberId) {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    chatCollection.doc(chatId).collection("readStatus").doc(memberId).update({
      "unread": false,
      "unreadNumber": 0,
    });
  }

  markUnread() async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    var chat = await chatCollection.doc(chatId).get();
    for (String member in chat["members"]) {
      print(member);
      String memberId = member.split("_")[0];
      if (memberId != auth!.currentUser!.uid) {
        try {
          var temp = await chatCollection
              .doc(chatId)
              .collection("readStatus")
              .doc(memberId)
              .get();
          int num = temp["unreadNumber"];
          print("num is:" + num.toString());
          chatCollection
              .doc(chatId)
              .collection("readStatus")
              .doc(memberId)
              .set({
            "userId": memberId,
            "unread": true,
            "unreadNumber": num + 1,
          });
        } catch (e) {
          chatCollection
              .doc(chatId)
              .collection("readStatus")
              .doc(memberId)
              .set({
            "userId": memberId,
            "unread": true,
            "unreadNumber": 1,
          });
        }

        print("updated status");
      }
    }
  }
}
