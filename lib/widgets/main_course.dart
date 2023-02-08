import 'package:campus_plus/controller/chat_controller.dart';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/widgets/app_widgets.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../model/chat_model.dart';
import '../views/chat_page_screen.dart';
import 'ContactPage.dart';

class MainCourse extends StatelessWidget {
  const MainCourse({
    Key? key,
    required this.courseName,
    required this.department,
    required this.price,
    required this.user,
  }) : super(key: key);

  final String courseName;
  final String department;
  final int price;
  final CleanUser user;

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
                  imageURL: user.profilePictureURL,
                  caption: user.firstName,
                  radius: 30),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.firstName + " " + user.lastName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Text(
                      courseName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      department,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Price per hour : $price\$",
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              user.userId != auth.currentUser!.uid
                  ? IconButton(
                      icon: const Icon(Icons.contact_mail),
                      onPressed: () async {
                        ChatController chatController =
                            Get.put(ChatController());

                        Chat chat = await chatController.createChat(
                            user.firstName + " " + user.lastName,
                            auth.currentUser!.uid,
                            user.userId,
                            user.email);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPageScreen(
                                    chatId: chat.chatId,
                                    chatName:
                                        user.firstName + " " + user.lastName,
                                    privateChat: chat.isGroup,
                                    imageURL: user.profilePictureURL)));
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
