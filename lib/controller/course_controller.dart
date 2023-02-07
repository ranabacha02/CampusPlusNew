import 'dart:collection';
import 'dart:io';
import 'dart:ui';

import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';

import '../model/clean_user_model.dart';
import '../model/course_model.dart';
import '../views/edit_account_screen.dart';
import '../widgets/nav_bar.dart';
import 'data_controller.dart';

class CourseController extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;
  DataController dataController = Get.put(DataController());




  void createcourse(String event, String department, String price) {
    CleanUser user = CleanUser.fromMyUser(dataController.getLocalData());
    MyCourse course= MyCourse(
        createdBy: auth.currentUser!.uid,
        event: event,
        department: department,
        price: price,
        user: user,


    );
    course.createCourse();
  }





  Future<bool> removeCard(String cardId) async {
    return MyCourse.removeCourse(cardId);
  }

  Future getStreamOfCards() async {
    return MyCourse.getStreamOfCourses();
  }

  Future getAllCards() async {
    return MyCourse.getAllCourses();
  }


  Future getMyCourses() async{
    final myCreatedCards = await MyCourse.getMyCreatedCourses(auth.currentUser!.uid);
    List<MyCourse> myCards = myCreatedCards;
    return myCards;
  }
}

