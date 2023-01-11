import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_plus/views/image_preview_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class UserProfilePicture extends StatefulWidget {
  final String? imageURL;
  final String caption;
  final double radius;
  bool preview;

  UserProfilePicture({
    Key? key,
    required this.imageURL,
    required this.caption,
    required this.radius,
    bool? preview,
  })  : this.preview = preview != null ? preview : true,
        super(key: key);

  @override
  _UserProfilePictureState createState() => _UserProfilePictureState();
}

class _UserProfilePictureState extends State<UserProfilePicture> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return GestureDetector(
      onTap: () {
        if (widget.preview && widget.imageURL != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ImagePreviewScreen(
              imageUrl: widget.imageURL!,
              caption: widget.caption,
              position: "top",
            );
          }));
        }
      },
      child: CircleAvatar(
        // to be changed
        backgroundImage: widget.imageURL != null
            ? CachedNetworkImageProvider(widget.imageURL!)
            : AssetImage("assets/default_profile.jpg") as ImageProvider,
        radius: widget.radius,
        backgroundColor: AppColors.circle,
        foregroundColor: AppColors.white,
      ),
    );
  }
}
