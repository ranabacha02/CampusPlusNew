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
  final int mobilePhoneNumber;
  List<String> rentals;
  List<String> chatsId;
  List<String> tutoringClasses;
  String description;
  String profilePictureURL;
  String userId;
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;

  MyUser({
    String? firstName,
    String? lastName,
    String? major,
    int? graduationYear,
    String? email,
    int? mobilePhoneNumber,
    List<String>? rentals,
    List<String>? chatsId,
    List<String>? tutoringClasses,
    DateTime? lastLogged,
    String? description,
    profilePictureURL,
    userId,
  })  : firstName = firstName ?? "",
        lastName = lastName ?? "",
        major = major ?? "",
        graduationYear = graduationYear ?? 9999,
        email = email ?? "",
        mobilePhoneNumber = mobilePhoneNumber ?? 9999999,
        rentals = rentals ?? [],
        chatsId = chatsId ?? [],
        tutoringClasses = tutoringClasses ?? [],
        lastLogged = lastLogged ?? DateTime.now(),
        description = description ?? "",
        profilePictureURL = profilePictureURL ?? "",
        userId = userId ?? "";

  MyUser.fromFirestore(Map<String, Object?> snapshot)
      : this(
    firstName: snapshot['firstName'] as String,
          lastName: snapshot['lastName'] as String,
          email: snapshot['email'] as String,
          major: snapshot['major'] as String,
          graduationYear: snapshot['graduationYear'] as int,
          mobilePhoneNumber: snapshot['mobilePhoneNumber'] as int,
          rentals: (snapshot['rentals'] as List).cast<String>(),
          chatsId: (snapshot['chatsId'] as List).cast<String>(),
          tutoringClasses: (snapshot['tutoringClasses'] as List).cast<String>(),
          description: snapshot['description'] as String,
          lastLogged: DateTime.now(),
          profilePictureURL: snapshot['profilePictureURL'],
          userId: snapshot['userId']
        );

  Map<String, Object?> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'major': major,
      'graduationYear': graduationYear,
      'mobilePhoneNumber': mobilePhoneNumber,
      'rentals': rentals,
      'chatsId': chatsId,
      'tutoringClasses': tutoringClasses,
      'lastLogged': lastLogged,
      'description': description
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
          'mobilePhoneNumber': mobilePhoneNumber,
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
    int? mobilePhoneNumber,
    File? photo,
    String? description,
  }) {
    users.doc(auth.currentUser!.uid).update({
      'firstName': firstName,
      'lastName': lastName,
      'major': major,
      'mobilePhoneNumber': mobilePhoneNumber,
      'graduationYear': graduationYear,
      'description': description,
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
    users.doc(auth.currentUser!.uid).update({'profilePictureURL': downloadURL});
    return downloadURL;
  }

  deleteProfilePicture() async {
    final storage = FirebaseStorage.instance;
    var storageRef =
        storage.ref().child("users/profiles/${auth.currentUser!.uid}");
    await storageRef.delete();
    auth.currentUser!.updatePhotoURL(null);
    users.doc(auth.currentUser!.uid).update({'profilePictureURL': null});
  }
}
