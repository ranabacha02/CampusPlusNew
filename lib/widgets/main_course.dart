import 'package:campus_plus/controller/chat_controller.dart';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/course_controller.dart';
import '../model/chat_model.dart';
import '../model/course_model.dart';
import '../views/chat_page_screen.dart';

class MainCourse extends StatelessWidget {
  MainCourse({
    Key? key,
    //required this.courseName,
    //required this.department,
    //required this.price,
    //required this.user,
    required this.course,
    required this.refreshCourses
  }) : super(key: key);

  //final String courseName;
  //final String department;
  //final int price;
  //final CleanUser user;
  final MyCourse course;
  final Function refreshCourses;
  final CourseController cardController = Get.put(CourseController());
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Container(
      height: 130,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              UserProfilePicture(
                  imageURL: course.user.profilePictureURL,
                  caption: course.user.firstName,
                  radius: 30),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${course.user.firstName} ${course.user.lastName}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      course.courseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      course.department,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Price per hour : ${course.price}\$",
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              course.user.userId != auth.currentUser!.uid
                  ? IconButton(
                      icon: const Icon(Icons.contact_mail),
                      onPressed: () async {
                        ChatController chatController =
                            Get.put(ChatController());
                        refreshCourses();
                        Chat chat =
                            await chatController.createChat(course.user.userId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPageScreen(
                                    //refreshCourses: widget.refreshCourses,
                                    chatId: chat.chatId,
                                    chatName:
                                        "${course.user.firstName} ${course.user.lastName}",
                                    privateChat: chat.isGroup,
                                    imageURL: course.user.profilePictureURL)));
                      },
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
