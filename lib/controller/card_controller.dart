import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/card_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'data_controller.dart';

class CardController{

  final CollectionReference chatCollection = FirebaseFirestore.instance.collection("Cards");
  FirebaseAuth auth = FirebaseAuth.instance;
  DataController dataController = Get.put(DataController());


  Future<bool> createCard(
      {required String event,
      required String audience,
      required int attendeeLimit,
      required DateTime dateCreated,
      required DateTime eventStart,
      required DateTime eventEnd,
      required List<String> tags}) async {
    CleanUser user = CleanUser.fromMyUser(dataController.getLocalData());
    MyCard card= MyCard(
      createdBy: auth.currentUser!.uid,
      event: event,
      audience: audience,
      attendeeLimit: attendeeLimit,
      dateCreated: dateCreated,
      eventStart: eventStart,
      eventEnd: eventEnd,
      tags: tags,
      users: [user],
      userIds: []
    );
    return card.createCard();
  }

  Future<bool> joinCard(String cardId, CleanUser user) async {
    return MyCard.joinCard(cardId, user);
  }

  Future<bool> leaveCard(String cardId, CleanUser user) async {
    return MyCard.leaveCard(cardId, user);
  }

  Future<bool> removeCard(String cardId) async {
    return MyCard.removeCard(cardId);
  }

  Future getStreamOfCards() async {
    return MyCard.getStreamOfCards();
  }

  Future<List<MyCard>> getAllCards() async {
    return MyCard.getAllCards();
  }

  Future<List<MyCard>> getAllVisibleCards() async{
    return MyCard.getAllVisibleCards();
  }


  Future getMyCards() async{
    final myCreatedCards = await MyCard.getMyCreatedCards(auth.currentUser!.uid);
    final myJoinedCards = await MyCard.getMyJoinedCards(auth.currentUser!.uid);
    List<MyCard> myCards = myCreatedCards + myJoinedCards;
    return myCards;
  }






}



