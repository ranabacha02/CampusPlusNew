import 'dart:ui';

import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_cache/firestore_cache.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../controller/data_controller.dart';
import '../localStorage/realm/realm_firestore_syncing.dart';
import 'message_model.dart';

class Chat {
  String chatId;
  String chatName;
  bool isGroup;
  List<String> members;
  String recentMessage;
  String recentSender;
  DateTime recentMessageTime;
  String recentMessageType;
  String chatIcon;
  String admin;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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
    String? recentMessageType,
  })
      : members = members ?? [],
        recentMessage = recentMessage ?? "",
        recentSender = recentSender ?? "",
        recentMessageTime = recentMessageTime ?? DateTime.now(),
        chatIcon = chatIcon ?? "",
        chatId = chatId ?? "",
        admin = admin ?? "",
        chatName = chatName ?? "",
        recentMessageType = recentMessageType ?? "",
        isGroup = isGroup ?? false;

  Chat.fromFirestore(Map<String, Object?> json)
      : this(
          chatId: json['chatId'] as String,
          chatName: json['chatName'] as String,
          isGroup: json['isGroup'] as bool,
          members: json['members'] as List<String>?,
          recentMessage: json['recentMessage'] as String?,
          recentSender: json['recentSender'] as String?,
          recentMessageTime: json['recentMessageTime'] as DateTime?,
          recentMessageType: json['recentMessageType'] as String?,
        );

  Map<String, dynamic> toFirestore() {
    return {
      "chatId": chatId,
      "chatName": chatName,
      "isGroup": isGroup,
      "members": members,
      "recentMessage": recentMessage,
      "recentSender": recentSender,
      "recentMessageTime": recentMessageTime,
      "recentMessageType": recentMessageType,
    };
  }

  Future<Chat> createChat(
      String email, String recipientId, String recipientEmail) async {
    final CollectionReference userCollection = _firestore.collection('Users');
    final CollectionReference chatCollection = _firestore.collection("chats");

    //to not create two chat with the same person
    DataController dataController = Get.put(DataController());
    MyUser myUser = dataController.getLocalData();
    for (String id in myUser.chatsId) {
      if (id.split("_")[1] == recipientEmail) {
        chatId = id.split("_")[0];
        return this;
      }
    }
    //creating the chat document
    DocumentReference groupDocumentReference = await chatCollection.add({
      "isGroup": isGroup,
      "chatName": chatName,
      "chatIcon": chatIcon,
      "chatId": "",
      "recentMessage": recentMessage,
      "recentMessageSender": recentSender,
      "recentMessageTime": recentMessageTime,
      "recentMessageType": "",
      "admin": "",
    });
    // update the members
    chatId = groupDocumentReference.id;
    newChatSyncing(chatId);
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion([
        "${auth.currentUser!.uid}_$email",
        "${recipientId}_${recipientEmail}"
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

    //adding the chat id to the list of chats id of the current user
    DocumentReference userDocumentReference =
        userCollection.doc(auth.currentUser!.uid);
    await userDocumentReference.update({
      "chatsId": FieldValue.arrayUnion(
          ["${groupDocumentReference.id}_$recipientEmail"])
    });

    //adding the chat id to the list of chats id for the recipient
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
    CollectionReference userCollection = _firestore.collection('Users');
    DocumentReference groupDocumentReference = await chatCollection.add({
      "isGroup": true,
      "chatName": chatName,
      "chatIcon": "",
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
    chatId = groupDocumentReference.id;
    newChatSyncing(chatId);
    await userDocumentReference.update({
      "chatsId": FieldValue.arrayUnion(["${chatId}_$chatName"])
    });
    return this;
  }

  Future<List<Message>> getCachedChatMessages() async {
    const cacheField = 'time';
    final cacheDocRef = _firestore.collection('chats').doc(chatId);
    final query = _firestore.collection('messages');
    final snapshot = await FirestoreCache.getDocuments(
      query: query,
      cacheDocRef: cacheDocRef,
      firestoreCacheField: cacheField,
    );
    List<Message> messages = [];
    for (var document in snapshot.docs) {
      messages.add(Message.fromJson(document as Map<String, Object?>));
    }
    print(messages);
    return messages;
  }

  getChatMessages() {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    return chatCollection
        .doc(chatId)
        .collection("messages")
        .orderBy("time", descending: true)
        .snapshots();
  }

  sendMessage(Map<String, dynamic> chatMessageData) {
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

  joinGroup(String userName) {
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

  sendImage(Map<String, dynamic> chatMessageData) {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    chatCollection.doc(chatId).collection("messages").add({
      "message": chatMessageData["message"],
      "sender": chatMessageData["sender"],
      "time": chatMessageData["time"],
      "type": "image",
    }).then((value) {
      final storage = FirebaseStorage.instance;
      var storageRef =
          storage.ref().child("chats/attachments/${chatId}/${value.id}");
      var uploadTask = storageRef.putFile(chatMessageData['image'])
        ..then((p0) {
          var downloadUrl = p0.ref.getDownloadURL();
          value.update({
            "imageUrl": downloadUrl,
          });
          print("image uploaded");
        });
    });
    chatCollection.doc(chatId).update({
      "recentMessage": chatMessageData["message"],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
      "recentMessageType": 'image',
    });
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

  markUnread() {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    var chat = chatCollection.doc(chatId).get().then((chat) {
      for (String member in chat["members"]) {
        String memberId = member.split("_")[0];
        if (memberId != auth!.currentUser!.uid) {
          try {
            var temp = chatCollection
                .doc(chatId)
                .collection("readStatus")
                .doc(memberId)
                .get()
              ..then((value) {
                int num = value["unreadNumber"];
                chatCollection
                    .doc(chatId)
                    .collection("readStatus")
                    .doc(memberId)
                    .set({
                  "userId": memberId,
                  "unread": true,
                  "unreadNumber": num + 1,
                });
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
        }
      }
    });
  }
}
