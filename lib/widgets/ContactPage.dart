import 'package:campus_plus/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.aubRed,
        title: Text('Contact'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // use the Navigator to pop the current route off the stack
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Text('Contact Page'),
      ),
    );
  }
}