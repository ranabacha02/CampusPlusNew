import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DataController extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>?> getUserInfo() async {
    Map<String, dynamic> data;
    await users
        .where("userId", isEqualTo: auth.currentUser!.uid)
        .get()
        .then((value) {
      data = value.docs.first.data() as Map<String, dynamic>;
      print(data["firstName"]);
      return data;
    }).catchError((err) {
      print("error");
    });
    print("I am here");
    //return data;
  }

  addUser(String? email, String? firstName, String? lastName,
      int? graduationYear, String? major, int? mobileNumber) {
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
        })
        .then((value) => print("user added"))
        .catchError(
            (error) => print("Failed to add user: " + error.toString()));
  }
}
