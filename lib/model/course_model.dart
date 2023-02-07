import 'dart:ffi';
import 'dart:io';
import 'dart:core';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyCourse {
  String createdBy;
  String courseName;
  String department;
  //TODO refactor price to be an integer
  int price;
  CleanUser user;
  FirebaseAuth auth = FirebaseAuth.instance;


  MyCourse({
    required this.createdBy,
    required this.courseName,
    required this.department,
    required this.price,
    required this.user,
  });

  MyCourse.fromFirestore(Map<String, dynamic> snapshot):
        createdBy = snapshot['createdBy'],
        courseName = snapshot['courseName'],
        department = snapshot['department'],
        price = int.parse(snapshot['price']),
        user = CleanUser.fromFirestore(snapshot['user']);





  Map<String, dynamic> toFirestore(){
    return {
      'createdBy': createdBy,
      'courseName' : courseName,
      'department' : department,
      'price' : price,
      'user' : user.toFirestore(),
    };
  }



  Future createCourse() async {
    final CollectionReference courseCollection = FirebaseFirestore.instance.collection("Courses");
    courseCollection.add(this.toFirestore());
  }



  static Future<bool> removeCourse(String courseId) async {
    final CollectionReference courseCollection = FirebaseFirestore.instance.collection("Courses");
    final complete = courseCollection.doc(courseId).delete().then((doc)=> true, onError: (e)=> false);
    return complete;
  }

  static Stream<QuerySnapshot<Object?>> getStreamOfCourses(){
    final CollectionReference courseCollection = FirebaseFirestore.instance.collection("Courses");
    return courseCollection.snapshots();
  }

  static Future<List<MyCourse>> getAllCourses() async {
    final CollectionReference courseCollection = FirebaseFirestore.instance.collection("Courses");
    final snapshots = await courseCollection.get();
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
