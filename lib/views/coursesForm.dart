import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/course_controller.dart';
import '../controller/data_controller.dart';
import '../model/clean_user_model.dart';
import '../model/user_model.dart';


class MainCourseForm extends StatefulWidget {
  const MainCourseForm({Key? key}) : super(key: key);

  @override
  State<MainCourseForm> createState() => _MainCourseFormState();
}

class _MainCourseFormState extends State<MainCourseForm> {



  final _courseController = TextEditingController();
  final _departmentController = TextEditingController();
  final _priceController = TextEditingController();
  late final CleanUser cleanUserInfo;
  CourseController courseController = Get.put(CourseController());

  CollectionReference courses = FirebaseFirestore.instance.collection('Courses');

  late DataController dataController;
  late final MyUser userInfo;
  @override
  void initState() {
    super.initState();
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
  }

  @override
  void dispose(){
    _courseController.dispose();
    _departmentController.dispose();
    _priceController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enter Name of the course"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(144, 0, 49, 1),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextFormField(
              controller: _courseController,
              decoration: const InputDecoration(
                  labelText: 'Course Name',
                  prefixIcon: Icon(Icons.emoji_people_rounded),
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _departmentController,
              decoration: const InputDecoration(
                  labelText: 'Department',
                  prefixIcon: Icon(Icons.emoji_people_rounded),
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.emoji_people_rounded),
                  border: OutlineInputBorder()
              ),
            ),
            const SizedBox(
              height: 20,
            ),


            const SizedBox(
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
      child: const Text("Add Course"),
      onPressed: (){
        courseController.createCourse(_courseController.text, _departmentController.text, int.parse(_priceController.text));
        Navigator.pop(context);
      }
    );
  }
}

