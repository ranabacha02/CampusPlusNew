import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class RentalSectionScreen extends StatefulWidget{
  @override
  _RentalSectionScreenState createState() => _RentalSectionScreenState();
}

class _RentalSectionScreenState extends State<RentalSectionScreen> {
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
                "Rental Screen In Progress...",
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