import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:page_transition/page_transition.dart';
import '../controller/card_controller.dart';
import '../model/card_model.dart';
import '../utils/app_colors.dart';
import '../widgets/nav_bar.dart';
import 'package:get/get.dart';


class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

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
      DateTime eventStart = card.eventStart;
      DateTime eventEnd = card.eventEnd;
      final cleanEventDate = DateTime(eventStart.year, eventStart.month, eventStart.day);
      final cleanEventStartTime = DateTime(eventStart.year, eventStart.month, eventStart.day, eventStart.hour, eventStart.minute);
      final cleanEventEndTime = DateTime(eventEnd.year, eventEnd.month, eventEnd.day, eventEnd.hour, eventEnd.minute);
      if (!events.containsKey(cleanEventDate)) {
        events[cleanEventDate] = [];
      }
      events[cleanEventDate]?.add(CleanCalendarEvent(
        card.event,
        startTime: cleanEventStartTime,
        endTime: cleanEventEndTime,
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.push(context,
                PageTransition(
                  child: NavBarView(index: 2,),
                  type: PageTransitionType.leftToRightJoined,
                  childCurrent: const Schedule(),
                ),),
        ),
        backgroundColor: AppColors.aubRed,
        title: const Text('My Schedule'),
      ),
      body:  SafeArea(
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
    );
  }
}
