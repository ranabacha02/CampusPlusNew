import 'package:campus_plus/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget chatDateTile(String date) {
  return Opacity(
      opacity: 0.6,
      child: Container(
        height: 40,
        width: 500,
        padding: EdgeInsets.only(top: 4, bottom: 4, left: 0, right: 24),
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.only(left: 30),
          padding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 13, right: 13),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: AppColors.grey,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontSize: 13, color: Colors.white))
            ],
          ),
        ),
      ));
}
