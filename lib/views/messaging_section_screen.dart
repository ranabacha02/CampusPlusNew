import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class MessagingSectionScreen extends StatefulWidget{
  @override
  _MessagingSectionScreenState createState() => _MessagingSectionScreenState();
}

class _MessagingSectionScreenState extends State<MessagingSectionScreen> {
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
                "Messaging Screen In Progress...",
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