import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget{

  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;
  @override
  Widget build(BuildContext context){
    return Material(
      type: MaterialType.transparency,
      child:Container(
        color: const Color(0xff900032),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/campus_logo.png'),
            Center(
                child: Text(
                  "CAMPUS +",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                )
            ),
          ]
        )
      ),
    );

  }
}