import 'package:campus_plus/controller/auth_controller.dart';
import 'package:campus_plus/controller/data_controller.dart';
import 'package:campus_plus/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';


class MockSharedPreferences extends Mock implements SharedPreferences {}

//class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockBuildContext extends Mock implements BuildContext {}

class MockDataController extends Mock implements DataController {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

class MockDocumentReference extends Mock implements DocumentReference {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  group('AuthController', ()
  {
    late AuthController authController;
    late MockSharedPreferences sharedPreferences;
   //late MockNavigatorObserver navigatorObserver;
    late MockBuildContext buildContext;
    late MockDataController dataController;
    late MockFirebaseAuth firebaseAuth;
    late MockCollectionReference collectionReference;
    late MockUserCredential userCredential;
    late MockUser user;
    late MockQuerySnapshot querySnapshot;
    late MockQueryDocumentSnapshot queryDocumentSnapshot;
    late MockDocumentReference documentReference;

    setUp(()  {
      //WidgetsFlutterBinding.ensureInitialized();
      //await Firebase.initializeApp();
      authController = AuthController();
      sharedPreferences = MockSharedPreferences();
     // navigatorObserver = MockNavigatorObserver();
      buildContext = MockBuildContext();
      dataController = MockDataController();
      firebaseAuth = MockFirebaseAuth();
      collectionReference = MockCollectionReference();
      userCredential = MockUserCredential();
      user = MockUser();
      querySnapshot = MockQuerySnapshot();
      queryDocumentSnapshot = MockQueryDocumentSnapshot();
      documentReference = MockDocumentReference();

      Get.put<DataController>(dataController);
      Get.put<FirebaseAuth>(firebaseAuth);
      Get.put<SharedPreferences>(sharedPreferences);
    //  Get.put<NavigatorObserver>(navigatorObserver);


    });

    test('should sign in successfully', () async {
      // Arrange
      when(sharedPreferences.getString('email')).thenReturn('test@test.com');
      when(sharedPreferences.setString('email', 'test@test.com'))
          .thenAnswer((_) => Future.value(true));
      when(firebaseAuth.signInWithEmailAndPassword(
          email: 'test@test.com', password: '123456'))
          .thenAnswer((_) => Future.value(userCredential));
      when(userCredential.user).thenReturn(user);
      when(user.emailVerified).thenReturn(true);

      // Act
      await authController.signIn(
          email: 'test@test.com', password: '123456', context: buildContext);

      // Assert
      verify(sharedPreferences.setString('email', 'test@test.com'));
    });

    test('should sign up successfully', () async {
      // Arrange
      when(firebaseAuth.createUserWithEmailAndPassword(
          email: 'test@test.com', password: '123456'))
          .thenAnswer((_) => Future.value(userCredential));
      when(userCredential.user).thenReturn(user);
      when(user.sendEmailVerification()).thenAnswer((_) => Future.value());
      when(dataController.addUser(any, any, any, any, any, any))
          .thenAnswer((_) => Future.value());
      when(authController.signOut()).thenAnswer((_) => Future.value());

      // Act
      authController.signUp(
          email: 'test@test.com',
          password: '123456',
          firstName: 'John',
          lastName: 'Doe',
          graduationYear: 2022,
          major: 'Computer Science',
          mobileNumber: 1234567890);

      // Assert
      verify(dataController.addUser(any, any, any, any, any, any));
    });
  });}

