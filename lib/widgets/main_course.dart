import 'package:campus_plus/model/clean_user_model.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ContactPage.dart';

class MainCourse extends StatelessWidget {
  const MainCourse({
    Key? key,
    required this.courseName,
    required this.department,
    required this.price,
    required this.user,
  }) : super(key: key);

  final String courseName;
  final String department;
  final int price;
  final CleanUser user;



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(
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
                      user.firstName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      courseName,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      department,
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Price per hour : $price\$",
                      style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.contact_mail),
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