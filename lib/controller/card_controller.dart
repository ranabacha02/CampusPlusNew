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


  Future createCard(String event, DateTime dateCreated, DateTime eventStart) async {
    CleanUser user = CleanUser.fromMyUser(dataController.getLocalData());
    MyCard card= MyCard(
      createdBy: auth.currentUser!.uid,
      event: event,
      dateCreated: dateCreated,
      eventStart: eventStart,
      users: [user],
    );
    card.createCard();
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

  Future getCards() async {
    return MyCard.getCards();
  }

  Future getMyCards() async{
    return MyCard.getMyCards(auth.currentUser!.uid);
  }






}



