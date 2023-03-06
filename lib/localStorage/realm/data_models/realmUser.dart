import 'package:realm/realm.dart';

part 'realmUser.g.dart';

@RealmModel()
class _RealmUser {
  @PrimaryKey()
  late String userId;
  late String firstName;
  late String lastName;
  late String gender;
  late String department;
  late String major;
  late String email;
  late int graduationYear;
  late DateTime lastLogged;
  late int mobilePhoneNumber;
  late List<String> rentals;
  late List<String> chatsId;
  late List<String> tutoringClasses;
  late String description;
  late String profilePictureURL;
}
