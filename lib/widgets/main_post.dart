import 'package:campus_plus/model/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/post_controller.dart';
import 'package:flip_card/flip_card.dart';


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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Container(
        width: double.infinity,
        height: 560.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  InkWell(
                    child:FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                    front: Container(
                      margin: EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: 400.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 5),
                            blurRadius: 8.0,
                          ),
                        ],
                        image: DecorationImage(
                          image: AssetImage("posts[index].imageUrl"),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ), back: Container(
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
                    ),
                  )
                  ),
                  ListTile(
                    leading: Container(
                      width: 50.0,
                      height: 50.0,
                    ),
                    trailing: IconButton(
                      icon:  ToggleMenu(refreshPosts: refreshPosts, postId: post.id),
                      color: Colors.black,
                      onPressed: () => (''),
                    ),

                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );;
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






