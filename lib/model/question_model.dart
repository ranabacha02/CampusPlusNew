import 'package:campus_plus/model/answer_model.dart';
import 'package:campus_plus/model/user_model.dart';

class MyQuestion {
  String question;
  DateTime timePosted;
  MyUser user;
  List<MyAnswer> answers;

  MyQuestion(
      {required this.question,
      required this.timePosted,
      required this.user,
      required this.answers});

  MyQuestion.fromFirestore(Map<String, dynamic> snapshot)
      : question = snapshot['question'],
        timePosted = snapshot['timePosted'].toDate(),
        user = MyUser.fromFirestore(snapshot['user']),
        answers = List<MyAnswer>.empty(growable: true);
}
