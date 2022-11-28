import 'dart:collection';

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
            message: json['chatId'] as String,
            sender: json['chatName'] as String,
            time: json['isGroup'] as DateTime);
}
