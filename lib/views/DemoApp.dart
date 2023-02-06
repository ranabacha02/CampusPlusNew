import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/clean_calendar_event.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import '../controller/card_controller.dart';
import '../model/card_model.dart';
import '../utils/app_colors.dart';
import '../widgets/nav_bar.dart';
import 'package:get/get.dart';


class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {

  DateTime selectedDay = DateTime.now();
  late List <CleanCalendarEvent> selectedEvent;
  Map<DateTime, List<CleanCalendarEvent>> events ={};
  late CardController cardController;


  void _handleData(date){
    setState(() {
      selectedDay = date;
      selectedEvent = events[selectedDay] ?? [];
    });
  }

  @override
  void initState() {
    cardController = Get.put(CardController());
    selectedEvent = events[selectedDay] ?? [];
    super.initState();
    fetchEvents();
  }

  void fetchEvents() async{
    List<MyCard> joinedCards = await cardController.getMyCards();
    for (var card in joinedCards) {
      DateTime date = card.eventStart;
      final cleanDate = DateTime(date.year, date.month, date.day);
      final cleanTime = DateTime(date.year, date.month, date.day, date.hour, date.minute);
      if (!events.containsKey(cleanDate)) {
        events[cleanDate] = [];
      }
      events[cleanDate]?.add(CleanCalendarEvent(
        card.event,
        startTime: cleanTime,
        endTime: cleanTime.add(Duration(hours: 2)),
        color: Colors.black,
      ));
    }
    setState(() => {});
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
            },
            onDateSelected: (date){
              return _handleData(date);
            },
            events: events,
            isExpanded: true,
            dayOfWeekStyle: const TextStyle(
              fontSize: 15,
              color: Colors.black12,
              fontWeight: FontWeight.w100,
            ),
            bottomBarTextStyle: const TextStyle(
              color: Colors.white,
            ),
            hideBottomBar: false,
            hideArrows: false,
            weekDays: const ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'],
          ),
        ),
      ),
    );
  }
}