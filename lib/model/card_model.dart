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
        createdBy = snapshot['createdBy'],
        event = snapshot['event'],
        dateCreated = snapshot['dateCreated'].toDate(),
        eventStart = snapshot['eventStart'].toDate(),
        users = snapshot['users'].map<CleanUser>((user)=>CleanUser.fromFirestore(user)).toList();

  Map<String, dynamic> toFirestore(){
    return {
      'createdBy': createdBy,
      'event' : event,
      'dateCreated' : dateCreated,
      'eventStart' : eventStart,
      'users' : users.map<Map<String, dynamic>>((user)=>user.toFirestore()).toList()
    };
  }



  Future createCard() async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    cardCollection.add(this.toFirestore());
  }
  static Future<bool> joinCard(String cardId, CleanUser user) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    final complete = cardCollection.doc(cardId).update({"users": FieldValue.arrayUnion([user.toFirestore()]),})
        .then((doc)=> true, onError: (e)=>false);
    return complete;
  }
  static Future<bool> leaveCard(String cardId, CleanUser user) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    DocumentSnapshot snapshot = await cardCollection.doc(cardId).get();
    MyCard card = MyCard.fromFirestore(snapshot.data() as Map<String, dynamic>);
    List<CleanUser> cardUsers = card.users;
    CleanUser target = cardUsers.firstWhere((usr) => usr.userId==user.userId);
    final complete = cardCollection.doc(cardId).update({"users": FieldValue.arrayRemove([target.toFirestore()]),})
        .then((doc)=> true, onError: (e)=>false);
    return complete;
  }

  static Future<bool> removeCard(String cardId) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    final complete = cardCollection.doc(cardId).delete().then((doc)=> true, onError: (e)=> false);
    return complete;
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
