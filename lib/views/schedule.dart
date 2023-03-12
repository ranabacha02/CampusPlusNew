import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:intl/intl.dart';
import '../controller/card_controller.dart';
import '../model/card_model.dart';
import '../utils/app_colors.dart';
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
      events = events.map((key, value) => MapEntry(key, value.isNotEmpty ? value : [CleanCalendarEvent( card.event,
        startTime: cleanEventStartTime,
        endTime: cleanEventEndTime,
        color: Colors.black,)]));

    }
    setState(() => {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: ()=> Navigator.pop(context),
        ),
        title: Text(
          "",
          style: TextStyle(
            fontSize: 30,
            color: AppColors.aubRed,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Calendar(
                  startOnMonday: true,
                  selectedColor: Colors.blue,
                  todayColor: Colors.red,
                  eventColor: Colors.green,
                  eventDoneColor: Colors.amber,
                  bottomBarColor: AppColors.aubRed,
                  onRangeSelected: (range) {
                  },
                  onDateSelected: (date){
                    return _handleData(date);
                  },
                  events: events,
                  eventListBuilder: (BuildContext context, List<CleanCalendarEvent> events) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (BuildContext context, int index) {
                    final CleanCalendarEvent event = selectedEvent[index];
                    return ListTile(
                    contentPadding:
                    EdgeInsets.only(left: 2.0, right: 8.0, top: -10.0, bottom: 2.0),
                    leading: Container(
                    width: 10.0,
                    color: event.color,
                    ),
                    title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(event.summary),
                    Text(
                    DateFormat('MMM d, h:mm a').format(event.startTime),
                    style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                    ),
                    ),
                    ],
                    ),
                    subtitle:
                    event.description.isNotEmpty ? Text(event.description) : null,
                    trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    onTap: () {},
                    );
                    },
                      ),
                    );
                  },
                  isExpandable: true,
                  dayOfWeekStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
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


            ],
          ),
        ),
      ),
    );
  }





}
