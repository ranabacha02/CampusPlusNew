import 'dart:io';
import 'dart:core';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/data_controller.dart';


final CollectionReference courseCollection = FirebaseFirestore.instance.collection("Courses");
DataController dataController = Get.put(DataController());


class MyCourse {
  String createdBy;
  String courseName;
  String department;
  int price;
  CleanUser user;
  // final Timestamp eventEnd;
  // final List<String> tags;
  FirebaseAuth auth = FirebaseAuth.instance;


  MyCourse({
    required this.createdBy,
    required this.courseName,
    required this.department,
    required this.price,
    required this.user

  });

  MyCourse.fromFirestore(Map<String, dynamic> snapshot):
        createdBy = snapshot['createdBy'],
        courseName = snapshot['courseName'],
        department = snapshot['department'],
        price = snapshot['price'],
        user = snapshot['user'];


  Map<String, dynamic> toFirestore(){
    return {
      'createdBy': createdBy,
      'courseName' : courseName,
      'department' : department,
      'price' : price,
      'user' : user,


    };
  }



  Future createCourse() async {
    final DocumentReference newCourseRef = FirebaseFirestore.instance.collection("Courses").doc();
    final courseData = {
      'id' : newCourseRef.id,
      'createdBy': createdBy,
      'courseName' : courseName,
      'department' : department,
      'price' : price,
      'user' : user,
    };
    final complete = newCourseRef.set(courseData).then((doc)=> true, onError: (r)=> false);
    return complete;
  }



  static Future<bool> removeCourse(String courseId) async {
    final CollectionReference courseCollection = FirebaseFirestore.instance.collection("Courses");
    final complete = courseCollection.doc(courseId).delete().then((doc)=> true, onError: (e)=> false);
    return complete;
  }

  static Stream<QuerySnapshot<Object?>> getStreamOfCourses(){
    final CollectionReference courseCollection = FirebaseFirestore.instance.collection("Courses");
    return courseCollection.orderBy('eventStart').snapshots();
  }

  static Future<List<MyCourse>> getAllCourses() async {
    final CollectionReference courseCollection = FirebaseFirestore.instance.collection("Courses");
    final snapshots = await courseCollection.get();
    List<MyCourse> courses = snapshots.docs.map<MyCourse>((doc) => MyCourse.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return courses;
  }
  static Future<List<MyCourse>> getAllVisibleCourses() async{
    final MyUser user = dataController.getLocalData();
    final snapshots = await courseCollection.where("createdBy", whereIn: [user.userId]).get();
    List<MyCourse> courses = snapshots.docs.map<MyCourse>((doc) => MyCourse.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return courses;
  }


  static Future getMyCreatedCourses(String userId) async{
    final CollectionReference courseCollection = FirebaseFirestore.instance.collection("Courses");
    final snapshots = await courseCollection.where("createdBy", isEqualTo: userId).get();
    List<MyCourse> courses = snapshots.docs.map<MyCourse>((doc) => MyCourse.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return courses;
  }





  





}
