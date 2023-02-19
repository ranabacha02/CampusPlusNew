import 'package:campus_plus/controller/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/chat_controller.dart';
import '../model/chat_model.dart';
import '../model/user_model.dart';
import '../utils/app_colors.dart';
import '../widgets/user_profile_picture.dart';
import 'package:get/get.dart';
import 'chat_page_screen.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late Future<MyUser> userInfo;
  late UserController userController;
  late ChatController chatController;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState(){
    super.initState();
    userController = Get.put(UserController());
    chatController = Get.put(ChatController());
    userInfo = userController.getUserById(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: ()=> Navigator.pop(context),
        ),
        title: Text(
          "CAMPUS+",
          style: TextStyle(
            fontSize: 30,
            color: AppColors.aubRed,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
          future: userInfo,
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(color:AppColors.aubRed));
            }
            if(snapshot.hasError){
              return const Text('Something went wrong');
            }
            final user = snapshot.data;
            return
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 42,
                                child:UserProfilePicture(
                                  imageURL: user!.profilePictureURL,
                                  caption: "${user.firstName} ${user.lastName}",
                                  radius: 40,
                                  preview: false,
                                )
                            ),
                            Text(
                              "${user.firstName} ${user.lastName}",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "${user.major} | ${user.graduationYear}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(107, 114, 128, 1),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                        user.description,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(107, 114, 128, 1),
                        )
                    ),
                    // user.userId != auth.currentUser!.uid
                    //     ? IconButton(
                    //       icon: const Icon(Icons.contact_mail),
                    //       onPressed: () async {
                    //         Chat chat = await chatController.createChat(
                    //             "${user.firstName} ${user.lastName}",
                    //             auth.currentUser!.uid,
                    //             user.userId,
                    //             user.email);
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => ChatPageScreen(
                    //                     chatId: chat.chatId,
                    //                     chatName:
                    //                     "${user.firstName} ${user.lastName}",
                    //                     privateChat: chat.isGroup,
                    //                     imageURL: user.profilePictureURL)));
                    //       },
                    //     )
                    //         : Container(),
                  ],
                );
          }
        )
    ));
  }
}
