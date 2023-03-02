import 'package:realm/realm.dart';

part 'chat.g.dart';

@RealmModel()
class _RealmChat {
  @PrimaryKey()
  late String chatId;

  late String chatName;
  late bool isGroup;
  late List<String> members;
  late String recentMessage;
  late String recentSender;
  late DateTime recentMessageTime;
  late String chatIcon;
  late String? admin;
  late List<_RealmMessage> messages;
}

@RealmModel()
class _RealmMessage {
  late String message;
  late String sender;
  late DateTime time;
  late String type;
  late String? imageUrl;
}
