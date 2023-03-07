import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../controller/card_controller.dart';
import '../controller/data_controller.dart';
import '../model/card_model.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart';
import '../widgets/main_card.dart';
import 'package:get/get.dart';

import '../widgets/shimmer_cards.dart';

class JoinedCardsTab extends StatefulWidget {
  const JoinedCardsTab({Key? key}) : super(key: key);

  @override
  State<JoinedCardsTab> createState() => _JoinedCardsTabState();
}

class _JoinedCardsTabState extends State<JoinedCardsTab> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late DataController dataController;
  late CardController cardController;
  late final MyUser userInfo;
  late Future<List<MyCard>> futureCards;
  late List<MyCard> cards;
  final ScrollController scrollController = ScrollController();
  final limit = 10;
  bool isLoadingMoreCards = false;

  @override
  void initState() {
    super.initState();
    dataController = Get.put(DataController());
    cardController = Get.put(CardController());
    userInfo = dataController.getLocalData();
    futureCards = getInitialCards();
    scrollController.addListener(_scrollListener);
  }

  Future<void> _scrollListener() async {
    if(isLoadingMoreCards) return;
    if(scrollController.position.pixels > scrollController.position.maxScrollExtent-200 && scrollController.position.pixels> 50){
      setState(() {
        isLoadingMoreCards = true;
      });
      await getNextCards(cards[cards.length-1]);
      setState(() {
        isLoadingMoreCards = false;
      });
    }
  }

  Future<List<MyCard>> getInitialCards() async {
    cards = await cardController.getMyInitialJoinedCards(limit);
    return cards;
  }

  Future<void> getNextCards(MyCard card) async {
    final newCards = await cardController.getMyNextJoinedCards(card, limit);
    cards = cards + newCards;
    final combinedCards = Future.delayed(const Duration(microseconds: 1), () => cards);
    setState(() {
      futureCards = combinedCards;
    });
  }

  Future<void> updateCard(String cardId) async {
    final updatedCard = await cardController.getCardById(cardId);
    if(updatedCard == null){
      for(int i = 0; i< cards.length; i++){
        if(cards[i].id == cardId){
          cards.removeAt(i);
        }
      }
    }
    else{
      for(int i = 0; i< cards.length; i++){
        if(cards[i].id == cardId){
          cards[i] = updatedCard;
        }
      }
    }
    final updatedCards = Future.delayed(const Duration(microseconds: 1), () => cards);
    setState(() {
      futureCards = updatedCards;
    });
  }

  Future<void> refreshCards() async {
    final newCards = getInitialCards();
    setState(() {
      futureCards = newCards;
    });
  }

  Future<void> updatePage() async {
    final newCards = getInitialCards();
    cards = await newCards;
    await Future.delayed(const Duration(milliseconds: 300));
    final updatedCards = Future.delayed(const Duration(microseconds: 1), () => cards);
    setState(() {
      futureCards = updatedCards;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: FutureBuilder(
          future: futureCards,
          builder: (context, snapshot){
            return RefreshIndicator(
                key: _refreshIndicatorKey,
                color: AppColors.aubRed,
                backgroundColor: Colors.white,
                strokeWidth: 2.0,
                displacement: 20.0,
                onRefresh: updatePage,
                child: _listView(scrollController, isLoadingMoreCards, snapshot, userInfo, updateCard)
            );
          },
        )
    );
  }
}

Widget _listView(ScrollController scrollController, bool isLoadingMoreCards, AsyncSnapshot snapshot, MyUser userInfo, Function updateCard) {
  if(!snapshot.hasData){
    return const ShimmerCards();
  }
  if(snapshot.hasError){
    return const Text('Something went wrong');
  }
  final cards = snapshot.data;
  return ListView.builder(
    controller: scrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: isLoadingMoreCards ? cards.length+1 : cards.length,
    itemBuilder: (context, index){
      if(index<cards.length){
        return MainCard(
          card: cards[index],
          personal: false,
          updateCard: updateCard,
        );
      }
      else{
        return Center(child: LoadingAnimationWidget.prograssiveDots(color: AppColors.aubRed, size: 30));
      }
    },
  );
}
