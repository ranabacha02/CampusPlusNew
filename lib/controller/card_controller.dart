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

  Future<MyCard?> getCardById(String cardId) async {
    return MyCard.getCardById(cardId);
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

  Future<List<MyCard>> getInitialCards(int limit) async {
    return MyCard.getInitialCards(limit);
  }

  Future<List<MyCard>> getNextCards(MyCard lastCard, int limit) async {
    return MyCard.getNextCards(lastCard, limit);
  }

  Future<List<MyCard>> getInitialTaggedCards(int limit, String tag) async {
    return MyCard.getInitialTaggedCards(limit, tag);
  }

  Future<List<MyCard>> getNextTaggedCards(MyCard lastCard, int limit, String tag) async {
    return MyCard.getNextTaggedCards(lastCard, limit, tag);
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

  Future<List<MyCard>> getMyInitialCreatedCards(int limit) async{
    return await MyCard.getMyInitialCreatedCards(limit);
  }

  Future<List<MyCard>> getMyNextCreatedCards(MyCard lastCard, int limit) async{
    return await MyCard.getMyNextCreatedCards(lastCard, limit);
  }


  Future<List<MyCard>> getMyInitialJoinedCards(int limit) async{
    return await MyCard.getMyInitialJoinedCards(limit);
  }

  Future<List<MyCard>> getMyNextJoinedCards(MyCard lastCard, int limit) async{
    return await MyCard.getMyNextJoinedCards(lastCard, limit);
  }

}



