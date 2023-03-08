import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/card_controller.dart';
import '../model/card_model.dart';
import '../utils/app_colors.dart';
import 'package:get/get.dart';


class CardInfo extends StatelessWidget {
  CardInfo({
    Key? key,
    required this.card,
    required this.joined,
    required this.personal,

  }) : super(key: key);
  final MyCard card;
  final bool joined;
  final bool personal;
  final CardController cardController = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, right:20, bottom: 10, left: 20),
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
                      "${card.users[0].firstName} ${card.users[0].lastName}",
                      style: TextStyle(
                          fontSize: 24,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${card.users[0].major} | ${card.users[0].graduationYear}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromRGBO(107, 114, 128, 1),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ] )
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Event",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
              card.event,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromRGBO(107, 114, 128, 1),
              )
          ),
          const SizedBox(
            height: 10,
          ),
          Row(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                "Start",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                  DateFormat.MMMd().add_jm().format(card.eventStart),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(107, 114, 128, 1),
                  )
              ),
            ],),
            const SizedBox(
              width: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                "End",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                  DateFormat.MMMd().add_jm().format(card.eventEnd),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(107, 114, 128, 1),
                  )
              ),
            ],),
          ],),
          const SizedBox(
            height: 10,
          ),
          const Text(
              "Attendees",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,)
          ),
          const SizedBox(
            height: 10,
          ),
         Wrap(
          spacing: 4,
          runSpacing: 5,
          children:
          [for (var user in card.users.sublist(1,))
              UserProfilePicture(
                imageURL: user.profilePictureURL,
                caption: "${user.firstName} ${user.lastName}",
                radius: 20,
                preview: false,
                userId: user.userId,
              )
          ],
        ),
        ],
      ),
    );
  }
}
