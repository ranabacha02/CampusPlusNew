// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RealmChat extends _RealmChat
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmChat(
    String chatId,
    String chatName,
    bool isGroup,
    String recentMessage,
    String recentSender,
    DateTime recentMessageTime,
    String chatIcon, {
    String? admin,
    Iterable<String> members = const [],
    Iterable<RealmMessage> messages = const [],
  }) {
    RealmObjectBase.set(this, 'chatId', chatId);
    RealmObjectBase.set(this, 'chatName', chatName);
    RealmObjectBase.set(this, 'isGroup', isGroup);
    RealmObjectBase.set(this, 'recentMessage', recentMessage);
    RealmObjectBase.set(this, 'recentSender', recentSender);
    RealmObjectBase.set(this, 'recentMessageTime', recentMessageTime);
    RealmObjectBase.set(this, 'chatIcon', chatIcon);
    RealmObjectBase.set(this, 'admin', admin);
    RealmObjectBase.set<RealmList<String>>(
        this, 'members', RealmList<String>(members));
    RealmObjectBase.set<RealmList<RealmMessage>>(
        this, 'messages', RealmList<RealmMessage>(messages));
  }

  RealmChat._();

  @override
  String get chatId => RealmObjectBase.get<String>(this, 'chatId') as String;

  @override
  set chatId(String value) => RealmObjectBase.set(this, 'chatId', value);

  @override
  String get chatName =>
      RealmObjectBase.get<String>(this, 'chatName') as String;

  @override
  set chatName(String value) => RealmObjectBase.set(this, 'chatName', value);

  @override
  bool get isGroup => RealmObjectBase.get<bool>(this, 'isGroup') as bool;

  @override
  set isGroup(bool value) => RealmObjectBase.set(this, 'isGroup', value);

  @override
  RealmList<String> get members =>
      RealmObjectBase.get<String>(this, 'members') as RealmList<String>;

  @override
  set members(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get recentMessage =>
      RealmObjectBase.get<String>(this, 'recentMessage') as String;

  @override
  set recentMessage(String value) =>
      RealmObjectBase.set(this, 'recentMessage', value);

  @override
  String get recentSender =>
      RealmObjectBase.get<String>(this, 'recentSender') as String;

  @override
  set recentSender(String value) =>
      RealmObjectBase.set(this, 'recentSender', value);

  @override
  DateTime get recentMessageTime =>
      RealmObjectBase.get<DateTime>(this, 'recentMessageTime') as DateTime;

  @override
  set recentMessageTime(DateTime value) =>
      RealmObjectBase.set(this, 'recentMessageTime', value);

  @override
  String get chatIcon =>
      RealmObjectBase.get<String>(this, 'chatIcon') as String;

  @override
  set chatIcon(String value) => RealmObjectBase.set(this, 'chatIcon', value);

  @override
  String? get admin => RealmObjectBase.get<String>(this, 'admin') as String?;

  @override
  set admin(String? value) => RealmObjectBase.set(this, 'admin', value);

  @override
  RealmList<RealmMessage> get messages =>
      RealmObjectBase.get<RealmMessage>(this, 'messages')
          as RealmList<RealmMessage>;

  @override
  set messages(covariant RealmList<RealmMessage> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<RealmChat>> get changes =>
      RealmObjectBase.getChanges<RealmChat>(this);

  @override
  RealmChat freeze() => RealmObjectBase.freezeObject<RealmChat>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmChat._);
    return const SchemaObject(ObjectType.realmObject, RealmChat, 'RealmChat', [
      SchemaProperty('chatId', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('chatName', RealmPropertyType.string),
      SchemaProperty('isGroup', RealmPropertyType.bool),
      SchemaProperty('members', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('recentMessage', RealmPropertyType.string),
      SchemaProperty('recentSender', RealmPropertyType.string),
      SchemaProperty('recentMessageTime', RealmPropertyType.timestamp),
      SchemaProperty('chatIcon', RealmPropertyType.string),
      SchemaProperty('admin', RealmPropertyType.string, optional: true),
      SchemaProperty('messages', RealmPropertyType.object,
          linkTarget: 'RealmMessage', collectionType: RealmCollectionType.list),
    ]);
  }
}

class RealmMessage extends _RealmMessage
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmMessage(
    String message,
    String sender,
    DateTime time,
    String type, {
    String? imageUrl,
  }) {
    RealmObjectBase.set(this, 'message', message);
    RealmObjectBase.set(this, 'sender', sender);
    RealmObjectBase.set(this, 'time', time);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'imageUrl', imageUrl);
  }

  RealmMessage._();

  @override
  String get message => RealmObjectBase.get<String>(this, 'message') as String;

  @override
  set message(String value) => RealmObjectBase.set(this, 'message', value);

  @override
  String get sender => RealmObjectBase.get<String>(this, 'sender') as String;

  @override
  set sender(String value) => RealmObjectBase.set(this, 'sender', value);

  @override
  DateTime get time => RealmObjectBase.get<DateTime>(this, 'time') as DateTime;

  @override
  set time(DateTime value) => RealmObjectBase.set(this, 'time', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;

  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get imageUrl =>
      RealmObjectBase.get<String>(this, 'imageUrl') as String?;

  @override
  set imageUrl(String? value) => RealmObjectBase.set(this, 'imageUrl', value);

  @override
  Stream<RealmObjectChanges<RealmMessage>> get changes =>
      RealmObjectBase.getChanges<RealmMessage>(this);

  @override
  RealmMessage freeze() => RealmObjectBase.freezeObject<RealmMessage>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmMessage._);
    return const SchemaObject(
        ObjectType.realmObject, RealmMessage, 'RealmMessage', [
      SchemaProperty('message', RealmPropertyType.string),
      SchemaProperty('sender', RealmPropertyType.string),
      SchemaProperty('time', RealmPropertyType.timestamp),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('imageUrl', RealmPropertyType.string, optional: true),
    ]);
  }
}
