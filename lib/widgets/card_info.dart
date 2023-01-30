import 'package:campus_plus/model/clean_user_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/card_controller.dart';
import '../utils/app_colors.dart';
import 'package:get/get.dart';


class CardInfo extends StatelessWidget {
  CardInfo({
    Key? key,
    required this.usersJoined,
    required this.event,
    required this.date,
    required this.joined,
    required this.personal,
    required this.cardId,
    required this.userInfo,
  }) : super(key: key);

  final List<CleanUser> usersJoined;
  final String event;
  final DateTime date;
  final bool joined;
  final bool personal;
  CardController cardController = Get.put(CardController());
  final String cardId;
  final CleanUser userInfo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 20),
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                  children: [
                    Text(
                      "${usersJoined[0].firstName} ${usersJoined[0].lastName}",
                      style: TextStyle(
                          fontSize: 24,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${usersJoined[0].major} | ${usersJoined[0].graduationYear}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(107, 114, 128, 1),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ] )
            ],
          ),

          Text(
            "Description",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Text(
              event,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.black,
              )
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Text(
            "Date",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Text(
              DateFormat.MMMd().add_jm().format(date),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.black,
              )
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          const Text(
              "Attendees",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,)
          ),
          SizedBox(
            height: Get.height * 0.01,
          ),
          Row(
            children:
            [
              for (var user in usersJoined.sublist(1,))
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color.fromRGBO(144, 0, 49, 1),
                  foregroundColor: Colors.white,
                  child: Text(user.firstName[0]),
                )
            ],
          ),
          SizedBox(
            height: Get.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !joined && !personal ?TextButton(
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal:60),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(29, 171, 135, 1),
                        border: Border.all(
                          style: BorderStyle.none,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20),)
                    ),
                    child: const Text(
                      'Ok, Join!',
                      style: TextStyle(fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                ),
                onPressed:(){
                  cardController.joinCard(cardId, userInfo);
                  Navigator.pop(context);
                },
              ):
              TextButton(
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal:60),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(
                          style: BorderStyle.none,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20),)
                    ),
                    child: !personal ? const Text(
                      'Leave',
                      style: TextStyle(fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ):
                    const Text(
                      'Remove',
                      style: TextStyle(fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                ),
                onPressed:(){
                  !personal ? cardController.leaveCard(cardId, userInfo) : cardController.removeCard(cardId);
                  Navigator.pop(context);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
