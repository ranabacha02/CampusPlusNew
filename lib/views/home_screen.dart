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
  List<MyCard>? cards;

  @override
  void initState() {
    super.initState();

    dataController = Get.put(DataController());
    cardController = Get.put(CardController());
    userInfo = dataController.getLocalData();
    cleanUserInfo = CleanUser.fromMyUser(userInfo);
    gettingCards();
  }

  Future<void> gettingCards() async {
    final newCards = await cardController.getAllCards();
    setState(()  {
      cards = newCards;
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
                  onPressed: () => {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                    return const MainCardForm();
                    })
                    )
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
          future: cardController.getAllCards(),
          builder: (context, snapshot){
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                color: Colors.white,
                backgroundColor: Colors.blue,
                strokeWidth: 4.0,
                onRefresh: gettingCards,
                child: _listView(snapshot, cleanUserInfo)
            );
          },
        )
    );
  }
}

Widget _listView(AsyncSnapshot snapshot, CleanUser cleanUserInfo) {
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
          cardId: data[index].id,
          event: data[index].event,
          personal: true,
          userInfo: cleanUserInfo,
          usersJoined: data[index].users,
          date: data[index].eventStart,
        );}
      else{
        return MainCard(
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


