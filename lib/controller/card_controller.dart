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
      Card card= Card(
        createdBy: auth.currentUser!.uid,
        hostName: dataController.getLocalData()['firstName'],
        event: event,
        dateCreated: dateCreated,
        eventStart: eventStart,
        users: [{"userId":auth.currentUser!.uid, "hostName":dataController.getLocalData()['firstName']}],
      );
      card.createCard();
    }

    Future joinCard(String cardId, Map<String, String> userInfo) async {
        Card.joinCard(cardId, userInfo);
    }

    Future leaveCard(String cardId, Map<String, String> userInfo) async {
      Card.leaveCard(cardId, userInfo);
    }

    Future removeCard(String cardId, Map<String, String> userInfo) async {
      Card.removeCard(cardId, userInfo);
    }

    Future getMyCards() async{
      Card.getMyCards(auth.currentUser!.uid);
  }



  }



