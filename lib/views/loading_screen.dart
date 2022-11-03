import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget{

  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  @override
  Widget build(BuildContext context){
    return Container(
      color: const Color(0xff900032),
      child: Center(
        child: Text(
          "CAMPUS +",
          textAlign: TextAlign.center,
        )
      ),
    );
  }
}