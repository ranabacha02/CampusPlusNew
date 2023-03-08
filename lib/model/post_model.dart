import 'dart:core';
import 'dart:io';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

final CollectionReference postCollection =
    FirebaseFirestore.instance.collection("Posts");
DataController dataController = Get.put(DataController());

class MyPost {
  String id = "";
  String createdBy;
  String caption;
  DateTime dateCreated;
  List<String> tags;
  List<String> likes;
  Map<String, String> comments;
  File? image;
  String? imageUrl;
  FirebaseAuth auth = FirebaseAuth.instance;
  String postId;

  MyPost({
    required String createdBy,
    required File this.image,
    String? caption,
    DateTime? dateCreated,
    List<String>? tags,
    List<String>? likes,
    Map<String, String>? comments,
    String? imageUrl,
    String? postId,
  })  : createdBy = createdBy ?? "",
        caption = caption ?? "",
        postId = postId ?? "",
        dateCreated = dateCreated ?? DateTime.now(),
        likes = likes ?? [],
        comments = comments ?? {},
        tags = tags ?? [],
        imageUrl = imageUrl ?? "";

  MyPost.fromFirestore(Map<String, dynamic> snapshot)
      : id = snapshot['postId'],
        createdBy = snapshot['createdBy'],
        dateCreated = snapshot['dateCreated'].toDate(),
        caption = snapshot['caption'],
        tags = List<String>.from(snapshot['tags']),
        likes = List<String>.from(snapshot['likes']),
        comments = Map<String, String>.from(snapshot['comments']),
        imageUrl = snapshot['imageUrl'],
        postId = snapshot['postId'];

  Map<String, dynamic> toFirestore() {
    return {
      'createdBy': createdBy,
      'caption': caption,
      'dateCreated': dateCreated,
      'tags': tags,
      'likes': likes,
      'comments': comments,
      'imageUrl': imageUrl,
      'postId': postId
    };
  }

  Future<bool> createPost() async {
    var complete = false;
    var doc_id = FirebaseFirestore.instance.collection("Posts").doc().id;
    print("doc id " + doc_id);
    if (image != null) {
      String upload_result = await uploadPostPic(image!, doc_id);
      if (upload_result == "Error while uploading") {
        return false;
      } else {
        imageUrl = upload_result;
        postId = doc_id;
        print("imageURl" + imageUrl.toString());
        final post_data = toFirestore();
        print("post_data " + post_data.toString());
        complete = await FirebaseFirestore.instance
            .collection("Posts")
            .doc(doc_id)
            .set(post_data)
            .then((doc) => true, onError: (r) => false);
      }
    }
    return complete;
  }

  static Future<bool> likePost(String postId) async {
    final MyUser user = dataController.getLocalData();
    final CleanUser cleanUser = CleanUser.fromMyUser(user);
    final complete = postCollection.doc(postId).update({
      "likes": FieldValue.arrayUnion([cleanUser.userId]),
    }).then((doc) => true, onError: (e) => false);
    return complete;
  }

  static Future<bool> unlikePost(String postId) async {
    final DocumentSnapshot snapshot = await postCollection.doc(postId).get();
    final MyPost post =
        MyPost.fromFirestore(snapshot.data() as Map<String, dynamic>);
    final List<String> postLikes = post.likes;
    final MyUser user = dataController.getLocalData();
    final String target = postLikes.firstWhere((like) => like == user.userId);
    final complete = postCollection.doc(postId).update({
      "users": FieldValue.arrayRemove([target])
    }).then((doc) => true, onError: (e) => false);
    return complete;
  }

  static Future<bool> removePost(String postId) async {
    print(postId);
    final postReference = postCollection.doc(postId);
    final complete =
        await postReference.delete().then((doc) => true, onError: (e) => false);
    print(complete);
    if (complete) {
      return await deletePostPic(postId);
    } else {
      return false;
    }
  }

  static Stream<QuerySnapshot<Object?>> getStreamOfPosts() {
    return postCollection.snapshots();
  }

  static Future<List<MyPost>> getAllPosts() async {
    final snapshots = await postCollection.get();
    List<MyPost> posts = snapshots.docs
        .map<MyPost>(
            (doc) => MyPost.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
    return posts;
  }

  static Future<List<MyPost>> getAllVisiblePosts() async {
    String gender = dataController.getLocalData().gender;
    String department = dataController.getLocalData().department;
    final snapshots = await postCollection.get();
    List<MyPost> posts = snapshots.docs
        .map<MyPost>(
            (doc) => MyPost.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
    return posts;
  }

  static Future<List<MyPost>> getTaggedPosts(String tag) async {
    String gender = dataController.getLocalData().gender;
    String department = dataController.getLocalData().department;
    final snapshots =
        await postCollection.where("tags", arrayContains: tag).get();
    List<MyPost> posts = snapshots.docs
        .map<MyPost>(
            (doc) => MyPost.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
    return posts;
  }

  static Future getMyCreatedPosts() async {
    final MyUser user = dataController.getLocalData();
    final snapshots =
        await postCollection.where("createdBy", isEqualTo: user.userId).get();
    List<MyPost> posts = snapshots.docs
        .map<MyPost>(
            (doc) => MyPost.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
    return posts;
  }

  static Future getMyJoinedPosts() async {
    final MyUser user = dataController.getLocalData();
    final snapshots =
        await postCollection.where("userIds", arrayContains: user.userId).get();
    List<MyPost> posts = snapshots.docs
        .map<MyPost>(
            (doc) => MyPost.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
    return posts;
  }

  static Future<String> uploadPostPic(File image, String doc_id) async {
    CollectionReference postCollection =
        FirebaseFirestore.instance.collection('posts');
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child("posts/$doc_id");
    var uploadTask = await storageRef.putFile(image).catchError((err) {
      return "Error while uploading";
    });
    var downloadURL = await uploadTask.ref.getDownloadURL();
    print("downloadURL");
    return downloadURL;
  }

  static Future<bool> deletePostPic(String doc_id) async {
    final storage = FirebaseStorage.instance;
    var storageRef = storage.ref().child("posts/${doc_id}");
    final bool status = await storageRef
        .delete()
        .then((value) => true)
        .onError((error, stackTrace) => false);
    return status;
  }
}
