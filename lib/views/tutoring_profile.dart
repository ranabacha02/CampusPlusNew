import 'package:campus_plus/model/clean_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/course_controller.dart';
import '../controller/data_controller.dart';
import '../model/course_model.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart';
import '../widgets/main_course.dart';
import 'coursesForm.dart';

class TutoringProfileScreen extends StatefulWidget{
  const TutoringProfileScreen({super.key});

  @override
  _TutoringProfileScreenState createState() => _TutoringProfileScreenState();
}

class _TutoringProfileScreenState extends State<TutoringProfileScreen> {

  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  late AuthController authController;
  FirebaseAuth auth = FirebaseAuth.instance;
  late DataController dataController;
  late CourseController courseController;
  late final MyUser userInfo;
  late Future<List<MyCourse>> futureCourses;
  late final List<dynamic> coursesList = userInfo.tutoringClasses;



  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
    futureCourses = gettingCourses();
  }

  Future<List<MyCourse>> gettingCourses() async {
    return await courseController.getAllVisibleCourses();
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () => {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const MainCourseForm();
                      }))
                    },
                icon: Image.asset('assets/postIcon.png')),
            ]
         ,
          backgroundColor: AppColors.white,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: Text(
            "Courses I am tutoring",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.aubRed,
            ),
          ),
        ),
        body: Container(
            color: AppColors.white,
            child: FutureBuilder(
              //child: StreamBuilder<QuerySnapshot>(
              future: futureCourses,
              //stream: FirebaseFirestore.instance.collection('Courses').where("createdBy", isEqualTo: auth.currentUser!.uid).snapshots(),
              builder: (context, snapshot) {
                return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    color: Colors.white,
                    backgroundColor: Colors.blue,
                    strokeWidth: 4.0,
                    onRefresh: updatePage,
                    child: _listView(snapshot, userInfo, refreshCourses)
                );
              },
            )
        ));
  }

}

Widget _listView(AsyncSnapshot snapshot, MyUser userInfo, Function refreshCourses) {
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
            if(courses[index].createdBy == userInfo.userId){
              return MainCourse(
                courseName: courses[index]['courseName'],
                department: courses[index]['department'],
                price: courses[index]['price'],
                  user: CleanUser.fromFirestore(courses[index]['user']),

                refreshCourses: refreshCourses,
              );}
            else{
              return MainCourse(
                courseName: courses[index]['courseName'],
                department: courses[index]['department'],
                price: courses[index]['price'],
                user: CleanUser.fromFirestore(courses[index]['user']),
                refreshCourses: refreshCourses,
              );}
          },
        )),
      ]
  );

}
