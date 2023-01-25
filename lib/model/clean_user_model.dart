import 'package:campus_plus/model/user_model.dart';


class CleanUser{
  String firstName;
  String lastName;
  String major;
  int graduationYear;
  String? profilePictureURL;
  String userId;

  CleanUser.fromMyUser(MyUser user):
      firstName = user.firstName,
      lastName = user.lastName,
      major = user.major,
      graduationYear = user.graduationYear,
      profilePictureURL = user.profilePictureURL,
      userId = user.userId;

}