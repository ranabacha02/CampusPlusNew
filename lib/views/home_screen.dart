import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:campus_plus/utils/app_colors.dart';

import '../utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.white,
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: Text(
              "CAMPUS+",
              style: TextStyle(
                fontSize: 30,
                color: AppColors.aubRed,
              ),
            ),
            actions: <Widget>[
              IconButton(
                  onPressed: () => {print("hello world")},
                  icon: Image.asset('assets/postIcon.png')),
              IconButton(
                  onPressed: () => {print("hello world")},
                  icon: Image.asset('assets/calendarIcon.png')),
              IconButton(
                  onPressed: () => {print("hello world")},
                  icon: Image.asset('assets/notificationIcon.png')),
            ]),
        body: Container(
          color: AppColors.grey,
          child: Center(
              child: Text(
            "Home Screen In Progress...",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
          )),
        ));
  }
}
