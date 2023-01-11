import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../views/image_preview_screen.dart';

class ReceivedMessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool privateChat;
  final bool sameSender;
  final String time;
  final String type;
  String? imageUrl;

  ReceivedMessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.privateChat,
    required this.sameSender,
    required this.time,
    required this.type,
    String? imageUrl,
  })  : this.imageUrl = imageUrl,
        super(key: key);

  @override
  State<ReceivedMessageTile> createState() => _ReceivedMessageTileState();
}

class _ReceivedMessageTileState extends State<ReceivedMessageTile> {
  @override
  Widget build(BuildContext context) {
    String displayName = widget.sender.split("_")[0];
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 24, right: 0),
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !widget.privateChat && !widget.sameSender
              ? Text(
            displayName.toUpperCase(),
            textAlign: TextAlign.start,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                letterSpacing: -0.5),
          )
              : SizedBox(
            height: 0,
          ),
          Container(
            margin: const EdgeInsets.only(right: 30),
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.grey[700]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                widget.type == "image"
                    ? GestureDetector(
                        child: Image(
                            image: CachedNetworkImageProvider(widget.imageUrl)),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ImagePreviewScreen(
                                imageUrl: widget.imageUrl!,
                                caption: widget.message,
                                position: "bottom");
                          }));
                        },
                      )
                    : SizedBox(
                        height: 0,
                      ),
                Text(widget.message,
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 16, color: Colors.white)),
                Text(widget.time,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 12, color: Colors.white54))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
