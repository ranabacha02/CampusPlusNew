import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DataController extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instanceFor(bucket: "gs://profile-pictures");

  Future getUserInfo() async {
    var data =
    await users.where("userId", isEqualTo: auth.currentUser!.uid).get();
    var data2 = data.docs.first.data() as Map<String, dynamic>;
    //print(data2);
    storedData = data2;
    // print("set data");
    return data2;
  }
  late Map<String, dynamic> storedData = {};

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

  Map getLocalData() {
    return storedData;
  }

  clearLocalData() {
    storedData.clear();
  }

  getProfilePic() {
    final storageRef = storage.ref();
    final profilePicRef =
        storageRef.child("pp_" + auth.currentUser!.uid + ".jpg");
  }
}