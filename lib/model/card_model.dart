import 'dart:core';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

final CollectionReference cardCollection = FirebaseFirestore.instance.collection("Cards");
DataController dataController = Get.put(DataController());

class MyCard {
  String id = "";
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
        id = snapshot['id'],
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
    final DocumentReference newCardRef = FirebaseFirestore.instance.collection("Cards").doc();
    final cardData = {
      'id' : newCardRef.id,
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
    final complete = newCardRef.set(cardData).then((doc)=> true, onError: (r)=> false);
    return complete;
  }

  static Future<MyCard?> getCardById(String cardId) async{
    final DocumentSnapshot snapshot = await cardCollection.doc(cardId).get();
    if(snapshot.exists){
      final MyCard card = MyCard.fromFirestore(snapshot.data() as Map<String, dynamic>);
      return card;
    }
    else {return null;}
  }

  static Future<bool> joinCard(String cardId) async {
    final MyUser user = dataController.getLocalData();
    final CleanUser cleanUser = CleanUser.fromMyUser(user);
    final complete = cardCollection.doc(cardId).update({"users": FieldValue.arrayUnion([cleanUser.toFirestore()]), "userIds": FieldValue.arrayUnion([cleanUser.userId])})
        .then((doc)=> true, onError: (e)=>false);
    return complete;
  }

  static Future<bool> leaveCard(String cardId) async {
    final DocumentSnapshot snapshot = await cardCollection.doc(cardId).get();
    final MyCard card = MyCard.fromFirestore(snapshot.data() as Map<String, dynamic>);
    final List<CleanUser> cardUsers = card.users;
    final MyUser user = dataController.getLocalData();
    final CleanUser target = cardUsers.firstWhere((usr) => usr.userId==user.userId);
    final complete = cardCollection.doc(cardId).update({"users": FieldValue.arrayRemove([target.toFirestore()]),"userIds": FieldValue.arrayRemove([user.userId])})
        .then((doc)=> true, onError: (e)=>false);
    return complete;
  }

  static Future<bool> removeCard(String cardId) async {
    final complete = cardCollection.doc(cardId).delete().then((doc)=> true, onError: (e)=> false);
    return complete;
  }

  static Stream<QuerySnapshot<Object?>> getStreamOfCards() {
    return cardCollection.orderBy('eventStart').snapshots();
  }

  static Future<List<MyCard>> getAllCards() async {
    final snapshots = await cardCollection.orderBy('eventStart').get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future<List<MyCard>> getInitialCards(int limit) async {
    String gender = dataController.getLocalData().gender;
    String department = dataController.getLocalData().department;
    final snapshots = await cardCollection.where("audience", whereIn: ["Everyone", gender, department]).orderBy("eventStart").limit(limit).get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future<List<MyCard>> getNextCards(MyCard lastCard, int limit) async {
    String gender = dataController.getLocalData().gender;
    String department = dataController.getLocalData().department;
    final snapshots = await cardCollection.where("audience", whereIn: ["Everyone", gender, department]).orderBy("eventStart").startAfter([lastCard.eventStart]).limit(limit).get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future<List<MyCard>> getTaggedCards(String tag) async {
    String gender = dataController.getLocalData().gender;
    String department = dataController.getLocalData().department;
    final snapshots = await cardCollection.where("audience", whereIn: ["Everyone", gender, department]).where("tags", arrayContains: tag).orderBy("eventStart").get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future getMyCreatedCards() async {
    final MyUser user = dataController.getLocalData();
    final snapshots = await cardCollection.where("createdBy", isEqualTo: user.userId).get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future getMyJoinedCards() async {
    final MyUser user = dataController.getLocalData();
    final snapshots = await cardCollection.where("userIds", arrayContains: user.userId).get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future getMyInitialCreatedCards(int limit) async {
    final MyUser user = dataController.getLocalData();
    final snapshots = await cardCollection.where("createdBy", isEqualTo: user.userId).orderBy("eventStart").limit(limit).get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future<List<MyCard>> getMyNextCreatedCards(MyCard lastCard, int limit) async {
    final MyUser user = dataController.getLocalData();
    final snapshots = await cardCollection.where("createdBy", isEqualTo: user.userId).orderBy("eventStart").startAfter([lastCard.eventStart]).limit(limit).get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future getMyInitialJoinedCards(int limit) async {
    final MyUser user = dataController.getLocalData();
    final snapshots = await cardCollection.where("userIds", arrayContains: user.userId).orderBy("eventStart").limit(limit).get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }

  static Future<List<MyCard>> getMyNextJoinedCards(MyCard lastCard, int limit) async {
    final MyUser user = dataController.getLocalData();
    final snapshots = await cardCollection.where("userIds", arrayContains: user.userId).orderBy("eventStart").startAfter([lastCard.eventStart]).limit(limit).get();
    List<MyCard> cards = snapshots.docs.map<MyCard>((doc) => MyCard.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return cards;
  }


}
