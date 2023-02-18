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

class _HomeScreenState extends State<HomeScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late DataController dataController;
  late CardController cardController;
  late final MyUser userInfo;
  late final CleanUser cleanUserInfo;
  late Future<List<MyCard>> futureCards;

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
    setState(() {
      futureCards = newCards;
    });
  }

  Future<void> updatePage() async {
    final newCards = gettingCards();
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      futureCards = newCards;
    });
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
                child: _listView(snapshot, cleanUserInfo, refreshCards)
            );
          },
        )
    );
  }
}

Widget _listView(AsyncSnapshot snapshot, CleanUser cleanUserInfo, Function refreshCards) {
  if(!snapshot.hasData){
    return Center(child: CircularProgressIndicator(color: AppColors.aubRed));
  }
  if(snapshot.hasError){
    return const Text('Something went wrong');
  }
  final data = snapshot.data;
  return ListView.builder(
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
  );
}


