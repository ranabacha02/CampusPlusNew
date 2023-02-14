import 'package:campus_plus/widgets/card_info.dart';
import 'package:campus_plus/widgets/user_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import '../controller/card_controller.dart';
import '../model/clean_user_model.dart';

class MainCard extends StatelessWidget {
  MainCard({
    Key? key,
    required this.event,
    required this.personal,
    required this.cardId,
    required this.userInfo,
    required this.usersJoined,
    required this.date,
  }) : super(key: key);

  final String cardId;
  final CleanUser userInfo;
  final String event;
  final bool personal;
  List<CleanUser> usersJoined;
  final DateTime date;
  CardController cardController = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    bool joined = usersJoined.where((user)=> (user.userId.contains(userInfo.userId))).isNotEmpty;
    DateTime now = DateTime.now();
    bool today = DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays == 0;
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
                                            imageURL: usersJoined[0].profilePictureURL,
                                            caption: "${usersJoined[0].firstName} ${usersJoined[0].lastName}",
                                            radius: 40,
                                            preview: false,
                                          )
                                      )
                                    ),
                                Positioned(
                                    top: 100,
                                    child: ClipPath(
                                        clipper: CustomPath(),
                                        child: Container(
                                            width: (MediaQuery.of(context).size.width) > 500 ? 500 * 0.85 : (MediaQuery.of(context).size.width) * 0.85,
                                            height: 500,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: CardInfo(
                                                usersJoined: usersJoined,
                                                event: event,
                                                date: date,
                                                joined: joined,
                                                personal: personal,
                                                cardId: cardId,
                                                userInfo: userInfo)
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
                              imageURL: usersJoined[0].profilePictureURL,
                              radius: 20,
                              caption: "${usersJoined[0].firstName} ${usersJoined[0].lastName}",
                              preview: false,
                            ),
                          ),
                          const SizedBox(height: 10, width: 7,),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  usersJoined[0].firstName,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ), //The Name of the cardCreator
                                Expanded(
                                  child: Text(
                                    event,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    // softWrap: false,
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
                              child: JoinButton(joined: joined, cardId: cardId, userInfo: userInfo),
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
            child:  ToggleMenu(cardId: cardId),
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
                    !today ? DateFormat.MMMd().add_jm().format(date) : ("Today, ${DateFormat.jm().format(date)}"),
                    textAlign: TextAlign.right,
                  ))), //The Date
          Positioned(
              top: 95.0,
              left: (MediaQuery.of(context).size.width) > 500 ? ((MediaQuery.of(context).size.width - (500 * 0.92 + 8 + 8)) / 2) + 40 : ((MediaQuery.of(context).size.width) * 0.08 - 8 - 8) / 2 + 40,
              child: Row(children: [
                usersJoined.length > 1
                    ? UserProfilePicture(
                        imageURL: usersJoined[1].profilePictureURL,
                        caption: "${usersJoined[1].firstName} ${usersJoined[1].lastName}",
                        radius: 15,
                        preview: false,
                      )
                    : const SizedBox.shrink(),
                usersJoined.length > 2
                    ? UserProfilePicture(
                        imageURL: usersJoined[2].profilePictureURL,
                        caption: "${usersJoined[2].firstName} ${usersJoined[2].lastName}",
                        radius: 15,
                        preview: false,
                      )
                    : const SizedBox.shrink(),
                usersJoined.length > 3
                    ? UserProfilePicture(
                        imageURL: usersJoined[3].profilePictureURL,
                        caption: "${usersJoined[3].firstName} ${usersJoined[3].lastName}",
                        radius: 15,
                        preview: false,
                      )
                    : const SizedBox.shrink(),
              ])), //The JoinedUserIcons
        ]));
  }
}

class JoinButton extends StatelessWidget {
  JoinButton({
    Key? key,
    required this.joined,
    required this.cardId,
    required this.userInfo,
  }) : super(key: key);

  final bool joined;
  final String cardId;
  final CleanUser userInfo;
  CardController cardController = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    return LikeButton(
      isLiked: joined,
      onTap: (isLiked) async {
        if(!isLiked){
          final bool success = await cardController.joinCard(cardId, userInfo);
          if(success) {return !isLiked;}
          else {return isLiked;}
        }
        else {
          final bool success = await cardController.leaveCard(cardId, userInfo);
          if (success) {return !isLiked;}
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
  const ToggleMenu({super.key, required this.cardId});
  final String cardId;
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
                DeleteDialog(cardId: widget.cardId,)
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
    required this.cardId,
    Key? key,
  }) : super(key: key);

  final String cardId;
  CardController cardController = Get.put(CardController());

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
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.14, size.width * 0.65, 0);
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

