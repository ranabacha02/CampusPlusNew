import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  const MainCard({
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
                          // color: Colors.black,
                          // width: 4.0,
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
                          TextButton(
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
                            onPressed:(){},
                          )
                        ]
                    ),
                  ),
                ),
                Positioned(
                    top: 95.0,
                    left: 80.0,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Color.fromRGBO(144, 0, 49, 1),
                      foregroundColor: Colors.white,
                      child: Text(name[0]),
                    )
                )
              ]
          )
      );
  }
}