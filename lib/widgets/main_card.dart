import 'package:campus_plus/views/card_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    bool today = DateTime(date.year, date.month, date.day).difference(DateTime(now.year,now.month,now.day)).inDays==0;
    return
      Container(
          height: 130,
          margin: const EdgeInsets.only(top: 10),
          child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Positioned(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: Material(
                        color: const Color.fromRGBO(242, 242, 242, 1.0),
                        child:  InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context){
                                return CardDetails(
                                    event: event,
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
                            width: (MediaQuery.of(context).size.width) > 500 ? 500*0.92 : (MediaQuery.of(context).size.width)*0.92,
                            height: 100,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal:8),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:[
                                  Expanded(
                                    flex: 1,
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: const Color.fromRGBO(144, 0, 49, 1),
                                      foregroundColor: Colors.white,
                                      child: Text(
                                        usersJoined[0].firstName[0],
                                        style: const TextStyle(fontSize: 22, color: Colors.white,),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10, width: 7,),
                                  Expanded(
                                    flex: 4,
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
                                        ),//The Name of the cardCreator
                                        Expanded(
                                          child:Text(
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

                                        ),//The event description
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
                                                decoration: BoxDecoration(
                                                    color: const Color.fromRGBO(29, 171, 135, 1),
                                                    border: Border.all(
                                                      style: BorderStyle.none,
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(20),)
                                                ),
                                                child: const Text(
                                                  'Join',
                                                  style: TextStyle(
                                                    fontFamily: 'Roboto',
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                )
                                            ),
                                            onPressed:(){
                                              cardController.joinCard(cardId, userInfo);
                                            },
                                          ):
                                          TextButton(
                                            child: Container(
                                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
                                                decoration: BoxDecoration(
                                                    color: Colors.red,
                                                    border: Border.all(
                                                      style: BorderStyle.none,
                                                    ),
                                                    borderRadius: const BorderRadius.all(Radius.circular(20),)
                                                ),
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
                  ), //The Card itself
                Positioned(
                  top: 92,
                  right: (MediaQuery.of(context).size.width) > 500 ? ((MediaQuery.of(context).size.width - (500*0.92+8+8))/2 + 5) :((MediaQuery.of(context).size.width)*0.08-8-8),
                  child: Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal:8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          style: BorderStyle.none,
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20),)
                    ),
                    child: Text(
                        !today ? DateFormat.MMMd().add_jm().format(date): ("Today, ${DateFormat.jm().format(date)}"),
                        textAlign: TextAlign.right,
                    )
                  )
                ),//The joined users icons
                Positioned(
                    top: 95.0,
                    left: (MediaQuery.of(context).size.width) > 500 ? ((MediaQuery.of(context).size.width - (500*0.92+8+8))/2)+ 40 :((MediaQuery.of(context).size.width)*0.08-8-8)/2+ 40,
                    child: Row(
                      children:[
                        usersJoined.length>1 ? CircleAvatar(
                          radius: 15,
                          backgroundColor: const Color.fromRGBO(144, 0, 49, 1),
                          foregroundColor: Colors.white,
                          child: Text(usersJoined[1].firstName[0]),
                        ): const SizedBox.shrink(),
                         usersJoined.length >2 ? CircleAvatar(
                          radius: 15,
                          backgroundColor: const Color.fromRGBO(144, 0, 49, 1),
                          foregroundColor: Colors.white,
                          child: Text(usersJoined[2].firstName[0]),
                        ): const SizedBox.shrink(),
                        usersJoined.length >3 ? CircleAvatar(
                          radius: 15,
                          backgroundColor: const Color.fromRGBO(144, 0, 49, 1),
                          foregroundColor: Colors.white,
                          child: Text(usersJoined[3].firstName[0]),
                        ): const SizedBox.shrink(),
                      ]
                    )

                ),//The date
              ]
          )
      );
  }
}