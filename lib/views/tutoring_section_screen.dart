import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class TutoringSectionScreen extends StatefulWidget{
  @override
  _TutoringSectionScreenState createState() => _TutoringSectionScreenState();
}

class _TutoringSectionScreenState extends State<TutoringSectionScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  @override
  Widget build(BuildContext context){
    return Material(
        type: MaterialType.transparency,
        child:Container(
          color: AppColors.grey,
          child:Center(
              child: Text(
                "Tutoring Screen In Progress...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
              )
          ),
        )
    );
  }
}