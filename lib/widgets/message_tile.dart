import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool privateChat;
  final String time;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.privateChat,
    required this.time,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    String displayName = widget.sender.split("_")[0];
    return Container(
        padding: EdgeInsets.only(top: 4, bottom: 4, left: 24, right: 0),
        alignment: Alignment.centerLeft,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.only(top: 4, bottom: 4, left: 0, right: 24),
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(left: 30),
                  padding: const EdgeInsets.only(
                      top: 12, bottom: 12, left: 12, right: 12),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(widget.message,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)),
                      Text(widget.time,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white54)),
                    ],
                  ),
                ),
              ),
            ]));
  }
}
