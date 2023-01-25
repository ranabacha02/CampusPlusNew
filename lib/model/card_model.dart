import 'dart:io';
import 'dart:core';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyCard {
  String createdBy;
  String event;
  DateTime dateCreated;
  DateTime eventStart;
  // final Timestamp eventEnd;
  // final List<String> tags;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<CleanUser> users;

  MyCard({
    required this.createdBy,
    required this.event,
    required this.dateCreated,
    required this.eventStart,
    required this.users,
  });

  MyCard.fromFirestore(Map<String, dynamic> snapshot):
        event = snapshot['event'],
        dateCreated = snapshot['dateCreated'],
        eventStart = snapshot['eventStart'],
        createdBy = snapshot['createdBy'],
        users = snapshot['users'];

  Map<String, dynamic> toFirestore(){
    return {
      'createdBy': createdBy,
      'event' : event,
      'dateCreated' : dateCreated,
      'eventStart' : eventStart,
    };
  }



  Future createCard() async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    cardCollection.add({
      "createdBy" : createdBy,
      "event": event,
      "dateCreated": dateCreated,
      "eventStart": eventStart,
      "users": users
    });
  }
  static Future joinCard(String cardId, CleanUser user) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    cardCollection.doc(cardId).update({"users": FieldValue.arrayUnion([user]),})
        .then((doc)=> print("joined"),
        onError: (e)=>print("Erorr updating document $e"));
  }
  static Future leaveCard(String cardId, CleanUser user) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    DocumentSnapshot snapshot = await cardCollection.doc(cardId).get();
    MyCard card = MyCard.fromFirestore(snapshot.data() as Map<String, dynamic>);
    List<CleanUser> cardUsers = card.users;
    CleanUser target = cardUsers.firstWhere((usr) => usr.userId==user.userId);
    cardCollection.doc(cardId).update({"users": FieldValue.arrayRemove([target]),})
        .then((doc)=> print("left"),
        onError: (e)=>print("Erorr updating document $e"));
  }

  static Future removeCard(String cardId) async {
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
