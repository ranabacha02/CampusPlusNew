import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DataController extends GetxController {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getUserInfo() async {
    var data =
        await users.where("userId", isEqualTo: auth.currentUser!.uid).get();
    var data2 = data.docs.first.data() as Map<String, dynamic>;
    //print(data2);
    storedData = data2;
    return data2;
  }
  late var storedData = {};

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
  getLocalData(){
    return storedData;
  }

}
