import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/data_controller.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import '../controller/card_controller.dart';
import '../model/card_model.dart';
import '../model/clean_user_model.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart';

class MainCardForm extends StatefulWidget {
  const MainCardForm({Key? key}) : super(key: key);

  @override
  State<MainCardForm> createState() => _MainCardFormState();
}

class _MainCardFormState extends State<MainCardForm> {

  _MainCardFormState(){
    _selectedVal = _audienceList[0];
  }

  final _eventController = TextEditingController();
  final List<String>_audienceList = ["Everyone", "MyDepartment", "MyYear"];
  String _selectedVal = "Everyone";
  DateTime chosenDateTime = DateTime.now();
  late DataController dataController;
  late final MyUser userInfo;
  late final CleanUser cleanUserInfo;
  CardController cardController = Get.put(CardController());

  @override
  void initState() {
    super.initState();
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
    cleanUserInfo = CleanUser.fromMyUser(userInfo);

  }

  @override
  void dispose(){
    _eventController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: ()=> Navigator.pop(context),
        ),
          backgroundColor: AppColors.white,
          title: Text(
            "CAMPUS+",
            style: TextStyle(
              fontSize: 30,
              color: AppColors.aubRed,
            ),
          ),
        ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            TextFormField(
              controller: _eventController,
              decoration: InputDecoration(
                  labelText: 'Event Description',
                  prefixIcon: Icon(Icons.emoji_people_rounded),
                  border: OutlineInputBorder()
              ),
              minLines:2,
              maxLines: 4,
              maxLength: 200,
            ),
            SizedBox(
              height: 20,
            ),
            DropdownButtonFormField(
              items: _audienceList.map(
                      (String item)=> DropdownMenuItem<String>(child: Text(item), value: item,)
              ).toList(),
              onChanged: (val){
                setState((){_selectedVal =val as String;});
              },
              value: _selectedVal,
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color:  Color.fromRGBO(144, 0, 49, 1),
              ),
              decoration: InputDecoration(
                  labelText: "Select audience",
                  border: OutlineInputBorder()
              ),

            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                ),
                child: Text(DateFormat.yMMMd('en_US').add_jm().format(chosenDateTime))
            ),
            myBtn(context),
          ],
        ),
      ),
    );
  }

  OutlinedButton myBtn(BuildContext context) {
    return OutlinedButton(
      child: Text("Post Card"),
      onPressed: (){
        cardController.createCard(_eventController.text, DateTime.now(),chosenDateTime);
        Navigator.pop(context);
      },
    );
  }
}
