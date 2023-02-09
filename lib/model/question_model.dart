import 'package:campus_plus/model/answer_model.dart';
import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyQuestion {
  String question;
  DateTime timePosted;
  CleanUser user;
  List<MyAnswer> answers;
  String questionId;

  MyQuestion(
      {required this.question,
      required this.timePosted,
      required this.user,
      required this.answers,
      String? questionId})
      : questionId = questionId ?? "";

  MyQuestion.fromFirestore(Map<String, dynamic> snapshot)
      : question = snapshot['question'],
        timePosted = snapshot['timePosted'].toDate(),
        user = CleanUser.fromFirestore(snapshot['user']),
        answers = snapshot['answers']
            .map<MyAnswer>((answer) => MyAnswer.fromFirestore(answer))
            .toList(),
        questionId = snapshot['questionId'];

  Future<MyQuestion> postQuestion(
    String chatId,
  ) async {
    CollectionReference chatCollection =
        FirebaseFirestore.instance.collection('chats');

    DocumentReference documentReference =
        await chatCollection.doc(chatId).collection("questions").add({
      "question": question,
      "timePosted": timePosted,
      "user": user.toFirestore(),
      "answers": List.empty(),
    });

    questionId = documentReference.id;

    documentReference.update({
      "questionId": questionId,
    });

    return this;
  }
}
