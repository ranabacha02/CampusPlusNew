import 'package:campus_plus/firebase_options.dart';
import 'package:campus_plus/widgets/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:campus_plus/controller/auth_controller.dart';
import 'package:campus_plus/views/signIn_signUp_screen.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core/firebase_core.dart';


class MockAuth extends Mock implements AuthController {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Widget makeTestableWidget({required Widget child, required AuthController auth}) {
    return AuthProvider(
      auth: auth,
      key: const ValueKey('AuthProvider'),
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('email or password is empty, does not sign in', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();

    bool didSignIn = false;
    LoginView page = LoginView();

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    await tester.tap(find.byKey(Key('signIn')));

    verifyNever(mockAuth.auth.signInWithEmailAndPassword(email: '', password: ''));
    expect(didSignIn, false);
  });

  testWidgets('non-empty email and password, valid account, call sign in, succeed', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();
    when(mockAuth.auth.signInWithEmailAndPassword(email: 'email', password: 'password')).thenAnswer((invocation) => Future.value());

    bool didSignIn = false;
    LoginView page = LoginView();

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    Finder emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(Key('password'));
    await tester.enterText(passwordField, 'password');

    await tester.tap(find.byKey(Key('signIn')));

    verify(mockAuth.auth.signInWithEmailAndPassword(email: 'email', password: 'password')).called(1);
    expect(didSignIn, true);

  });

  testWidgets('non-empty email and password, valid account, call sign in, fails', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();
    when(mockAuth.auth.signInWithEmailAndPassword(email: 'email', password: 'password')).thenThrow(StateError('invalid credentials'));

    bool didSignIn = false;
    LoginView page = LoginView();

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    Finder emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(Key('password'));
    await tester.enterText(passwordField, 'password');

    await tester.tap(find.byKey(Key('signIn')));

    verify(mockAuth.auth.signInWithEmailAndPassword(email: 'email', password: 'password')).called(1);
    expect(didSignIn, false);

  });

}

