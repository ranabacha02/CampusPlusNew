import 'package:campus_plus/model/card_model.dart';
import 'package:campus_plus/widgets/card_info.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import '../controller/card_controller.dart';
import '../utils/app_colors.dart';

class MainCard extends StatelessWidget {
  MainCard({
    Key? key,
    required this.card,
    required this.personal,
    required this.updateCard
  }) : super(key: key);
  final MyCard card;
  final bool personal;
  final Function updateCard;
  final CardController cardController = Get.put(CardController());
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    bool joined = card.users.where((user)=> (user.userId.contains(auth.currentUser!.uid))).isNotEmpty;
    DateTime now = DateTime.now();
    bool today = DateTime(card.eventStart.year, card.eventStart.month, card.eventStart.day).difference(DateTime(now.year, now.month, now.day)).inDays == 0;
    return Container(
        height: 130,
        margin: const EdgeInsets.only(top: 10),
        child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
          Positioned(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              child: Material(
                color: const Color.fromRGBO(242, 242, 242, 1.0),
                child: InkWell(
                  splashColor: Colors.white,
                  enableFeedback: true,
                  onTap: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => Center(
                              child: Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    Positioned(
                                      top: 42,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                          radius: 42,
                                          child:UserProfilePicture(
                                            imageURL: card.users[0].profilePictureURL,
                                            caption: "${card.users[0].firstName} ${card.users[0].lastName}",
                                            radius: 40,
                                            preview: false,
                                            userId: card.users[0].userId,
                                          )
                                      )
                                    ),
                                Positioned(
                                    top: 100,
                                    child: ClipPath(
                                        clipper: CustomPath(),
                                        child: Container(
                                            width: (MediaQuery.of(context).size.width) > 500 ? 500 * 0.85 : (MediaQuery.of(context).size.width) * 0.85,
                                            // height: 500,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: CardInfo(
                                                card: card,
                                                joined: joined,
                                                personal: personal
                                            )
                                        )
                                    )
                                ),
                              ]))),
                  child: Container(
                    width: (MediaQuery.of(context).size.width) > 500 ? 500 * 0.92 : (MediaQuery.of(context).size.width) * 0.92,
                    height: 100,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: UserProfilePicture(
                              imageURL: card.users[0].profilePictureURL,
                              radius: 20,
                              caption: "${card.users[0].firstName} ${card.users[0].lastName}",
                              preview: false,
                              userId: card.users[0].userId,
                            ),
                          ),
                          const SizedBox(height: 10, width: 7,),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  card.users[0].firstName,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ), //The Name of the cardCreator
                                Expanded(
                                  child: Text(
                                    card.event,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(107, 114, 128, 1),
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ), //The event description
                              ],
                            ),
                          ),
                          !personal ? Expanded(
                            flex: 1,
                            child: Center(
                              child: JoinButton(updateCard: updateCard, joined: joined, cardId: card.id),
                            ),
                          ):  const Expanded(flex:1, child: SizedBox(),),
                        ]),
                  ),
                ),
              ),
            ),
          ), //The Card itself
          personal ? Positioned(
            top: 15,
            right: (MediaQuery.of(context).size.width) > 500 ? ((MediaQuery.of(context).size.width - (500 * 0.92 + 8 + 8)) / 2 + 20) : ((MediaQuery.of(context).size.width) * 0.08 - 8 - 8 + 15),
            child:  ToggleMenu(updateCard: updateCard, cardId: card.id),
          ): const SizedBox(), //The Toggle Button
          Positioned(
              top: 92,
              right: (MediaQuery.of(context).size.width) > 500 ? ((MediaQuery.of(context).size.width - (500 * 0.92 + 8 + 8)) / 2 + 5) : ((MediaQuery.of(context).size.width) * 0.08 - 8 - 8),
              child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(style: BorderStyle.none,),
                      borderRadius: const BorderRadius.all(Radius.circular(20),)),
                  child: Text(
                    !today ? DateFormat.MMMd().add_jm().format(card.eventStart) : ("Today, ${DateFormat.jm().format(card.eventStart)}"),
                    textAlign: TextAlign.right,
                  ))), //The Date
          Positioned(
              top: 100.0,
              left: (MediaQuery.of(context).size.width) > 500 ? ((MediaQuery.of(context).size.width - (500 * 0.92 + 8 + 8)) / 2) + 40 : ((MediaQuery.of(context).size.width) * 0.08 - 8 - 8) / 2 + 40,
              child: Wrap(
                  spacing: 5,
                  children: [
                card.users.length > 1
                    ? UserProfilePicture(
                        imageURL: card.users[1].profilePictureURL,
                        caption: "${card.users[1].firstName} ${card.users[1].lastName}",
                        radius: 15,
                        preview: false,
                        userId: card.users[1].userId
                      ) : const SizedBox.shrink(),
                card.users.length > 2
                    ? UserProfilePicture(
                        imageURL: card.users[2].profilePictureURL,
                        caption: "${card.users[2].firstName} ${card.users[2].lastName}",
                        radius: 15,
                        preview: false,
                        userId: card.users[2].userId
                      ) : const SizedBox.shrink(),
                card.users.length > 3
                    ? UserProfilePicture(
                        imageURL: card.users[3].profilePictureURL,
                        caption: "${card.users[3].firstName} ${card.users[3].lastName}",
                        radius: 15,
                        preview: false,
                        userId: card.users[3].userId
                      ) : const SizedBox.shrink(),
                card.users.length > 4
                    ? CircleAvatar(
                        radius: 15,
                        backgroundColor: AppColors.grey,
                        child: CircleAvatar(
                          backgroundColor:  Colors.white,
                          foregroundColor: Colors.black,
                          radius: 14,
                          child: card.users.length< 99 ? Text("${card.users.length-4}+", style: const TextStyle(fontSize: 12.5),): const Text("...", style: TextStyle(fontSize: 16),)
                        )

                ) : const SizedBox.shrink(),
              ])), //The JoinedUserIcons
        ]));
  }
}

class JoinButton extends StatelessWidget {
   JoinButton({
    Key? key,
    required this.updateCard,
    required this.joined,
    required this.cardId,
  }) : super(key: key);
  final Function updateCard;
  final bool joined;
  final String cardId;
  final CardController cardController = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      isLiked: joined,
      onTap: (isLiked) async {
        if(!isLiked){
          final bool success = await cardController.joinCard(cardId);
          if(success) {updateCard(cardId); return !isLiked;}
          else {return isLiked;}
        }
        else {
          final bool success = await cardController.leaveCard(cardId);
          if (success) {updateCard(cardId); return !isLiked;}
          else {return isLiked;}
        }
      },
      likeBuilder: (bool isLiked){
        return Icon(
          Icons.check_circle_outlined,
          color:  isLiked ? const Color.fromRGBO(29, 171, 135, 1) : const Color.fromRGBO(107, 114, 128, 1),
          size: 30
        );
      },
    );
  }
}

class ToggleMenu extends StatefulWidget {
  const ToggleMenu({
    Key? key,
    required this.updateCard,
    required this.cardId
  }) : super(key: key);
  final String cardId;
  final Function updateCard;
  @override
  State<ToggleMenu> createState() => _ToggleMenuState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _ToggleMenuState extends State<ToggleMenu> {
  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SampleItem>(
      initialValue: selectedMenu,
      onSelected: (SampleItem item) {
        if(item ==SampleItem.itemOne){
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                DeleteDialog(updateCard: widget.updateCard, cardId: widget.cardId,)
          );
          }
        },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: const Icon(Icons.more_horiz, size: 24,),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
        const PopupMenuItem<SampleItem>(
          height: 0,
          value: SampleItem.itemOne,
          child: Text('Remove'),
        ),
      ],
    );
  }
}

class DeleteDialog extends StatelessWidget {
  DeleteDialog({
    required this.updateCard,
    required this.cardId,
    Key? key,
  }) : super(key: key);
  final Function updateCard;
  final String cardId;
  final CardController cardController = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: (MediaQuery.of(context).size.width) > 500 ? 500 * 0.85 : (MediaQuery.of(context).size.width) * 0.85,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Delete Event',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text('Are you sure you want to delete this event?',
                style: TextStyle()
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: (){Navigator.pop(context);},
                    child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                const SizedBox(width: 10),
                TextButton(
                    onPressed: () {
                      cardController.removeCard(cardId);
                      updateCard(cardId);
                      Navigator.pop(context);
                    },
                    child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
              ]
            )
          ]
        ) // border: Border
      )
    );
  }
}

class CustomPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.5, 68, size.width * 0.65, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

