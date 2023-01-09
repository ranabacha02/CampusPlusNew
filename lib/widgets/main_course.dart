import 'package:campus_plus/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainCourse extends StatelessWidget {
  const MainCourse({
    Key? key,
    required this.event,
    required this.name,
    required this.department,

  }) : super(key: key);

  final String event;
  final String name;
  final String department;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                height: 100,
                width: 100,

              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      event,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      department,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.contact_mail),
                onPressed: () {
                  // handle contact button press
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}