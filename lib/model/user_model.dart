import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class MyUser {
  final String firstName;
  final String lastName;
  final String major;
  final String email;
  final int graduationYear;
  DateTime lastLogged;
  final int mobileNumber;
  List<String> rentals;
  List<String> chats;
  List<String> tutoringClasses;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;

  MyUser({
    String? firstName,
    String? lastName,
    String? major,
    int? graduationYear,
    String? email,
    int? mobileNumber,
    List<String>? rentals,
    List<String>? chats,
    List<String>? tutoringClasses,
    DateTime? lastLogged,
  })  : firstName = firstName ?? "",
        lastName = lastName ?? "",
        major = major ?? "",
        graduationYear = graduationYear ?? 9999,
        email = email ?? "",
        mobileNumber = mobileNumber ?? 9999999,
        rentals = rentals ?? [],
        chats = chats ?? [],
        tutoringClasses = tutoringClasses ?? [],
        lastLogged = lastLogged ?? DateTime.now();

  MyUser.fromJson(Map<String, Object?> json)
      : this(
          firstName: json['firstName'] as String,
          lastName: json['lastName'] as String,
          email: json['email'] as String,
          major: json['major'] as String,
          graduationYear: json['graduationYear'] as int,
          mobileNumber: json['mobilePhoneNumber'] as int,
          rentals: (json['rentals'] as List).cast<String>(),
          chats: (json['chats'] as List).cast<String>(),
          tutoringClasses: (json['tutoringClasses'] as List).cast<String>(),
          lastLogged: DateTime.now(),
        );

  Map<String, Object?> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'major': major,
      'graduationYear': graduationYear,
      'mobilePhoneNumber': mobileNumber,
      'rentals': rentals,
      'chats': chats,
      'tutoringClasses': tutoringClasses,
      'lastLogged': lastLogged
    };
  }

  addUser() {
    users
        .doc(auth.currentUser!.uid)
        .set({
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'major': major,
          'mobilePhoneNumber': mobileNumber,
          'graduationYear': graduationYear,
          'userId': auth.currentUser!.uid,
          'chatsId': [],
        })
        .then((value) => print("user added"))
        .catchError(
            (error) => print("Failed to add user: " + error.toString()));
  }

  updateUser({
    String? firstName,
    String? lastName,
    String? major,
    int? graduationYear,
    int? mobileNumber,
    File? photo,
  }) {
    users.doc(auth.currentUser!.uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'major': major,
      'mobilePhoneNumber': mobileNumber,
      'graduationYear': graduationYear,
    }).then((value) async {
      print("user updated");
    });
  }

  Future<String> uploadProfilePic(File image) async {
    final storage = FirebaseStorage.instance;
    var storageRef =
        storage.ref().child("users/profiles/${auth.currentUser!.uid}");
    var uploadTask = await storageRef.putFile(image);
    var downloadURL = await uploadTask.ref.getDownloadURL();
    print("image updated!");
    auth.currentUser!.updatePhotoURL(downloadURL);
    return downloadURL;
  }

  deleteProfilePicture() async {
    final storage = FirebaseStorage.instance;
    var storageRef =
        storage.ref().child("users/profiles/${auth.currentUser!.uid}");
    await storageRef.delete();
    auth.currentUser!.updatePhotoURL(null);
  }
}
