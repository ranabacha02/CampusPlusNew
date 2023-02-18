import 'dart:core';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyCard {
  String createdBy;
  String event;
  String audience;
  int attendeeLimit;
  DateTime dateCreated;
  DateTime eventStart;
  DateTime eventEnd;
  List<String> tags;
  List<CleanUser> users;
  List<String> userIds;
  FirebaseAuth auth = FirebaseAuth.instance;

  MyCard({
    required this.createdBy,
    required this.event,
    required this.audience,
    required this.attendeeLimit,
    required this.dateCreated,
    required this.eventStart,
    required this.eventEnd,
    required this.tags,
    required this.users,
    required this.userIds,
  });

  MyCard.fromFirestore(Map<String, dynamic> snapshot):
        createdBy = snapshot['createdBy'],
        event = snapshot['event'],
        audience = snapshot['audience'],
        attendeeLimit = snapshot['attendeeLimit'],
        dateCreated = snapshot['dateCreated'].toDate(),
        eventStart = snapshot['eventStart'].toDate(),
        eventEnd = snapshot['eventEnd'].toDate(),
        tags = List<String>.from(snapshot['tags']),
        users = snapshot['users'].map<CleanUser>((user)=>CleanUser.fromFirestore(user)).toList(),
        userIds =  List<String>.from(snapshot['userIds']);

  Map<String, dynamic> toFirestore(){
    return {
      'createdBy': createdBy,
      'event' : event,
      'audience': audience,
      'attendeeLimit': attendeeLimit,
      'dateCreated' : dateCreated,
      'eventStart' : eventStart,
      'eventEnd' : eventEnd,
      'tags' : tags,
      'users' : users.map<Map<String, dynamic>>((user)=>user.toFirestore()).toList(),
      'userIds' : userIds
    };
  }



  Future<bool> createCard() async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    final complete = cardCollection.add(this.toFirestore()).then((doc)=> true, onError: (r)=> false);
    return complete;
  }
  static Future<bool> joinCard(String cardId, CleanUser user) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    final complete = cardCollection.doc(cardId).update({"users": FieldValue.arrayUnion([user.toFirestore()]), "userIds": FieldValue.arrayUnion([user.userId])})
        .then((doc)=> true, onError: (e)=>false);
    return complete;
  }
  static Future<bool> leaveCard(String cardId, CleanUser user) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    DocumentSnapshot snapshot = await cardCollection.doc(cardId).get();
    MyCard card = MyCard.fromFirestore(snapshot.data() as Map<String, dynamic>);
    List<CleanUser> cardUsers = card.users;
    CleanUser target = cardUsers.firstWhere((usr) => usr.userId==user.userId);
    final complete = cardCollection.doc(cardId).update({"users": FieldValue.arrayRemove([target.toFirestore()]),"userIds": FieldValue.arrayRemove([user.userId])})
        .then((doc)=> true, onError: (e)=>false);
    return complete;
  }

  static Future<bool> removeCard(String cardId) async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    final complete = cardCollection.doc(cardId).delete().then((doc)=> true, onError: (e)=> false);
    return complete;
  }

  static Stream<QuerySnapshot<Object?>> getStreamOfCards(){
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    return cardCollection.orderBy('eventStart').snapshots();
  }

  static Future<List<MyCard>> getAllCards() async {
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    final snapshots = await cardCollection.get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future getMyCreatedCards(String userId) async{
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    final snapshots = await cardCollection.where("createdBy", isEqualTo: userId).get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future getMyJoinedCards(String userId) async{
    final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
    final snapshots = await cardCollection.where("userIds", arrayContains: userId).get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }


}
