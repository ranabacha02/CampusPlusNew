import 'package:campus_plus/model/post_model.dart';
import 'package:campus_plus/widgets/post_info.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import '../controller/post_controller.dart';
import '../utils/app_colors.dart';

class MainPost extends StatelessWidget {
  MainPost({
    Key? key,
    required this.post,
    required this.personal,
    required this.refreshPosts
  }) : super(key: key);
  final MyPost post;
  final bool personal;
  final Function refreshPosts;
  final PostController postController = Get.put(PostController());
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    bool joined = post.users.where((user)=> (user.userId.contains(auth.currentUser!.uid))).isNotEmpty;
    DateTime now = DateTime.now();
    return Container(
        height: 130,
        margin: const EdgeInsets.only(top: 10),
        child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          Positioned(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: Material(
                color: const Color.fromRGBO(242, 242, 242, 1.0),
                child: InkWell(
                  splashColor: Colors.white,
                  enableFeedback: true,
                  child: Container(
                    width: (MediaQuery.of(context).size.width) > 500 ? 500 * 0.92 : (MediaQuery.of(context).size.width) * 0.92,
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const SizedBox(height: 10, width: 7,),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //The Name of the postCreator
                                Expanded(
                                  child: Text(
                                    post.event,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(50, 50, 50, 1),
                                      fontFamily: 'Roboto',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                ), //The event description
                              ],
                            ),
                          ),


                        ]),
                  ),
                ),
              ),
            ),
          ), //The Post itself
          personal ? Positioned(
            top: 15,
            right: (MediaQuery.of(context).size.width) > 500 ? ((MediaQuery.of(context).size.width - (500 * 0.92 + 8 + 8)) / 2 + 20) : ((MediaQuery.of(context).size.width) * 0.08 - 8 - 8 + 15),
            child:  ToggleMenu(refreshPosts: refreshPosts, postId: post.id),
          ): const SizedBox(), //The Toggle Button

        ]));
  }
}



class ToggleMenu extends StatefulWidget {
  const ToggleMenu({
    Key? key,
    required this.refreshPosts,
    required this.postId
  }) : super(key: key);
  final String postId;
  final Function refreshPosts;
  @override
  State<ToggleMenu> createState() => _ToggleMenuState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _ToggleMenuState extends State<ToggleMenu> {
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SampleItem>(
      initialValue: selectedMenu,
      onSelected: (SampleItem item) {
        if(item ==SampleItem.itemOne){
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  DeleteDialog(refreshPosts: widget.refreshPosts, postId: widget.postId,)
          );
        }
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: const Icon(Icons.more_horiz, size: 26,),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          height: 0,
          value: SampleItem.itemOne,
          child: Text('Remove'),
        ),
      ],
    );
  }
}

class DeleteDialog extends StatelessWidget {
  DeleteDialog({
    required this.refreshPosts,
    required this.postId,
    Key? key,
  }) : super(key: key);
  final Function refreshPosts;
  final String postId;
  final PostController postController = Get.put(PostController());

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: (MediaQuery.of(context).size.width) > 500 ? 500 * 0.85 : (MediaQuery.of(context).size.width) * 0.85,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Delete Post',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text('Are you sure you want to delete this Post?',
                      style: TextStyle()
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: (){Navigator.pop(context);},
                          child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            postController.removePost(postId);
                            refreshPosts();
                            Navigator.pop(context);
                          },
                          child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ),
                      ]
                  )
                ]
            ) // border: Border
        )
    );
  }
}






