class User {
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

  User({
    required this.firstName,
    required this.lastName,
    required this.major,
    required this.graduationYear,
    required this.email,
    required this.mobileNumber,
    List<String>? rentals,
    List<String>? chats,
    List<String>? tutoringClasses,
    DateTime? lastLogged,
  })  : rentals = rentals ?? [],
        chats = chats ?? [],
        tutoringClasses = tutoringClasses ?? [],
        lastLogged = lastLogged ?? DateTime.now();

  User.fromJson(Map<String, Object?> json)
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
}
