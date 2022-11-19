import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
   MainCard({
    Key? key,
    required this.event,
    required this.name,
    required this.personal,
    required this.cardId,
    required this.userInfo,
    required this.usersJoined,
  }) : super(key: key);

  final String cardId;
  final Map<String, dynamic> userInfo;
  final String event;
  final String name;
  final bool personal;
  List<dynamic> usersJoined;
  CollectionReference cards = FirebaseFirestore.instance.collection('Cards');

  @override
  Widget build(BuildContext context) {
    bool joined = usersJoined.where((user)=> (user["userId"].contains(userInfo["userId"]))).length>0;
    return
      Container(
          height: 150,
          child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Positioned(
                  top: 12.0,
                  child:  Container(
                    width: 320,
                    height: 100,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal:8),
                    decoration: BoxDecoration(
                        color:Color.fromRGBO(220, 220, 220, 1),
                        border: Border.all(
                          style: BorderStyle.none,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        )
                    ),
                    child: Row(
                        children:[
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                            foregroundColor: Colors.white,
                            child: Text(name[0]),
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Spacer(),
                              Text(
                                name,
                                style: TextStyle(
                                  fontFamily: 'Georgia',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                event,
                                style: TextStyle(
                                  color: Color.fromRGBO(107, 114, 128, 1),
                                  fontFamily: 'Georgia',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                          Spacer(),

                           !joined && !personal ?TextButton(
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
                                child: const Text(
                                  'Join',
                                  style: TextStyle(color: Colors.white),
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
                                              .then((doc)=> print("joined"),
                                                onError: (e)=>print("Erorr updating document $e"));

                            },
                          ):
                          TextButton(
                            child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal:10),
                                child: !personal ? const Text(
                                  'Leave',
                                  style: TextStyle(color: Colors.white),
                                ):
                                const Text(
                                  'Remove',
                                  style: TextStyle(color: Colors.white),
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
                                  .then((doc)=> print("left"),
                                  onError: (e)=>print("Erorr updating document $e"),
                              ):
                              cards.doc(cardId).delete()
                                  .then((doc)=> print("Document deleted"),
                                  onError: (e)=> print("Error updating document $e")
                              );
                            },
                          ),
                        ]
                    ),
                  ),
                ),
                Positioned(
                    top: 95.0,
                    left: 80.0,
                    child: Row(
                      children:[
                        usersJoined.length>1 ? CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                          foregroundColor: Colors.white,
                          child: Text(usersJoined[1]["firstName"][0]),
                        ): SizedBox.shrink(),
                         usersJoined.length >2 ? CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                          foregroundColor: Colors.white,
                          child: Text(usersJoined[2]["firstName"][0]),
                        ): SizedBox.shrink(),
                        usersJoined.length >3 ? CircleAvatar(
                          radius: 15,
                          backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                          foregroundColor: Colors.white,
                          child: Text(usersJoined[3]["firstName"][0]),
                        ): SizedBox.shrink(),
                      ]
                    )

                )
              ]
          )
      );
  }
}