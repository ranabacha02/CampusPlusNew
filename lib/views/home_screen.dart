import 'package:flutter/material.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:get/get.dart';
import '../controller/card_controller.dart';
import '../controller/data_controller.dart';
import '../model/card_model.dart';
import '../model/user_model.dart';
import '../widgets/main_card.dart';
import 'card_form_screen.dart';
import 'package:campus_plus/views/notifications.dart';
import 'package:campus_plus/views/schedule.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

enum TagsFilter { study, food, fun, sports}

class _HomeScreenState extends State<HomeScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late DataController dataController;
  late CardController cardController;
  late final MyUser userInfo;
  late Future<List<MyCard>> futureCards;
  late List<MyCard> cards;
  final List<String> _tags = <String>[];
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
    cards = await cardController.getInitialCards(limit);
    return cards;
  }

  Future<void> getNextCards(MyCard card) async {
    final newCards = await cardController.getNextCards(card, limit);
    cards = cards + newCards;
    final filteredCards = cardController.filterCards(cards, _tags);
    setState(() {
      futureCards = filteredCards;
    });
  }


  Future<void> refreshCards() async {
    final newCards = getInitialCards();
    final filteredCards = cardController.filterCards(await newCards, _tags);
    setState(() {
      futureCards = filteredCards;
    });
  }

  //TODO implement filtering button, that filters client side

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

  Future<void> updatePage() async {
    final newCards = getInitialCards();
    final filteredCards = cardController.filterCards(await newCards, _tags);
    cards = await filteredCards;
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      futureCards = filteredCards;
    });
  }

  Wrap buildTagFilterChip() {
    return Wrap(
      spacing: 5.0,
      children: TagsFilter.values.map((TagsFilter tag){
        return FilterChip(
            label: Text(tag.name),
            selected: _tags.contains(tag.name),
            onSelected: (bool value){
              setState(() {
                if (value) {
                  if (!_tags.contains(tag.name)) {
                    _tags.add(tag.name);
                  }
                } else {
                  _tags.removeWhere((String name) {
                    return name == tag.name;
                  });
                }
              });
            }
            );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.white,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Text(
              "CAMPUS+",
              style: TextStyle(
                fontSize: 30,
                color: AppColors.aubRed,
              ),
            ),
            elevation: 0,
            actions: <Widget>[
              IconButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return const MainCardForm();
                      }),
                    );
                    refreshCards();
                  },
                  icon: Image.asset('assets/postIcon.png')),
              IconButton(
                  onPressed: () => {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return const Schedule();
                      })
                  )},
                  icon: Image.asset('assets/calendarIcon.png')),
              IconButton(
                  onPressed: () => { Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return Notifications();
                      })
                  )},
                  icon: Image.asset('assets/notificationIcon.png')),
            ]),
        body: Container(
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
                  child: _listView(scrollController, isLoadingMoreCards, snapshot, userInfo, updateCard, buildTagFilterChip)
              );
            },
          )
        )
    );
  }
}

Widget _listView(ScrollController scrollController, bool isLoadingMoreCards, AsyncSnapshot snapshot, MyUser userInfo, Function updateCard, Function buildTagFilterChip) {
  //TODO handle snapshot cases
  if(!snapshot.hasData){
    return Center(child: LoadingAnimationWidget.threeArchedCircle(color: AppColors.aubRed, size: 40));
  }
  if(snapshot.hasError){
    return const Text('Something went wrong');
  }
  final cards = snapshot.data;
  return
     Column(
        children: [
          const SizedBox(height:20),
          buildTagFilterChip(),
          Expanded(child:
            ListView.builder(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: isLoadingMoreCards ? cards.length+1 : cards.length,
              itemBuilder: (context, index){
                if(index<cards.length){
                  if(cards[index].createdBy == userInfo.userId){
                    return MainCard(
                      card: cards[index],
                      personal: true,
                      updateCard: updateCard,
                    );}
                  else{
                    return MainCard(
                      card: cards[index],
                      personal: false,
                      updateCard: updateCard,
                    );}
                }
                else{
                  return Center(child: LoadingAnimationWidget.prograssiveDots(color: AppColors.aubRed, size: 30));
                }
              },
            )
          ),
        ]
      );
}


