import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/data_controller.dart';
import '../widgets/main_card.dart';
import 'cardForm.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> cards = FirebaseFirestore.instance.collection('Cards').orderBy('eventStart').snapshots();
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  DataController dataController = Get.put(DataController());
  late Map<String, dynamic> userInfo = dataController.getLocalData();

  @override
  void initState() {
    super.initState();
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
                  onPressed: () => {print("hello world")},
                  icon: Image.asset('assets/calendarIcon.png')),
              IconButton(
                  onPressed: () => {print("hello world")},
                  icon: Image.asset('assets/notificationIcon.png')),
            ]),
        body: Container(
          color: AppColors.white,
         child: StreamBuilder<QuerySnapshot>(
             stream: cards,
             builder: (
                 BuildContext context,
                 AsyncSnapshot<QuerySnapshot> snapshot,
             ) {
               if(snapshot.hasError){
                 return Text('Something went wrong');
               }
               if(snapshot.connectionState == ConnectionState.waiting){
                 return Center(child: CircularProgressIndicator(color: AppColors.aubRed));
               }
               final data = snapshot.requireData;
               return ListView.builder(
                 itemCount: data.size,
                 itemBuilder: (context, index){
                   if(data.docs[index]['createdBy']== userInfo['userId']){
                     return MainCard(
                         cardId: data.docs[index].id,
                         event: data.docs[index]['event'],
                         name: data.docs[index]['name'],
                         personal: true,
                         userInfo: userInfo,
                         usersJoined: data.docs[index]['users'],
                         date: (data.docs[index]['eventStart'] as Timestamp).toDate(),
                     );}
                   else{
                    return MainCard(
                        cardId: data.docs[index].id,
                        event: data.docs[index]['event'],
                        name: data.docs[index]['name'],
                        personal: false,
                        userInfo: userInfo,
                        usersJoined: data.docs[index]['users'],
                        date: (data.docs[index]['eventStart'] as Timestamp).toDate(),
                    );}
                 },
               );
             },
         )
        ));
  }
}




