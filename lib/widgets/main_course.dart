import 'package:campus_plus/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainCourse extends StatelessWidget {
  const MainCourse({
    Key? key,
    required this.event,
    required this.name,
  }) : super(key: key);

  final String event;
  final String name;

  @override
  Widget build(BuildContext context) {
    return
      Container(
          height: 100,
          child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Positioned(
                  child:  Container(
                    width: 200,
                    height: 50,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal:8),
                    decoration: BoxDecoration(
                        color: AppColors.aubRed,
                        border: Border.all(
                          // color: Colors.black,
                          // width: 4.0,
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        )
                    ),
                    child: Row(
                        children:[
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacer(),

                              Text(
                                name,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontFamily: 'Georgia',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                event,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontFamily: 'Georgia',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          Spacer(),

                        ]
                    ),
                  ),
                ),

              ]
          )
      );
  }
}