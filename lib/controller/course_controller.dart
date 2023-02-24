import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../model/clean_user_model.dart';
import '../model/course_model.dart';
import 'data_controller.dart';

class CourseController extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  DataController dataController = Get.put(DataController());


  void createCourse(String courseName, String department, int price) {
    CleanUser user = CleanUser.fromMyUser(dataController.getLocalData());
    MyCourse course= MyCourse(
      createdBy: auth.currentUser!.uid,
      courseName: courseName,
      department: department,
      price: price,
      user: user,
    );
    course.createCourse();
  }


  Future<bool> removeCourse(String courseId) async {
    return MyCourse.removeCourse(courseId);
  }

  Future getStreamOfCourses() async {
    return MyCourse.getStreamOfCourses();
  }

  Future getAllCourses() async {
    return MyCourse.getAllCourses();
  }

  Future<List<MyCourse>> getAllVisibleCourses() async{
    return MyCourse.getAllVisibleCourses();
  }




  Future getMyCourses() async{
    final myCreatedCourses = await MyCourse.getMyCreatedCourses(auth.currentUser!.uid);
    List<MyCourse> myCourses = myCreatedCourses;
    return myCourses;
  }
}

