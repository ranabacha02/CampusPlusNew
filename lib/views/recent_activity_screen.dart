import 'package:flutter/material.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:get/get.dart';
import '../controller/card_controller.dart';
import '../controller/data_controller.dart';
import '../model/card_model.dart';
import '../model/user_model.dart';
import '../widgets/main_card.dart';
import 'card_form_screen.dart';
import 'package:campus_plus/views/schedule.dart';


class RecentActivityScreen extends StatefulWidget {
  const RecentActivityScreen({Key? key}) : super(key: key);

  @override
  State<RecentActivityScreen> createState() => _RecentActivityScreenState();
}

class _RecentActivityScreenState extends State<RecentActivityScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late DataController dataController;
  late CardController cardController;
  late final MyUser userInfo;
  late Future<List<MyCard>> futureCards;

  @override
  void initState() {
    super.initState();
    dataController = Get.put(DataController());
    cardController = Get.put(CardController());
    userInfo = dataController.getLocalData();
    futureCards = gettingMyCards();
  }

  Future<List<MyCard>> gettingMyCards() async {
    return await cardController.getMyCards();
  }

  Future<void> refreshCards() async {
    final newCards = gettingMyCards();
    setState(() {
      futureCards = newCards;
    });
  }

  Future<void> updatePage() async {
    final newCards = gettingMyCards();
    await Future.delayed(const Duration(milliseconds: 300));
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: ()=> Navigator.pop(context),
            ),
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
            ]),
        body: Container(
            color: Colors.white,
            child: FutureBuilder(
              future: futureCards,
              builder: (context, snapshot){
                return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    strokeWidth: 4.0,
                    onRefresh: updatePage,
                    child: _listView(snapshot, userInfo, refreshCards)
                );
              },
            )
        )
    );
  }
}

Widget _listView(AsyncSnapshot snapshot, MyUser userInfo, Function refreshCards) {
  if(!snapshot.hasData){
    return Center(child: CircularProgressIndicator(color: AppColors.aubRed));
  }
  if(snapshot.hasError){
    return const Text('Something went wrong');
  }
  final cards = snapshot.data;
  return ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index){
              if(cards[index].createdBy == userInfo.userId){
                return MainCard(
                  card: cards[index],
                  personal: true,
                  refreshCards: refreshCards,
                );}
              else{
                return MainCard(
                  card: cards[index],
                  personal: false,
                  refreshCards: refreshCards,
                );}
            },
          );
}


