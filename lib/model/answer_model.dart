import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyAnswer {
  CleanUser user;
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
        user = CleanUser.fromFirestore(snapshot['user']);

  Map<String, dynamic> toFirestore() {
    return {
      "answer": answer,
      "user": user.toFirestore(),
      "timePosted": timePosted,
    };
  }

  MyAnswer postAnswer(String chatId, String questionId) {
    CollectionReference questionCollection = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection("questions");

    questionCollection.doc(questionId).update({
      "answers": FieldValue.arrayUnion([this.toFirestore()]),
    });

    return this;
  }
}
