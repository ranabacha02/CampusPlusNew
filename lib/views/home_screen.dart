import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/card_controller.dart';
import '../controller/data_controller.dart';
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

  late DataController dataController;
  late CardController cardController;
  late final MyUser userInfo;
  late final CleanUser cleanUserInfo;
  Stream? cards;
  @override
  void initState() {
    super.initState();

    dataController = Get.put(DataController());
    cardController = Get.put(CardController());
    userInfo = dataController.getLocalData();
    cleanUserInfo = CleanUser.fromMyUser(userInfo);
    gettingCards();
  }

  gettingCards() async {
    await cardController.getStreamOfCards().then((snapshot) {
      setState(() {
        cards = snapshot;
      });
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
                    return MainCardForm();
                    })
                    )
                  },
                  icon: Image.asset('assets/postIcon.png')),
              IconButton(
                  onPressed: () => {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return Schedule();
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
          color: AppColors.white,
         child: StreamBuilder(
             stream: cards,
             builder: (
                 BuildContext context, AsyncSnapshot snapshot) {
               if(!snapshot.hasData){
                 return Center(child: CircularProgressIndicator(color: AppColors.aubRed));
               }
               if(snapshot.hasError){
                 return const Text('Something went wrong');
               }
               final data = snapshot.requireData;
               return ListView.builder(
                 itemCount: data.size,
                 itemBuilder: (context, index){
                   if(data.docs[index]['createdBy']== cleanUserInfo.userId){
                     return MainCard(
                         cardId: data.docs[index].id,
                         event: data.docs[index]['event'],
                         personal: true,
                         userInfo: cleanUserInfo,
                         usersJoined: data.docs[index]['users'].map<CleanUser>((user)=>CleanUser.fromFirestore(user)).toList(),
                         date: (data.docs[index]['eventStart'] as Timestamp).toDate(),
                     );}
                   else{
                    return MainCard(
                        cardId: data.docs[index].id,
                        event: data.docs[index]['event'],
                        personal: false,
                        userInfo: cleanUserInfo,
                        usersJoined: data.docs[index]['users'].map<CleanUser>((user)=>CleanUser.fromFirestore(user)).toList(),
                        date: (data.docs[index]['eventStart'] as Timestamp).toDate(),
                    );}
                 },
               );
             },
         )
        ));
  }
}




