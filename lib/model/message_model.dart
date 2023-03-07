import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String sender;
  final DateTime time;

  Message({
    required this.message,
    required this.sender,
    required this.time,
  });

  Message.fromJson(Map<String, Object?> json)
      : this(
            message: json['message'] as String,
            sender: json['sender'] as String,
            time: json['time'] as DateTime);

  Map<String, dynamic> toJson() {
    return {"message": message, "sender": sender, "time": time};
  }
}
