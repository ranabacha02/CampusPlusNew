import 'package:campus_plus/model/user_model.dart';

class MyAnswer {
  MyUser user;
  String answer;
  DateTime timePosted;

  MyAnswer({
    required this.answer,
    required this.timePosted,
    required this.user,
  });

  MyAnswer.fromFirestore(Map<String, dynamic> snapshot)
      : answer = snapshot['answer'],
        timePosted = snapshot['timePosted'].toDate(),
        user = MyUser.fromFirestore(snapshot['user']);
}
