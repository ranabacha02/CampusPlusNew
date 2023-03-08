import 'dart:core';
import 'dart:io';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

final CollectionReference postCollection = FirebaseFirestore.instance.collection("Posts");
DataController dataController = Get.put(DataController());



class MyPost {
  String id = "";
  String createdBy;
  String event;
  DateTime dateCreated;
  List<String> tags;
  List<CleanUser> users;
  List<String> userIds;
  String imageUrl;
  FirebaseAuth auth = FirebaseAuth.instance;
  String postId;

  MyPost({
    String? createdBy,
    String? event,
    DateTime? dateCreated,
    List<String>? tags,
    List<CleanUser>? users,
    List<String>? userIds,
    String? imageUrl,
    String? postId
  }): createdBy= createdBy ?? "",
        event= event ?? "",
        postId = postId ?? "",
        dateCreated= dateCreated ?? DateTime.now(),
        tags = tags ?? [],
        users = users ?? [],
        userIds = userIds ?? [],
        imageUrl = imageUrl ?? ""


  ;

  MyPost.fromFirestore(Map<String, dynamic> snapshot):
        id = snapshot['id'],
        createdBy = snapshot['createdBy'],
        event = snapshot['event'],
        dateCreated = snapshot['dateCreated'].toDate(),
        tags = List<String>.from(snapshot['tags']),
        users = snapshot['users'].map<CleanUser>((user)=>CleanUser.fromFirestore(user)).toList(),
        userIds =  List<String>.from(snapshot['userIds']),
        imageUrl = snapshot['imageUrl'],
        postId = snapshot['postId'];

  Map<String, dynamic> toFirestore(){
    return {
      'createdBy': createdBy,
      'event' : event,
      'dateCreated' : dateCreated,
      'tags' : tags,
      'users' : users.map<Map<String, dynamic>>((user)=>user.toFirestore()).toList(),
      'userIds' : userIds,
      'imageUrl': imageUrl,
      'postId' : postId
    };
  }



  Future<bool> createPost() async {
    final DocumentReference newPostRef = FirebaseFirestore.instance.collection("Posts").doc();
    final postData = {
      'id' : newPostRef.id,
      'createdBy': createdBy,
      'event' : event,
      'dateCreated' : dateCreated,
      'tags' : tags,
      'users' : users.map<Map<String, dynamic>>((user)=>user.toFirestore()).toList(),
      'userIds' : userIds,
      'imageUrl': imageUrl,
      'postId' : postId
    };
    final complete = newPostRef.set(postData).then((doc)=> true, onError: (r)=> false);
    return complete;
  }
  static Future<bool> joinPost(String postId) async {
    final MyUser user = dataController.getLocalData();
    final CleanUser cleanUser = CleanUser.fromMyUser(user);
    final complete = postCollection.doc(postId).update({"users": FieldValue.arrayUnion([cleanUser.toFirestore()]), "userIds": FieldValue.arrayUnion([cleanUser.userId])})
        .then((doc)=> true, onError: (e)=>false);
    return complete;
  }
  static Future<bool> leavePost(String postId) async {
    final DocumentSnapshot snapshot = await postCollection.doc(postId).get();
    final MyPost post = MyPost.fromFirestore(snapshot.data() as Map<String, dynamic>);
    final List<CleanUser> postUsers = post.users;
    final MyUser user = dataController.getLocalData();
    final CleanUser target = postUsers.firstWhere((usr) => usr.userId==user.userId);
    final complete = postCollection.doc(postId).update({"users": FieldValue.arrayRemove([target.toFirestore()]),"userIds": FieldValue.arrayRemove([user.userId])})
        .then((doc)=> true, onError: (e)=>false);
    return complete;
  }

  static Future<bool> removePost(String postId) async {
    final complete = postCollection.doc(postId).delete().then((doc)=> true, onError: (e)=> false);
    return complete;
  }

  static Stream<QuerySnapshot<Object?>> getStreamOfPosts(){
    return postCollection.snapshots();
  }

  static Future<List<MyPost>> getAllPosts() async {
    final snapshots = await postCollection.get();
    List<MyPost> posts = snapshots.docs.map<MyPost>((doc) => MyPost.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return posts;
  }

  static Future<List<MyPost>> getAllVisiblePosts() async{
    String gender = dataController.getLocalData().gender;
    String department = dataController.getLocalData().department;
    final snapshots = await postCollection.get();
    List<MyPost> posts = snapshots.docs.map<MyPost>((doc) => MyPost.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return posts;
  }

  static Future<List<MyPost>> getTaggedPosts(String tag) async{
    String gender = dataController.getLocalData().gender;
    String department = dataController.getLocalData().department;
    final snapshots = await postCollection.where("tags", arrayContains: tag).get();
    List<MyPost> posts = snapshots.docs.map<MyPost>((doc) => MyPost.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return posts;
  }

  static Future getMyCreatedPosts() async{
    final MyUser user = dataController.getLocalData();
    final snapshots = await postCollection.where("createdBy", isEqualTo: user.userId).get();
    List<MyPost> posts = snapshots.docs.map<MyPost>((doc) => MyPost.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return posts;
  }

  static Future getMyJoinedPosts() async{
    final MyUser user = dataController.getLocalData();
    final snapshots = await postCollection.where("userIds", arrayContains: user.userId).get();
    List<MyPost> posts = snapshots.docs.map<MyPost>((doc) => MyPost.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    return posts;
  }

  Future<String> uploadPostPic(XFile image) async {
    CollectionReference postCollection =
    FirebaseFirestore.instance.collection('posts');
    final storage = FirebaseStorage.instance;

    // Generate a new timestamp to use in the storage path
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    DocumentReference documentReference =
    await postCollection.doc(postId).collection("posts").add({
      "imageUrl": image.path,
    });
    // Update the storage path to include the timestamp
    var storageRef = storage
        .ref()
        .child("users/posts/${postId}/${documentReference.id}");
    var uploadTask = await storageRef.putFile(File(image.path));
    var downloadURL = await uploadTask.ref.getDownloadURL();

    documentReference.update({
      "imageUrl": downloadURL,
    });


    return downloadURL;
  }

  deletePostPicture() async {
    final storage = FirebaseStorage.instance;
    final MyUser user = dataController.getLocalData();
    var storageRef =
    storage.ref().child("users/posts/${auth.currentUser!.uid}");
    await storageRef.delete();
    auth.currentUser!.updatePhotoURL(null);
    postCollection.doc(auth.currentUser!.uid).update({'imageUrl': null});

  }


}
