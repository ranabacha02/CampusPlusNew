import 'package:campus_plus/model/user_model.dart';


class CleanUser{
  String firstName;
  String lastName;
  String major;
  int graduationYear;
  String? profilePictureURL;
  String userId;
  String email;

  CleanUser.fromMyUser(MyUser user)
      : firstName = user.firstName,
        lastName = user.lastName,
        major = user.major,
        graduationYear = user.graduationYear,
        profilePictureURL = user.profilePictureURL,
        userId = user.userId,
        email = user.email;

  CleanUser.fromFirestore(Map<String, dynamic> snapshot)
      : firstName = snapshot['firstName'],
        lastName = snapshot['lastName'],
        major = snapshot['major'],
        graduationYear = snapshot['graduationYear'],
        profilePictureURL = snapshot['profilePictureURL'],
        userId = snapshot['userId'],
        email = snapshot['email'];

  Map<String, dynamic> toFirestore() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'major': major,
      'graduationYear': graduationYear,
      'profilePictureURL': profilePictureURL,
      'userId': userId,
      'email': email,
    };
  }

}
