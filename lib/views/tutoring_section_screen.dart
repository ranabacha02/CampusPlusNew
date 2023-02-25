import 'package:campus_plus/controller/course_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../controller/auth_controller.dart';
import '../controller/data_controller.dart';
import '../model/clean_user_model.dart';
import '../model/course_model.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart';
import '../widgets/main_course.dart';
import 'coursesForm.dart';

class TutoringSectionScreen extends StatefulWidget{
  const TutoringSectionScreen({super.key});
  @override
  _TutoringSectionScreenState createState() => _TutoringSectionScreenState();
}

class _TutoringSectionScreenState extends State<TutoringSectionScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize / WidgetsBinding.instance.window.devicePixelRatio;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late AuthController authController;
  //Stream? courses;
  late DataController dataController;
  FirebaseAuth auth = FirebaseAuth.instance;
  late CourseController courseController;
  String searchInput="";
  late final MyUser userInfo;
  late Future<List<MyCourse>> futureCourses;
  late final List<dynamic> coursesList;
  
  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    courseController = Get.put(CourseController());
    userInfo = dataController.getLocalData();
    coursesList = userInfo.tutoringClasses;
    futureCourses = gettingCourses();
  }

  Future<List<MyCourse>> gettingCourses() async {
    return await courseController.getAllStudentsCourses();
  }

  Future<void> refreshCourses() async {
    final newCourses = gettingCourses();
    setState(() {
      futureCourses = newCourses;
    });
  }

  Future<void> updatePage() async {
    final newCourses = gettingCourses();
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      futureCourses = newCourses;
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
                    this.searchInput = val;
                  });
                },
              ),
            ),
        ),
        body: Container(
            color: AppColors.white,
            child: FutureBuilder(
              //stream: courses,
              future: futureCourses,
              builder: (context, snapshot) {
                return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    strokeWidth: 4.0,
                    onRefresh: updatePage,
                    child: _listView(snapshot, userInfo, refreshCourses, searchInput)
                );
              },
            )
        ));
  }

}

Widget _listView(AsyncSnapshot snapshot, MyUser userInfo, Function refreshCourses, String searchInput) {
  if(!snapshot.hasData){
    return Center(child: CircularProgressIndicator(color: AppColors.aubRed));
  }
  if(snapshot.hasError){
    return const Text('Something went wrong');
  }

  final courses = snapshot.data;
  return
    Column(
        children: [
          const SizedBox(height:20),
          Expanded(child: ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index){
              final course = courses[index];
              if (searchInput.isEmpty){
                return MainCourse(
                  course: course,
                  refreshCourses: refreshCourses,
                );
              }
              print("search input "+ searchInput.toLowerCase());
              print("thing "+ course.user.toString());
              if (course.user
                  .toString()
                  .toLowerCase()
                  .contains(searchInput.toLowerCase())) {
                return MainCourse(
                  course: course,
                  refreshCourses: refreshCourses,
                );
              }
              if (course.user
                  .toString()
                  .toLowerCase()
                  .contains(searchInput.toLowerCase())) {
                return MainCourse(
                  course: course,
                  refreshCourses: refreshCourses,
                );
              }
              if (course.department
                  .toString()
                  .toLowerCase()
                  .contains(searchInput.toLowerCase())) {
                return MainCourse(
                  course: course,
                  refreshCourses: refreshCourses,
                );
              }
              else {
                return Container();
              }
            },
          )),
        ]
    );

}