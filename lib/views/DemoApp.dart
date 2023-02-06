import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:page_transition/page_transition.dart';

import '../controller/card_controller.dart';
import '../model/card_model.dart';
import '../utils/app_colors.dart';
import '../widgets/nav_bar.dart';
import 'home_screen.dart';



class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {

  DateTime selectedDay = DateTime.now();
  late List <CleanCalendarEvent> selectedEvent;
  Map<DateTime, List<CleanCalendarEvent>> events ={};
  final cardController = CardController();



  void _handleData(date){
    setState(() {
      selectedDay = date;
      selectedEvent = events[selectedDay] ?? [];
    });
    print(selectedDay);
  }
  @override
  void initState() {
    // TODO: implement initState
    selectedEvent = events[selectedDay] ?? [];
    super.initState();
    fetchEvents();
  }

  void fetchEvents() async{
    List<MyCard> joinedCards = await cardController.getCards();
    joinedCards.forEach((card) {
      if (!events.containsKey(card.eventStart)) {
        events[card.eventStart] = [];
      }
      events[card.eventStart]?.add(CleanCalendarEvent(
        card.event,
        startTime: card.eventStart,
        endTime: card.eventStart.add(Duration(hours: 2)),
        color: Colors.black,
      ));
    });
    print(events);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.push(context,
                PageTransition(
                  child: NavBarView(index: 2,),
                  type: PageTransitionType.leftToRightJoined,
                  childCurrent: DemoApp(),
                ),),
        ),
        backgroundColor: AppColors.aubRed,
        title: Text('My Schedule'),
      ),
      body:  SafeArea(
        child: Container(
          child: Calendar(
            startOnMonday: true,
            selectedColor: Colors.blue,
            todayColor: Colors.red,
            eventColor: Colors.green,
            eventDoneColor: Colors.amber,
            bottomBarColor: Colors.deepOrange,
            onRangeSelected: (range) {
              print('selected Day ${range.from},${range.to}');

            },
            onDateSelected: (date){
              return _handleData(date);
            },
            events: events,
            isExpanded: true,
            dayOfWeekStyle: TextStyle(
              fontSize: 15,
              color: Colors.black12,
              fontWeight: FontWeight.w100,
            ),
            bottomBarTextStyle: TextStyle(
              color: Colors.white,
            ),
            hideBottomBar: false,
            hideArrows: false,
            weekDays: ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],
          ),
        ),
      ),
    );
  }
}