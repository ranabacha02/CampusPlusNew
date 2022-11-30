import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Card {
  String createdBy;
  String hostName;
  String event;
  DateTime dateCreated;
  DateTime eventStart;
  // final Timestamp eventEnd;
  // final List<String> tags;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String,String>> users;

  Card({
    required this.createdBy,
    required this.hostName,
    required this.event,
    required this.dateCreated,
    required this.eventStart,
    required this.users,
  });

  Card.fromJson(Map<String, Object?> json)
      : this(
      event: json['event'] as String,
      dateCreated: json['dateCreated'] as DateTime,
      eventStart: json['eventStart'] as DateTime,
      createdBy: json['createdBy'] as String,
      hostName: json['hostName'] as String,
      users: json['users'] as List<Map<String,String>>
  );


  Future createCard() async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    cardCollection.add({
      "createdBy" : createdBy,
      "hostName": hostName,
      "event": event,
      "dateCreated": dateCreated,
      "eventStart": eventStart,
      "users": users
    });
  }
  static Future joinCard(String cardId, Map<String, String> userInfo) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    cardCollection.doc(cardId).update({"users": FieldValue.arrayUnion([userInfo]),})
        .then((doc)=> print("joined"),
        onError: (e)=>print("Erorr updating document $e"));
  }
  static Future leaveCard(String cardId, Map<String, String> userInfo) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    cardCollection.doc(cardId).update({"users": FieldValue.arrayRemove([userInfo]),})
        .then((doc)=> print("left"),
        onError: (e)=>print("Erorr updating document $e"));
  }
  static Future removeCard(String cardId, Map<String, String> userInfo) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    cardCollection.doc(cardId).delete()
        .then((doc)=> print("Document deleted"),
        onError: (e)=> print("Error updating document $e"));
  }
  static Stream<QuerySnapshot<Object?>> getCards(){
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    return cardCollection.orderBy('eventStart').snapshots();
  }

  static Future getMyCards(String userId) async{
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    return cardCollection.where("createdBy", isEqualTo: userId).get().then(
          (res) => print("Successfully completed"),
      onError: (e) => print("Error completing: $e"),
    );
  }
  // Future getMyJoinedCards(){
  //   final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
  //   return cardCollection.where("users", isEqualTo: auth.currentUser!.uid).get().then(
  //         (res) => print("Successfully completed"),
  //     onError: (e) => print("Error completing: $e"),
  //   );
  // }




}
