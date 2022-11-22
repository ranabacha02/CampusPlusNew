import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/auth_controller.dart';
import '../controller/data_controller.dart';
import '../utils/app_colors.dart';
import '../widgets/app_widgets.dart';
import '../widgets/main_course.dart';
import 'coursesForm.dart';

class TutoringProfileScreen extends StatefulWidget{
  @override
  _TutoringProfileScreenState createState() => _TutoringProfileScreenState();
}

class _TutoringProfileScreenState extends State<TutoringProfileScreen> {

  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;

  late AuthController authController;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;

  late DataController dataController;
  late final userInfo;
  late final List<dynamic> coursesList = userInfo?["tutoringClasses"];
  late String course;



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
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: ()=> Navigator.pop(context),
              ),
              IconButton(
                  onPressed: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){
                          return MainCourseForm();
                        })
                    )
                  },
                  icon: Image.asset('assets/postIcon.png')),
            ]
         ,
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
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
                  return Text('Something went wrong');
                }
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Text('Loading');

                }
                final data = snapshot.requireData;
                return ListView.builder(
                  itemCount: data.size,
                  itemBuilder: (context, index){
                    return MainCourse(event: data.docs[index]['event'], name: data.docs[index]['name']);
                  },
                );
              },
            )
        ));
  }

}