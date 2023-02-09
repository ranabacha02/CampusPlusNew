import 'package:campus_plus/model/answer_model.dart';
import 'package:campus_plus/model/question_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../model/clean_user_model.dart';

class ForumController extends GetxController {
  postQuestion(String chatId, CleanUser user, String question) {
    MyQuestion myQuestion = MyQuestion(
        question: question,
        timePosted: DateTime.now(),
        user: user,
        answers: List<MyAnswer>.empty());
    return myQuestion.postQuestion(chatId);
  }

  postAnswer(String chatId, CleanUser user, String questionId, String answer) {
    MyAnswer myAnswer =
        MyAnswer(answer: answer, timePosted: DateTime.now(), user: user);

    return myAnswer.postAnswer(chatId, questionId);
  }

  Future<List<MyQuestion>> getQuestions(String chatId) async {
    CollectionReference questionCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection("questions");

    QuerySnapshot querySnapshot = await questionCollection.get();
    List<MyQuestion> questions = querySnapshot.docs
        .map((question) =>
            MyQuestion.fromFirestore(question.data() as Map<String, dynamic>))
        .toList();
    questions.sort((a, b) => a.timePosted.compareTo(b.timePosted));
    return questions;
  }
}
