import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  Future createChat(
      String userName, String recipientName, String recipientId) async {
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    final CollectionReference chatCollection =
        FirebaseFirestore.instance.collection("chats");

    DocumentReference groupDocumentReference = await chatCollection.add({
      "isGroup": isGroup,
      "chatName": chatName,
      "chatIcon": chatIcon,
      "chatId": "",
      "recentMessage": recentMessage,
      "recentMessageSender": recentSender,
    });
    // update the members
    chatId = groupDocumentReference.id;
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${auth.currentUser!.uid}_$userName"]),
      "chatId": chatId,
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
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion([admin]),
      "chatId": groupDocumentReference.id,
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
    });
  }

  joinGroup(String userName) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    chatCollection.doc(chatId).update({
      "members": FieldValue.arrayUnion(["${auth.currentUser!.uid}_$userName"]),
    });
  }
}
