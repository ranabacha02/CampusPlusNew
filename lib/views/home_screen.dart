import 'package:flutter/material.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:get/get.dart';
import '../controller/card_controller.dart';
import '../controller/data_controller.dart';
import '../model/card_model.dart';
import '../model/clean_user_model.dart';
import '../model/user_model.dart';
import '../widgets/main_card.dart';
import 'card_form_screen.dart';
import 'package:campus_plus/views/notifications.dart';
import 'package:campus_plus/views/schedule.dart';


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
  late final CleanUser cleanUserInfo;
  late Future<List<MyCard>> futureCards;
  final List<String> _tags = <String>[];

  @override
  void initState() {
    super.initState();

    dataController = Get.put(DataController());
    cardController = Get.put(CardController());
    userInfo = dataController.getLocalData();
    cleanUserInfo = CleanUser.fromMyUser(userInfo);
    futureCards = gettingCards();
  }

  Future<List<MyCard>> gettingCards() async {
    return await cardController.getAllVisibleCards();
  }

  Future<void> refreshCards() async {
    final newCards = gettingCards();
    final filteredCards = cardController.filterCards(await newCards, _tags);
    setState(() {
      futureCards = filteredCards;
    });
  }

  Future<void> updatePage() async {
    final newCards = gettingCards();
    final filteredCards = cardController.filterCards(await newCards, _tags);
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
        body: FutureBuilder(
          future: futureCards,
          builder: (context, snapshot){
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                color: Colors.white,
                backgroundColor: Colors.blue,
                strokeWidth: 4.0,
                onRefresh: updatePage,
                child: _listView(snapshot, cleanUserInfo, refreshCards, buildTagFilterChip)
            );
          },
        )
    );
  }
}

Widget _listView(AsyncSnapshot snapshot, CleanUser cleanUserInfo, Function refreshCards, Function buildTagFilterChip) {
  if(!snapshot.hasData){
    return Center(child: CircularProgressIndicator(color: AppColors.aubRed));
  }
  if(snapshot.hasError){
    return const Text('Something went wrong');
  }
  final data = snapshot.data;
  return
     Column(
        children: [
          const SizedBox(height:20),
          buildTagFilterChip(),
          Expanded(child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index){
              if(data[index].createdBy == cleanUserInfo.userId){
                return MainCard(
                  refreshCards: refreshCards,
                  cardId: data[index].id,
                  event: data[index].event,
                  personal: true,
                  userInfo: cleanUserInfo,
                  usersJoined: data[index].users,
                  date: data[index].eventStart,
                );}
              else{
                return MainCard(
                  refreshCards: refreshCards,
                  cardId: data[index].id,
                  event: data[index].event,
                  personal: false,
                  userInfo: cleanUserInfo,
                  usersJoined: data[index].users,
                  date: data[index].eventStart,
                );}
            },
          )),
        ]
      );
}


