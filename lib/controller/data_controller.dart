import 'dart:io';

import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:realm/realm.dart';

import '../model/clean_user_model.dart';
import '../localStorage/realm/data_models/realmUser.dart';
import '../localStorage/realm/realm_firestore_syncing.dart';
import '../views/edit_account_screen.dart';
import '../widgets/nav_bar.dart';

class DataController extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  Future getUserInfo() async {
    DocumentSnapshot snapshot =
        await await users.doc(auth.currentUser!.uid).get();
    MyUser user = MyUser.fromFirestore(snapshot.data() as Map<String, dynamic>);
    users.doc(auth.currentUser!.uid).update({
      'profilePictureURL': auth!.currentUser!.photoURL,
    });

    final config = Configuration.local([RealmUser.schema]);
    final realm = Realm(config);
    final myUser = toRealmUser(snapshot.data() as Map<String, dynamic>);
    realm.write(() {
      realm.add(myUser, update: true);
    });
    storedData = user;
    return storedData;
  }

  late MyUser storedData;

  addUser(String? email, String? firstName, String? gender, String? department, String? lastName,
      int? graduationYear, String? major, int? mobilePhoneNumber) {
    MyUser user = MyUser(
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      department: department,
      email: email,
      graduationYear: graduationYear,
      major: major,
      mobilePhoneNumber: mobilePhoneNumber,
      description: "",
    );
    user.addUser();
  }

  CleanUser cleanUserInfo(MyUser user){
    CleanUser cleanUser = CleanUser.fromMyUser(user);
    return cleanUser;
  }

  updateProfile(
      {String? firstName,
      String? lastName,
      String? major,
      int? graduationYear,
      int? mobilePhoneNumber,
      String? description,
      required BuildContext context,
      File? photo,
      required bool delete}) async {

    MyUser userInfo = getLocalData();
    MyUser user = new MyUser();
    user.updateUser(
        firstName: firstName,
        lastName: lastName,
        major: major,
        graduationYear: graduationYear,
        mobilePhoneNumber: mobilePhoneNumber,
        description: description);

    updateLocalData(
        firstName: firstName,
        lastName: lastName,
        major: major,
        graduationYear: graduationYear,
        mobilePhoneNumber: mobilePhoneNumber,
        description: description);

    if (delete) {
      await deleteProfilePicture();
    }
    print("delete = " + delete.toString());
    print(photo);
    if (!delete && photo != null) {
      print("will upload the picture");
      await uploadProfilePic(photo)
          .whenComplete(() => print("image uploaded"))
          .catchError(() => print("error uploading image"));
    }
    //dataController.getUserInfo();
    Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.topToBottomPop,
          child: NavBarView(index: 4),
          childCurrent: EditAccountScreen(
            userInfo: userInfo,
            delete: false,
            displayImage: photo == null ? null : Image.file(photo),
          ),
        ));
  }

  MyUser getLocalData() {
    final config = Configuration.local([RealmUser.schema]);
    final realm = Realm(config);
    var result = realm.find<RealmUser>(auth.currentUser!.uid);
    if (result == null) {
      getUserInfo();
    }
    return MyUser.fromRealmUser(result!);
  }

  updateLocalData({
    String? firstName,
    String? lastName,
    String? major,
    int? graduationYear,
    int? mobilePhoneNumber,
    String? description,
  }) {
    storedData.firstName = firstName?? storedData.firstName;
    storedData.lastName = lastName ?? storedData.lastName;
    storedData.major = major ?? storedData.major;
    storedData.graduationYear = graduationYear ?? storedData.graduationYear;
    storedData.mobilePhoneNumber =
        mobilePhoneNumber ?? storedData.mobilePhoneNumber;
    storedData.description = description ?? storedData.description;
  }

  clearLocalData() {
    storedData = MyUser();
  }

  UploadTask uploadProfilePic(File image) {
    MyUser user = MyUser();
    return user.uploadProfilePic(image);
  }

  deleteProfilePicture() async {
    MyUser user = MyUser();
    user.deleteProfilePicture();
  }

  Future<Stream<RealmObjectChanges<RealmUser>>?>
      getLiveRealmUserObject() async {
    final config = Configuration.local([RealmUser.schema]);
    final realm = await Realm.open(config);
    return realm.find<RealmUser>(auth.currentUser!.uid)?.changes;
  }
}