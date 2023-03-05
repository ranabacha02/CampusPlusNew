import 'package:campus_plus/model/clean_user_model.dart';
import '../model/card_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'data_controller.dart';

class CardController{
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

  Future<bool> joinCard(String cardId) async {
    return MyCard.joinCard(cardId);
  }

  Future<bool> leaveCard(String cardId) async {
    return MyCard.leaveCard(cardId);
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

  Future<List<MyCard>> getAllVisibleCards() async {
    return MyCard.getAllVisibleCards();
  }

  Future<List<MyCard>> getNextCards(MyCard lastCard, int limit) async {
    return MyCard.getNextCards(lastCard, limit);
  }

  Future<List<MyCard>> getTaggedCards(List<String> tags) async {
    List<MyCard> taggedCards=[];
    for(String t in tags){
      taggedCards.addAll(await MyCard.getTaggedCards(t));
    }
    return taggedCards;
  }

  Future<List<MyCard>> filterCards(List<MyCard> cards, List<String> tags) async {
    Set<MyCard> taggedCards ={};
    if(tags.isNotEmpty){
      for(String tag in tags){
        taggedCards.addAll(cards.where((card)=> card.tags.contains(tag)));
      }
      List<MyCard> cardsList = taggedCards.toList();
      cardsList.sort((a,b) => a.eventStart.compareTo(b.eventStart));
      return cardsList;
    }
    return cards;
  }


  Future<List<MyCard>> getMyCards() async {
    final myCreatedCards = await MyCard.getMyCreatedCards();
    final myJoinedCards = await MyCard.getMyJoinedCards();
    List<MyCard> myCards = myCreatedCards + myJoinedCards;
    return myCards;
  }


}



