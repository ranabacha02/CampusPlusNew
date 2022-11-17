import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AccountSettingsScreen extends StatefulWidget{
  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
      ),
      body:Material(
          type: MaterialType.transparency,
          child:Container(
            color: AppColors.textFieldBackground,
            child:Center(
                child: Text(
                  "Account Settings Screen In Progress...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                )
            ),
          )
      ),
    );
  }
}