import 'package:campus_plus/controller/data_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:profanity_filter/profanity_filter.dart';
import '../controller/card_controller.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart';

class MainCardForm extends StatefulWidget {
  const MainCardForm({Key? key}) : super(key: key);

  @override
  State<MainCardForm> createState() => _MainCardFormState();
}

class _MainCardFormState extends State<MainCardForm> {
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
            "CAMPUS+",
            style: TextStyle(
              fontSize: 30,
              color: AppColors.aubRed,
            ),
          ),
        ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: const MyCustomForm(),
      ),
    );
  }
}


enum AttendeeLimit {noLimit, one, two, three, four, five, six, seven, eight, nine, ten}
enum Audience {everyone, department, gender}
enum TagsFilter { study, food, fun, sports}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _eventController = TextEditingController();
  DateTime eventStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute);
  DateTime eventEnd = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, DateTime.now().minute).add(const Duration(hours:1));
  late CardController cardController;
  late DataController dataController;
  late final MyUser userInfo;

  final filter = ProfanityFilter();
  final List<String> _tags = <String>[];
  Audience selectedAudience = Audience.everyone;
  AttendeeLimit selectedLimit = AttendeeLimit.noLimit;

  @override
  void dispose(){
    //not sure if others have to be disposed
    _eventController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    cardController = Get.put(CardController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _eventController,
              decoration: const InputDecoration(
                  labelText: 'Event Description',
                  border: OutlineInputBorder()
              ),
              minLines:2,
              maxLines: 4,
              maxLength: 200,
              validator: (value) {
                if(value?.isEmpty ?? true){
                  return 'Please enter some text';
                }
                if(filter.hasProfanity(value ?? "")){
                  return 'No cursing';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text("Tags"),
                const SizedBox(width: 40),
                buildTagFilterChip(),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text("Event Start"),
                const SizedBox(width:26),
                OutlinedButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime.now().add(const Duration(hours:168)),
                        onChanged: (date) {},
                        onConfirm: (date) {
                          setState(() {
                            eventStart =date;
                            eventEnd = date.add(const Duration(hours:1));
                          });
                        },
                        locale: LocaleType.en,
                      );
                    },
                    style: OutlinedButton.styleFrom(side: const BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid)),
                    child: Text(DateFormat.yMMMd('en_US').add_jm().format(eventStart), style: const TextStyle(color: Colors.black),)
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                const Text("Event End"),
                const SizedBox(width: 33),
                OutlinedButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: eventStart.add(const Duration(hours: 1)),
                        maxTime: eventStart.add(const Duration(hours:24)),
                        onChanged: (date) {},
                        onConfirm: (date) {
                          setState(() {
                            eventEnd =date;
                          });
                        },
                        locale: LocaleType.en,
                      );
                    },
                    style: OutlinedButton.styleFrom(side: const BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid)),
                    child: Text(DateFormat.yMMMd('en_US').add_jm().format(eventEnd), style: const TextStyle(color: Colors.black),)
                ),
              ],
            ),

            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildAudiencePopupMenuButton(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(side: const BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            String audience;
                            if(selectedAudience.name=="department") {
                              audience = userInfo.department;
                            }
                            else if(selectedAudience.name=="gender"){
                              audience = userInfo.gender;
                            }
                            else{
                              audience = "Everyone";
                            }
                            cardController.createCard(event: _eventController.text, audience: audience, attendeeLimit: selectedLimit.index, dateCreated: DateTime.now(), eventStart: eventStart, eventEnd: eventEnd, tags: _tags);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Create'),
                      ),
                    ),
                    buildAttendeeLimitPopupMenuButton(),
                  ],
                ),
              )
            ),
          ],
        )
    );
  }

  PopupMenuButton<AttendeeLimit> buildAttendeeLimitPopupMenuButton() {
    return PopupMenuButton<AttendeeLimit>(
                icon: const Icon(Icons.block_flipped),
                initialValue: selectedLimit,
                onSelected: (AttendeeLimit item) {
                  setState(() {
                    selectedLimit = item;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<AttendeeLimit>>[
                  const PopupMenuItem<AttendeeLimit>(
                    value: AttendeeLimit.noLimit,
                    child: Text('No Limit'),
                  ),
                  const PopupMenuItem<AttendeeLimit>(
                    value: AttendeeLimit.one,
                    child: Text('One'),
                  ),
                  const PopupMenuItem<AttendeeLimit>(
                    value: AttendeeLimit.two,
                    child: Text('Two'),
                  ),
                  const PopupMenuItem<AttendeeLimit>(
                    value: AttendeeLimit.three,
                    child: Text('Three'),
                  ),
                  const PopupMenuItem<AttendeeLimit>(
                    value: AttendeeLimit.five,
                    child: Text('Five'),
                  ),
                  const PopupMenuItem<AttendeeLimit>(
                    value: AttendeeLimit.ten,
                    child: Text('Ten'),
                  ),
                ],
              );
  }

  PopupMenuButton<Audience> buildAudiencePopupMenuButton() {
    return PopupMenuButton<Audience>(
              icon: const Icon(Icons.people_outline),
              initialValue: selectedAudience,
              onSelected: (Audience item) {
                setState(() {
                  selectedAudience = item;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Audience>>[
                const PopupMenuItem<Audience>(
                  value: Audience.everyone,
                  child: Text('Everyone'),
                ),
                const PopupMenuItem<Audience>(
                  value: Audience.department,
                  child: Text('My department'),
                ),
                const PopupMenuItem<Audience>(
                  value: Audience.gender,
                  child: Text('My gender'),
                ),
              ],
            );
  }

  Wrap buildTagFilterChip() {
    return Wrap(
      spacing: 5.0,
      children: TagsFilter.values.map((TagsFilter tag){
        return FilterChip(
            label: Text(tag.name),
            selected: _tags.contains(tag.name),
            onSelected: (bool value){
              setState(() {
                if (value) {
                  if (!_tags.contains(tag.name)) {
                    _tags.add(tag.name);
                  }
                } else {
                  _tags.removeWhere((String name) {
                    return name == tag.name;
                  });
                }
              });
            });
      }).toList(),
    );
  }
}



