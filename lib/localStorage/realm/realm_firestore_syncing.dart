import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';
import 'package:realm/realm.dart';
import 'package:campus_plus/localStorage/realm/data_models/realmUser.dart';

import 'data_models/chat.dart';

RealmUser toRealmUser(Map<String, dynamic> snapshot) {
  var myUser = RealmUser(
      snapshot['userId'],
      snapshot['firstName'],
      snapshot['lastName'],
      snapshot['gender'],
      snapshot['department'],
      snapshot['major'],
      snapshot['email'],
      snapshot['graduationYear'],
      DateTime.now(),
      snapshot['mobilePhoneNumber'],
      snapshot['description'],
      snapshot['profilePictureURL'],
      chatsId: List<String>.from(snapshot['chatsId'] ??= []),
      rentals: List<String>.from(snapshot['rentals'] ??= []),
      tutoringClasses: List<String>.from(snapshot['tutoringClasses'] ??= []));
  // myUser.chatsId.addAll(List<String>.from(snapshot['chatsId'] ??= []));
  // myUser.rentals.addAll(List<String>.from(snapshot['rentals'] ??= []));
  // myUser.tutoringClasses.addAll(List<String>.from(snapshot['tutoringClasses'] ??= []));
  return myUser;
}

RealmChat toRealmChat(Map<String, dynamic> snapshot) {
  return RealmChat(
      snapshot["chatId"],
    snapshot["chatName"],
    snapshot["isGroup"],
    snapshot["recentMessage"],
    snapshot["recentMessageSender"],
    snapshot["recentMessageTime"] == ""
        ? DateTime.now()
        : snapshot["recentMessageTime"].runtimeType == Timestamp
            ? snapshot["recentMessageTime"].toDate()
            : DateTime.fromMillisecondsSinceEpoch(
                int.parse(snapshot["recentMessageTime"])),
    snapshot["chatIcon"],
    admin: snapshot["isGroup"] ? snapshot["admin"] : null,
    members: List<String>.from(snapshot['members'] ??= []),
  );
}

RealmMessage toRealmMessage(Map<String, dynamic> snapshot) {
  return RealmMessage(snapshot["message"], snapshot["sender"],
      DateTime.fromMillisecondsSinceEpoch(snapshot["time"]), snapshot["type"],
      imageUrl: snapshot["imageURL"]);
}

StreamSubscription userSyncing(String userId) {
  return FirebaseFirestore.instance
      .collection("Users")
      .doc(userId)
      .snapshots()
      .listen((event) {
    final config = Configuration.local([RealmUser.schema]);
    final realm = Realm(config);
    if (event.data() != null) {
      final myUser = toRealmUser(event.data()!);
      print("syncing user!");
      realm.write(() {
        realm.add(myUser, update: true);
      });
    }
  });
}

chatsSyncing(List<String> chatsIdAndUserEmail) {
  if (chatsIdAndUserEmail.isNotEmpty) {
    List<String> chatsId = [];
    for (String s in chatsIdAndUserEmail) {
      chatsId.add(s.split("_")[0]);
    }

    final config = Configuration.local([RealmChat.schema, RealmMessage.schema]);
    final realm = Realm(config);

    //creating a query for the that works for realm
    final jsonEncoder = JsonEncoder();
    String query = jsonEncoder.convert(chatsId);
    String query1 = query.replaceAll("[", "{");
    String query2 = query1.replaceAll("]", "}");

    var result = realm.query<RealmChat>('chatId IN $query2');
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');
    chatCollection
        .where('chatId', whereIn: chatsId)
        .orderBy('recentMessageTime')
        .snapshots()
        .listen((event) {
      event.docChanges.forEach((element) {
        print(element.doc.id);
        if (element.type == DocumentChangeType.removed) {
          var result = realm.find<RealmChat>(element.doc.id);
          if (result != null) {
            realm.delete<RealmChat>(result);
            print("realm chat deleted");
          }
        } else {
          if ((element.type == DocumentChangeType.added ||
                  element.type == DocumentChangeType.modified) &&
              element.doc.exists) {
            RealmChat realmChat =
                toRealmChat(element.doc.data() as Map<String, dynamic>);
            RealmChat? realmChat1 = realm.find<RealmChat>(realmChat.chatId);
            realmChat.messages
                .addAll(realmChat1 != null ? realmChat1.messages : []);
            realm.write(() {
              print("syncing chat");
              realm.add(realmChat, update: true);
            });
          }
        }
      });
    });
    int n = 0;
    result = realm.query<RealmChat>('chatId IN $query2');
    for (var realmChat in result.toList()) {
      var chatId = realmChat.chatId;
      print("length of messages of ${realmChat.chatId} " +
          realmChat.messages.length.toString());
      realm.write(
          () => realmChat.messages.sort((RealmMessage a, RealmMessage b) {
                return a.time.compareTo(b.time);
              }));

      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(0);

      if (realmChat.messages.length > 0) {
        dateTime = realmChat.messages.last.time;
        print(dateTime);
      }

      chatCollection
          .doc(chatId)
          .collection("messages")
          .where('time', isGreaterThan: dateTime.millisecondsSinceEpoch)
          .snapshots()
          .listen((event) {
        var messagesChanges = event.docChanges;
        RealmChat realmChat = realm.find<RealmChat>(chatId)!;
        for (var message in messagesChanges) {
          if (message.type == DocumentChangeType.added && message.doc.exists) {
            RealmMessage realmMessage = toRealmMessage(message.doc.data()!);
            realm.write(() {
              print("syncing message");
              print(realmMessage.message);
              realmChat.messages.insert(0, realmMessage);
            });
          }
        }
      });
    }
  }
}

newChatSyncing(String chatId) {
  final config = Configuration.local([RealmChat.schema, RealmMessage.schema]);
  final realm = Realm(config);

  CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chats');
  chatCollection
      .where('chatId', isEqualTo: chatId)
      .orderBy('recentMessageTime')
      .snapshots()
      .listen((event) {
    event.docChanges.forEach((element) {
      print(element.doc.id);
      if (element.type == DocumentChangeType.removed) {
        var result = realm.find<RealmChat>(element.doc.id);
        if (result != null) {
          realm.write(() => realm.delete<RealmChat>(result));
          print("realm chat deleted");
        }
      } else {
        if ((element.type == DocumentChangeType.added ||
                element.type == DocumentChangeType.modified) &&
            element.doc.exists) {
          // print('I AM SYNCING A NEWLY MODIFIED OR ADDED CHAT');
          RealmChat realmChat =
              toRealmChat(element.doc.data() as Map<String, dynamic>);
          RealmChat? realmChat1 = realm.find<RealmChat>(realmChat.chatId);
          realmChat.messages
              .addAll(realmChat1 != null ? realmChat1.messages : []);
          realm.write(() {
            print("syncing chat");
            realm.add(realmChat, update: true);
          });
        }
      }
    });
  });

  DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(0);

  chatCollection
      .doc(chatId)
      .collection("messages")
      .where('time', isGreaterThan: dateTime.millisecondsSinceEpoch)
      .snapshots()
      .listen((event) {
    var messagesChanges = event.docChanges;
    RealmChat realmChat = realm.find<RealmChat>(chatId)!;
    for (var message in messagesChanges) {
      if (message.type == DocumentChangeType.added && message.doc.exists) {
        RealmMessage realmMessage = toRealmMessage(message.doc.data()!);
        realm.write(() {
          print("syncing message");
          print(realmMessage.message);
          realmChat.messages.insert(0, realmMessage);
        });
      }
    }
  });
}
