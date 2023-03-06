import 'package:campus_plus/tabs/all_cards_tab.dart';
import 'package:campus_plus/tabs/tagged_cards_tab.dart';
import 'package:flutter/material.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/views/schedule.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'card_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 5,
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
          actions: <Widget>[
            IconButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return const MainCardForm();
                    }),
                  );
                  //TODO refresh page after adding card
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
          ],
          bottom: TabBar(
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(width: 3.0, color: AppColors.aubRed),
              insets: const EdgeInsets.symmetric(horizontal: 20.0),
            ),
            tabs: <Widget>[
              Tab(
                  icon: FaIcon(FontAwesomeIcons.house, color: AppColors.aubRed, size:20.0)
              ),
              Tab(
                  icon: Icon(Icons.celebration ,color: AppColors.aubRed,)
              ),
              Tab(
                  icon: FaIcon(FontAwesomeIcons.bookOpen, color: AppColors.aubRed, size:20.0)
              ),
              Tab(
                  icon: FaIcon(FontAwesomeIcons.pizzaSlice, color: AppColors.aubRed, size:20.0)
              ),
              Tab(
                icon: FaIcon(FontAwesomeIcons.futbol, color: AppColors.aubRed, size:20.0)
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            AllCardsTab(),
            TaggedCardsTab(tag: 'fun'),
            TaggedCardsTab(tag: 'study'),
            TaggedCardsTab(tag: 'food'),
            TaggedCardsTab(tag: 'sports'),
          ],
        ),
      ),
    );
  }
}




