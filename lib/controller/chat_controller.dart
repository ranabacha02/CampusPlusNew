import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/model/chat_model.dart';
import 'package:campus_plus/localStorage/realm/realm_firestore_syncing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../model/message_model.dart';
import '../model/user_model.dart';
import '../localStorage/realm/data_models/chat.dart';

class ChatController {
  //CollectionReference userCollection = FirebaseFirestore.instance.collection('Users');

  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection("chats");
  FirebaseAuth auth = FirebaseAuth.instance;
  DataController dataController = Get.put(DataController());

  Future createGroup(String userEmail, String id, String groupName) async {
    Chat group = new Chat(
        chatName: groupName, isGroup: true, admin: id + "_" + userEmail);
    group.createGroup();
  }

  Future<Chat> createChat(String recipientId) async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');

    var data =
        await userCollection.where("userId", isEqualTo: recipientId).get();
    var recipientInfo = data.docs.first.data() as Map<String, dynamic>;

    MyUser currentUser = dataController.getLocalData();
    String recipientEmail = recipientInfo["email"];
    Chat chat = new Chat(
        chatName: recipientEmail + "_" + currentUser.email, isGroup: false);
    return chat.createChat(
        currentUser.email, recipientId, recipientInfo["email"]);
  }

  getChatsId() async {
    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    return userCollection.doc(auth.currentUser!.uid).snapshots();
  }

  getChatsFromChatsId(List<String> chatsIdAndUserEmail) async {
    List<String> chatsId = [];
    for (String s in chatsIdAndUserEmail) {
      chatsId.add(s.split("_")[0]);
    }
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    var chats = chatCollection
        .where('chatId', whereIn: chatsId)
        .orderBy('recentMessageTime')
        .snapshots();
    return chats;
  }

  getChatMessages(String groupId) async {
    Chat chat = Chat(chatId: groupId);
    return chat.getChatMessages();
  }

  // send message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) {
    Chat chat = Chat(chatId: groupId);
    chat.sendMessage(chatMessageData);
  }

  joinGroup(String groupId, String userName, String groupName) async {
    Chat chat = Chat(chatId: groupId);
    chat.joinGroup(userName);

    CollectionReference userCollection =
        FirebaseFirestore.instance.collection('Users');
    userCollection.doc(auth.currentUser!.uid).update({
      "chatsId": FieldValue.arrayUnion(["${groupId}_$groupName"])
    });
  }

  sendImage(String groupId, Map<String, dynamic> chatMessageData) {
    Chat chat = Chat(chatId: groupId);
    chat.sendImage(chatMessageData);
  }

  getReadStatus(String groupId) {
    Chat chat = Chat(chatId: groupId);
    return chat.getReadStatus(auth.currentUser!.uid);
  }

  markRead(String groupId) {
    Chat chat = Chat(chatId: groupId);
    return chat.markRead(auth.currentUser!.uid);
  }

  getCachedChatMessages(String chatId) {
    Chat chat = Chat(chatId: chatId);
    return chat.getCachedChatMessages();
  }

  getLocalChatMessagesSizes() {
    var realmUser = dataController.getLocalData();
    for (var temp in realmUser.chatsId) {
      var chatId = temp.split("_")[0];
      final config =
          Configuration.local([RealmChat.schema, RealmMessage.schema]);
      final realm = Realm(config);
      var realmChat = realm.find<RealmChat>(chatId);
      if (realmChat != null) {
        print(
            "the number of messages stored locally for ${realmChat.chatId} is ${realmChat.messages.length}");
      } else {
        print("this chat id: $chatId does not have a realmChat");
      }
    }
  }

  List<RealmMessage> getLocalChatMessages(String chatId) {
    final config = Configuration.local([RealmChat.schema, RealmMessage.schema]);
    final realm = Realm(config);

    var realmChat = realm.find<RealmChat>(chatId);
    if (realmChat != null) {
      realmChat.messages.forEach((element) {
        print(element.message);
      });
      return realmChat.messages.toList();
    } else {
      return List<RealmMessage>.empty(growable: true);
    }
  }

  Future<Stream<RealmObjectChanges<RealmChat>>?> getLiveChatObject(
      String chatId) async {
    final config = Configuration.local([RealmChat.schema, RealmMessage.schema]);
    final realm = await Realm.open(config);
    realm.write(() => realm
        .find<RealmChat>(chatId)
        ?.messages
        .sort((RealmMessage b, RealmMessage a) => a.time.compareTo(b.time)));
    return realm.find<RealmChat>(chatId)?.changes;
  }

  updateGroupIcon(File? file, String chatId) {
    Chat chat = Chat(chatId: chatId);
    return chat.updateGroupIcon(file);
  }

  leaveGroup(String chatId, String userId, String chatName) {
    Chat chat = Chat(chatId: chatId, chatName: chatName);
    return chat.leaveGroup(userId);
  }
}
