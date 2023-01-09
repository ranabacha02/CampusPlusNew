import 'package:campus_plus/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ContactPage.dart';

class MainCourse extends StatelessWidget {
  const MainCourse({
    Key? key,
    required this.event,
    required this.name,
    required this.department,
    required this.price,


  }) : super(key: key);

  final String event;
  final String name;
  final String department;
  final int price;



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
                // decoration: BoxDecoration(
                //   shape: BoxShape.circle,
                //   image: DecorationImage(
                //     fit: BoxFit.cover,
                //
                //   ),
                // ),
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
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      event,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      department,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Price per hour : "+ price.toString() + "\$",
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.contact_mail),
                onPressed: () { Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactPage(),
                  ),
                );
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