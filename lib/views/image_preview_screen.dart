import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../utils/app_colors.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imageUrl;
  final String caption;
  final String position;

  const ImagePreviewScreen(
      {required this.imageUrl, required this.caption, required this.position});

  _ImagePreviewScreentState createState() => _ImagePreviewScreentState();
}

class _ImagePreviewScreentState extends State<ImagePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    print("i am here");
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.position == "top" ? widget.caption : "",
          style: TextStyle(
            fontSize: 24,
            color: AppColors.black,
          ),
        ),
      ),
      body: Stack(alignment: Alignment.bottomLeft, children: [
        Container(
          padding: const EdgeInsets.only(bottom: 20),
          alignment: Alignment.center,
          child: Image(
            image: CachedNetworkImageProvider(widget.imageUrl),
          ),
        ),
        Container(
            color: AppColors.white,
            width: Get.width,
            padding: const EdgeInsets.only(bottom: 50, top: 20),
            child: Text(
              widget.position == "bottom" ? widget.caption : "",
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.black,
              ),
            )),
      ]),
      // bottomNavigationBar: Container(
      //  color: AppColors.whitegrey,
      //   width: Get.width*0.4,
      //   padding: const EdgeInsets.only(bottom: 50, left: 20),
      //     child: Text(
      //       widget.position == "bottom" ? widget.caption : "",
      //       style: TextStyle(
      //         fontSize: 18,
      //         color: AppColors.black,
      //       ),
      //     )),
    );
  }
}
