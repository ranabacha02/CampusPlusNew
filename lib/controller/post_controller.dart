import 'dart:io';

import 'package:campus_plus/model/clean_user_model.dart';
import 'package:image_picker/image_picker.dart';
import '../model/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'data_controller.dart';

class PostController {
  FirebaseAuth auth = FirebaseAuth.instance;
  DataController dataController = Get.put(DataController());

  Future<bool> createPost(
      {required String caption,
      required DateTime dateCreated,
      required List<String> tags,
      required File image}) async {
    MyPost post = MyPost(
      createdBy: auth.currentUser!.uid,
      image: image,
      caption: caption,
      dateCreated: dateCreated,
      tags: tags,
    );

    return post.createPost();
  }

  Future<bool> likePost(String postId) async {
    return MyPost.likePost(postId);
  }

  Future<bool> unlikePost(String postId) async {
    return MyPost.unlikePost(postId);
  }

  Future<bool> removePost(String postId) async {
    return MyPost.removePost(postId);
  }

  Future getStreamOfPosts() async {
    return MyPost.getStreamOfPosts();
  }

  Future<List<MyPost>> getAllPosts() async {
    return MyPost.getAllPosts();
  }

  Future<List<MyPost>> getAllVisiblePosts() async{
    return MyPost.getAllVisiblePosts();
  }

  Future<List<MyPost>> getTaggedPosts(List<String> tags) async {
    List<MyPost> taggedPosts=[];
    for(String t in tags){
      taggedPosts.addAll(await MyPost.getTaggedPosts(t));
    }
    return taggedPosts;
  }

  Future<List<MyPost>> filterPosts(List<MyPost> posts, List<String> tags) async{
    List<MyPost> taggedPosts =[];
    if(tags.isNotEmpty){
      for(String tag in tags){
        taggedPosts.addAll(posts.where((post)=> post.tags.contains(tag)).toList());
      }
      return taggedPosts;
    }
    return posts;
  }

  Future<List<MyPost>> getMyPosts() async{
    final myCreatedPosts = await MyPost.getMyCreatedPosts();
    final myJoinedPosts = await MyPost.getMyJoinedPosts();
    List<MyPost> myPosts = myCreatedPosts + myJoinedPosts;
    return myPosts;
  }


}



