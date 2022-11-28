import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  EmailVerificationScreen({required this.email});

  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState(email: email);
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final String email;

  _EmailVerificationScreenState({required this.email});

  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
          color: const Color(0xff900032),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset('assets/campus_logo.png'),
            Center(
                child: Text(
              "Email Verification sent.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
              ),
            )),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "An email verification was sent to " +
                    email +
                    ".\n You will be redirected to your account once you verify your email.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("You have 60 seconds to verify your email.")
          ])),
    );
  }
}
