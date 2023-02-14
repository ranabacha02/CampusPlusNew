import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:profanity_filter/profanity_filter.dart';
import '../controller/card_controller.dart';
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


//help, gym
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {

  @override
  void dispose(){
    _eventController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final _eventController = TextEditingController();
  DateTime chosenDateTime = DateTime.now();
  CardController cardController = Get.put(CardController());
  final filter = ProfanityFilter();
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
            const TagFilterChip(),
            const SizedBox(
              height: 20,
            ),
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
                        chosenDateTime =date;
                      });
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.en,
                  );
                },
                style: OutlinedButton.styleFrom(side: const BorderSide(width: 1, color: Colors.black, style: BorderStyle.solid)),
                child: Text(DateFormat.yMMMd('en_US').add_jm().format(chosenDateTime), style: TextStyle(color: Colors.black),)
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const AudiencePopupMenu(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(side: const BorderSide(width: 1, color: Colors.blue, style: BorderStyle.solid)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {

                          }
                        },
                        child: const Text('Create'),
                      ),
                    ),
                    const AttendeeLimitPopupMenu(),
                  ],
                ),
              )
            ),
          ],
        )
    );
  }
}

enum TagsFilter { study, food, fun, sports}
class TagFilterChip extends StatefulWidget {
  const TagFilterChip({Key? key}) : super(key: key);

  @override
  State<TagFilterChip> createState() => _TagFilterChipState();
}

class _TagFilterChipState extends State<TagFilterChip> {
  bool favorite = false;
  final List<String> _filters = <String>[];
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5.0,
      children: TagsFilter.values.map((TagsFilter tag){
        return FilterChip(
            label: Text(tag.name),
            selected: _filters.contains(tag.name),
            onSelected: (bool value){
              setState(() {
                if (value) {
                  if (!_filters.contains(tag.name)) {
                    _filters.add(tag.name);
                  }
                } else {
                  _filters.removeWhere((String name) {
                    return name == tag.name;
                  });
                }
              });
        });
      }).toList(),
    );
  }
}

enum Audience {everyone, department, gender}
class AudiencePopupMenu extends StatefulWidget {
  const AudiencePopupMenu({Key? key}) : super(key: key);


  @override
  State<AudiencePopupMenu> createState() => _AudiencePopupMenuState();
}

class _AudiencePopupMenuState extends State<AudiencePopupMenu> {
  Audience selectedAudience = Audience.everyone;
  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton<Audience>(
      icon: const Icon(Icons.people_outline),
      initialValue: selectedAudience,
      // Callback that sets the selected popup menu item.
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
}


enum AttendeeLimit {one, two, three, five, ten, noLimit}
class AttendeeLimitPopupMenu extends StatefulWidget {
  const AttendeeLimitPopupMenu({Key? key}) : super(key: key);


  @override
  State<AttendeeLimitPopupMenu> createState() => _AttendeeLimitPopupMenuState();
}

class _AttendeeLimitPopupMenuState extends State<AttendeeLimitPopupMenu> {
  AttendeeLimit selectedLimit = AttendeeLimit.noLimit;
  @override
  Widget build(BuildContext context) {
    return  PopupMenuButton<AttendeeLimit>(
      icon: const Icon(Icons.block_flipped),
      initialValue: selectedLimit,
      // Callback that sets the selected popup menu item.
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
}



