import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/data_controller.dart';


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
  CollectionReference cards = FirebaseFirestore.instance.collection('Cards');

  late DataController dataController;
  late final userInfo;
  @override
  void initState() {
    super.initState();
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
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
        title: const Text("Create Card"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(144, 0, 49, 1),
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
        cards
            .add({'createdBy': userInfo['userId'] , 'name': userInfo['firstName'], 'event': _eventController.text})
            .then((value)=> print('Card added'))
            .catchError((error)=> print('Failed to add user: $error'));
        Navigator.pop(context);
      },
    );
  }
}
