import 'package:campus_plus/model/clean_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/data_controller.dart';
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

  late AuthController authController;
  FirebaseAuth auth = FirebaseAuth.instance;
  late DataController dataController;
  late final MyUser userInfo;
  late final List<dynamic> coursesList = userInfo.tutoringClasses;



  @override
  void initState() {
    super.initState();
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
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
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('Courses').where("createdBy", isEqualTo: auth.currentUser!.uid).snapshots(),
              builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                  ) {
                if(snapshot.hasError){
                  return const Text('Something went wrong');
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Text('Loading');

                }
                final data = snapshot.requireData;
                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index){
                    return MainCourse(courseName: data.docs[index]['courseName'], department: data.docs[index]['department'], price: data.docs[index]['price'], user: CleanUser.fromFirestore(data.docs[index]['user']));
                  },
                );
              },
            )
        ));
  }

}
