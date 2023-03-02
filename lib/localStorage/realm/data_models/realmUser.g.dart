// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realmUser.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class RealmUser extends _RealmUser
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmUser(
    String userId,
    String firstName,
    String lastName,
    String gender,
    String department,
    String major,
    String email,
    int graduationYear,
    DateTime lastLogged,
    int mobilePhoneNumber,
    String description,
    String profilePictureURL, {
    Iterable<String> rentals = const [],
    Iterable<String> chatsId = const [],
    Iterable<String> tutoringClasses = const [],
  }) {
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'firstName', firstName);
    RealmObjectBase.set(this, 'lastName', lastName);
    RealmObjectBase.set(this, 'gender', gender);
    RealmObjectBase.set(this, 'department', department);
    RealmObjectBase.set(this, 'major', major);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'graduationYear', graduationYear);
    RealmObjectBase.set(this, 'lastLogged', lastLogged);
    RealmObjectBase.set(this, 'mobilePhoneNumber', mobilePhoneNumber);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'profilePictureURL', profilePictureURL);
    RealmObjectBase.set<RealmList<String>>(
        this, 'rentals', RealmList<String>(rentals));
    RealmObjectBase.set<RealmList<String>>(
        this, 'chatsId', RealmList<String>(chatsId));
    RealmObjectBase.set<RealmList<String>>(
        this, 'tutoringClasses', RealmList<String>(tutoringClasses));
  }

  RealmUser._();

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;

  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get firstName =>
      RealmObjectBase.get<String>(this, 'firstName') as String;

  @override
  set firstName(String value) => RealmObjectBase.set(this, 'firstName', value);

  @override
  String get lastName =>
      RealmObjectBase.get<String>(this, 'lastName') as String;

  @override
  set lastName(String value) => RealmObjectBase.set(this, 'lastName', value);

  @override
  String get gender => RealmObjectBase.get<String>(this, 'gender') as String;

  @override
  set gender(String value) => RealmObjectBase.set(this, 'gender', value);

  @override
  String get department =>
      RealmObjectBase.get<String>(this, 'department') as String;

  @override
  set department(String value) =>
      RealmObjectBase.set(this, 'department', value);

  @override
  String get major => RealmObjectBase.get<String>(this, 'major') as String;

  @override
  set major(String value) => RealmObjectBase.set(this, 'major', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;

  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  int get graduationYear =>
      RealmObjectBase.get<int>(this, 'graduationYear') as int;

  @override
  set graduationYear(int value) =>
      RealmObjectBase.set(this, 'graduationYear', value);

  @override
  DateTime get lastLogged =>
      RealmObjectBase.get<DateTime>(this, 'lastLogged') as DateTime;

  @override
  set lastLogged(DateTime value) =>
      RealmObjectBase.set(this, 'lastLogged', value);

  @override
  int get mobilePhoneNumber =>
      RealmObjectBase.get<int>(this, 'mobilePhoneNumber') as int;

  @override
  set mobilePhoneNumber(int value) =>
      RealmObjectBase.set(this, 'mobilePhoneNumber', value);

  @override
  RealmList<String> get rentals =>
      RealmObjectBase.get<String>(this, 'rentals') as RealmList<String>;

  @override
  set rentals(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get chatsId =>
      RealmObjectBase.get<String>(this, 'chatsId') as RealmList<String>;

  @override
  set chatsId(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<String> get tutoringClasses =>
      RealmObjectBase.get<String>(this, 'tutoringClasses') as RealmList<String>;

  @override
  set tutoringClasses(covariant RealmList<String> value) =>
      throw RealmUnsupportedSetError();

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;

  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get profilePictureURL =>
      RealmObjectBase.get<String>(this, 'profilePictureURL') as String;

  @override
  set profilePictureURL(String value) =>
      RealmObjectBase.set(this, 'profilePictureURL', value);

  @override
  Stream<RealmObjectChanges<RealmUser>> get changes =>
      RealmObjectBase.getChanges<RealmUser>(this);

  @override
  RealmUser freeze() => RealmObjectBase.freezeObject<RealmUser>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmUser._);
    return const SchemaObject(ObjectType.realmObject, RealmUser, 'RealmUser', [
      SchemaProperty('userId', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('firstName', RealmPropertyType.string),
      SchemaProperty('lastName', RealmPropertyType.string),
      SchemaProperty('gender', RealmPropertyType.string),
      SchemaProperty('department', RealmPropertyType.string),
      SchemaProperty('major', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('graduationYear', RealmPropertyType.int),
      SchemaProperty('lastLogged', RealmPropertyType.timestamp),
      SchemaProperty('mobilePhoneNumber', RealmPropertyType.int),
      SchemaProperty('rentals', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('chatsId', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('tutoringClasses', RealmPropertyType.string,
          collectionType: RealmCollectionType.list),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('profilePictureURL', RealmPropertyType.string),
    ]);
  }
}
