import 'package:campus_plus/views/card_details_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../controller/card_controller.dart';
import '../model/clean_user_model.dart';

class MainCard extends StatelessWidget {
   MainCard({
    Key? key,
    required this.event,
    required this.name,
    required this.personal,
    required this.cardId,
    required this.userInfo,
    required this.usersJoined,
     required this.date,
  }) : super(key: key);

  final String cardId;
  final CleanUser userInfo;
  final String event;
  final String name;
  final bool personal;
  List<CleanUser> usersJoined;
  final DateTime date;
  CardController cardController = Get.put(CardController());

  @override
  Widget build(BuildContext context) {
    bool joined = usersJoined.where((user)=> (user.userId.contains(userInfo.userId))).length>0;
    DateTime now = DateTime.now();
    bool today = DateTime(date.year, date.month, date.day).difference(DateTime(now.year,now.month,now.day)).inDays==0;
    return
      Container(
          height: 150,
          child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Positioned(
                  top: 15.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    child: Material(
                      color: Color.fromRGBO(242, 242, 242, 1.0),
                      child:  InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context){
                                return CardDetails(
                                    event: event,
                                    name: name,
                                    personal: personal,
                                    joined: joined,
                                    cardId: cardId,
                                    userInfo: userInfo,
                                    usersJoined: usersJoined,
                                    date: date
                                );
                              }),
                          );
                        },
                        splashColor: Colors.white,
                        enableFeedback: true,
                        child: Container(
                          width: 340,
                          height: 100,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal:8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                              Expanded(
                                flex: 1,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                                  foregroundColor: Colors.white,
                                  child: Text(
                                      usersJoined[0].firstName[0],
                                    style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                                width: 7,
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    usersJoined[0].firstName,
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    child:Text(
                                      event,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      // softWrap: false,
                                      style: TextStyle(
                                        color: Color.fromRGBO(107, 114, 128, 1),
                                        fontFamily: 'Roboto',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                  ),
                                  // Spacer(),
                                ],
                              ),),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    !joined && !personal ?TextButton(
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
                                          child: const Text(
                                            'Join',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(29, 171, 135, 1),
                                              border: Border.all(
                                                style: BorderStyle.none,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              )
                                          )
                                      ),
                                      onPressed:(){
                                        cardController.joinCard(cardId, userInfo);
                                      },
                                    ):
                                    TextButton(
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
                                          child: !personal ? const Text(
                                            'Leave',
                                            style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                          ):
                                          const Text(
                                            'Remove',
                                            style: TextStyle(
                                              fontFamily: 'Roboto',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                          ),
                                          ),
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              border: Border.all(
                                                style: BorderStyle.none,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              )
                                          )
                                      ),
                                      onPressed:(){
                                        !personal ? cardController.leaveCard(cardId, userInfo) : cardController.removeCard(cardId);
                                      },
                                    ),
                                  ]
                              ),
                              ),
                            ]
                    ),
                  ),
                  ),
                  ),
                  ),
                ),//The card
                Positioned(
                  top: 92,
                  right: 26,
                  child: Container(
                    // width: 130,
                    height: 30,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal:8),
                    child: Text(
                        !today ? DateFormat.MMMd().add_jm().format(date): ("Today, "+DateFormat.jm().format(date)),
                        textAlign: TextAlign.right,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        )
                    )
                  )

                ),//The joined users icons
                Positioned(
                    top: 95.0,
                    left: 80.0,
                    child: Row(
                      children:[
                        usersJoined.length>1 ? CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                          foregroundColor: Colors.white,
                          child: Text(usersJoined[1].firstName[0]),
                        ): SizedBox.shrink(),
                         usersJoined.length >2 ? CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                          foregroundColor: Colors.white,
                          child: Text(usersJoined[2].firstName[0]),
                        ): SizedBox.shrink(),
                        usersJoined.length >3 ? CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                          foregroundColor: Colors.white,
                          child: Text(usersJoined[3].firstName[0]),
                        ): SizedBox.shrink(),
                      ]
                    )

                ),//The date
              ]
          )
      );
  }
}