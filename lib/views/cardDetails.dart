import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import 'package:get/get.dart';

class CardDetails extends StatelessWidget {

  CardDetails({
    Key? key,
    required this.event,
    required this.name,
    required this.personal,
    required this.userInfo,
    required this.usersJoined,
    required this.date,
  }) : super(key: key);

  final String event;
  final String name;
  final bool personal;
  final Map<String, dynamic> userInfo;
  List<dynamic> usersJoined;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final users = usersJoined.sublist(1);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: ()=> Navigator.pop(context),
          ),
          backgroundColor: AppColors.white,
          title: Text(
            "CAMPUS+",
            style: TextStyle(
              fontSize: 30,
              color: AppColors.aubRed,
            ),
          ),
        ),
        body: Material(
            type: MaterialType.transparency,
            child: Container(
              color: AppColors.white,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child:
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            // to be changed
                            radius: 50,
                            backgroundColor: AppColors.circle,
                            foregroundColor: AppColors.white,
                            child: Text(
                              usersJoined[0]["firstName"][0] +  usersJoined[0]["lastName"][0],
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 40,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Text(
                            usersJoined[0]["firstName"] +
                                " " +
                                usersJoined[0]["lastName"],
                            style: TextStyle(
                                fontSize: 30,
                                color: AppColors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "" + usersJoined[0]["major"] + " | " +usersJoined[0]["graduationYear"].toString()??"",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.black,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Text(
                            "Event",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                              event,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                  fontStyle: FontStyle.italic
                              )
                          ),
                          Text(
                            "Date",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                              DateFormat.MMMd().add_jm().format(date),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                  fontStyle: FontStyle.italic
                              )
                          ),
                          Container(
                            child: Row(
                              children:
                                [
                                  for (var user in users)
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                                      foregroundColor: Colors.white,
                                      child: Text(user["firstName"][0]),
                                    )
                                ],
                            )
                          )
                        ],
                      ),
                ),
              ),
            )
        )
    );
  }
}
