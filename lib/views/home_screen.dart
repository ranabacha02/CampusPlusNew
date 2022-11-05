import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                        "Home Screen In Progress...",
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