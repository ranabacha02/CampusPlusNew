import 'package:campus_plus/controller/course_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../model/clean_user_model.dart';
import '../utils/app_colors.dart';
import '../widgets/main_course.dart';
import 'coursesForm.dart';

class TutoringSectionScreen extends StatefulWidget{
  @override
  _TutoringSectionScreenState createState() => _TutoringSectionScreenState();
}

class _TutoringSectionScreenState extends State<TutoringSectionScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize / WidgetsBinding.instance.window.devicePixelRatio;
  Stream? courses;
  FirebaseAuth auth = FirebaseAuth.instance;
  late CourseController courseController;
  String searchInput="";
  
  @override
  void initState() {
    super.initState();
    courseController = Get.put(CourseController());
    gettingCourses();
  }
  
  gettingCourses() async{
    await courseController.getStreamOfCourses().then((snapshot){
      setState(() {
        courses = snapshot;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
            title: Card(
              child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                onChanged: (val) {
                  setState(() {
                    searchInput = val;
                  });
                },
              ),
            ),
        ),
        body: Container(
            color: AppColors.white,
            child: StreamBuilder(
              stream: courses,
              builder: (
                  BuildContext context, AsyncSnapshot snapshot) {
                if(!snapshot.hasData){
                  return Center(child: CircularProgressIndicator(color: AppColors.aubRed));
                }
                if(snapshot.hasError){
                  return const Text('Something went wrong');
                }
                final data = snapshot.requireData;
                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index){
                    var data2 = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    if (searchInput.isEmpty){
                      return MainCourse(
                          courseName: snapshot.data!.docs[index]['courseName'],
                          department: snapshot.data!.docs[index]['department'],
                          price: int.parse(snapshot.data!.docs[index]['price']),
                          user: CleanUser.fromFirestore(data.docs[index]['user']),
                         );
                    }
                    if (data2['searchInput']
                        .toString()
                        .toLowerCase()
                        .contains(searchInput.toLowerCase())) {
                      return MainCourse(
                        courseName: snapshot.data!.docs[index]['courseName'],
                        department: snapshot.data!.docs[index]['department'],
                        price: int.parse(snapshot.data!.docs[index]['price']),
                        user: CleanUser.fromFirestore(data.docs[index]['user']),
                      );
                    }
                    if (data2['courseName']
                        .toString()
                        .toLowerCase()
                        .contains(searchInput.toLowerCase())) {
                      return MainCourse(
                        courseName: snapshot.data!.docs[index]['courseName'],
                        department: snapshot.data!.docs[index]['department'],
                        price: int.parse(snapshot.data!.docs[index]['price']),
                        user: CleanUser.fromFirestore(data.docs[index]['user']),
                      );
                    }
                    if (data2['department']
                        .toString()
                        .toLowerCase()
                        .contains(searchInput.toLowerCase())) {
                      return MainCourse(
                        courseName: snapshot.data!.docs[index]['courseName'],
                        department: snapshot.data!.docs[index]['department'],
                        price: int.parse(snapshot.data!.docs[index]['price']),
                        user: CleanUser.fromFirestore(data.docs[index]['user']),
                      );
                    }
                    else {
                      return Container();
                    }
                  },
                );
              },
            )
        ));
  }

}