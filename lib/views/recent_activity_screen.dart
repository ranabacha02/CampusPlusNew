import 'package:campus_plus/tabs/joined_cards_tab.dart';
import 'package:campus_plus/tabs/my_cards_tab.dart';
import 'package:flutter/material.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/views/schedule.dart';

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
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
                  onPressed: () => {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return const Schedule();
                      })
                  )},
                  icon: Image.asset('assets/calendarIcon.png')),
            ],
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 3.0, color: AppColors.aubRed),
              insets: EdgeInsets.symmetric(horizontal: 60.0),
            ),
            tabs: <Widget>[
              Tab(
                child: Text('Mine', style: TextStyle(color: AppColors.aubRed),)
              ),
              Tab(
                  child: Text('Joined', style: TextStyle(color: AppColors.aubRed),)
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            MyCardsTab(),
            JoinedCardsTab(),
          ],
        ),
      ),
    );
  }
}




