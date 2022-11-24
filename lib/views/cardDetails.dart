import 'package:cloud_firestore/cloud_firestore.dart';
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
    required this.joined,
    required this.cardId,
    required this.userInfo,
    required this.usersJoined,
    required this.date,
  }) : super(key: key);

  final String cardId;
  final String event;
  final String name;
  final bool personal;
  final bool joined;
  final Map<String, dynamic> userInfo;
  List<dynamic> usersJoined;
  final DateTime date;
  CollectionReference cards = FirebaseFirestore.instance.collection('Cards');


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
                     Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: AppColors.circle,
                                    foregroundColor: AppColors.white,
                                    child: Text(
                                      usersJoined[0]["firstName"][0] +  usersJoined[0]["lastName"][0],
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 30,
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
                                      fontSize: 24,
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "" + usersJoined[0]["major"] + " | " +usersJoined[0]["graduationYear"].toString()??"",
                                  style: TextStyle(
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
                          Text(
                              "Attendees",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Container(
                            child: Row(
                              children:
                                [
                                  for (var user in users)
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                                      foregroundColor: Colors.white,
                                      child: Text(user["firstName"][0]),
                                    )
                                ],
                            )
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
                                    child: const Text(
                                      'Ok, Join!',
                                      style: TextStyle(fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
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
                                  cards.doc(cardId).update({"users": FieldValue.arrayUnion([userInfo]),})
                                      .then((doc)=> {print("joined"),Navigator.pop(context),},
                                      onError: (e)=>print("Erorr updating document $e"));

                                },
                              ):
                              TextButton(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal:60),
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
                                  !personal ? cards.doc(cardId).update({"users": FieldValue.arrayRemove([userInfo]),})
                                      .then((doc)=> {print("left"),Navigator.pop(context)},
                                    onError: (e)=>print("Erorr updating document $e"),
                                  ):
                                  cards.doc(cardId).delete()
                                      .then((doc)=> {print("Document deleted"),Navigator.pop(context)},
                                      onError: (e)=> print("Error updating document $e")
                                  );
                                },
                              ),
                            ],
                          )

                        ],
                ),
              ),
            )
        )
    );
  }
}
