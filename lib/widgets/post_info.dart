import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/post_controller.dart';
import '../model/post_model.dart';
import '../utils/app_colors.dart';
import 'package:get/get.dart';


class PostInfo extends StatelessWidget {
  PostInfo({
    Key? key,
    required this.post,
    required this.personal,

  }) : super(key: key);
  final MyPost post;
  final bool personal;
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                  children: [
                    Text(
                      "${post.users[0].firstName} ${post.users[0].lastName}",
                      style: TextStyle(
                          fontSize: 24,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${post.users[0].major} | ${post.users[0].graduationYear}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(107, 114, 128, 1),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ] )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Event",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
              post.event,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(107, 114, 128, 1),
              )
          ),
          const SizedBox(
            height: 10,
          ),
          Row(children: [



          ],),


          Wrap(
            spacing: 4,
            runSpacing: 5,
            children:
            [for (var user in post.users.sublist(1,))
              UserProfilePicture(
                imageURL: user.profilePictureURL,
                caption: "${user.firstName} ${user.lastName}",
                radius: 20,
                preview: false,
                userId: user.userId,
              )
            ],
          ),
        ],
      ),
    );
  }
}
