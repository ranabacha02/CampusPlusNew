import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class UserProfilePicture extends StatefulWidget {
  final String? imageURL;

  const UserProfilePicture({
    Key? key,
    required this.imageURL,
  }) : super(key: key);

  @override
  _UserProfilePictureState createState() => _UserProfilePictureState();
}

class _UserProfilePictureState extends State<UserProfilePicture> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(.3),
              offset: Offset(0, 2),
              blurRadius: 5)
        ],
      ),
      child: CircleAvatar(
        // to be changed
        backgroundImage: widget.imageURL != null
            ? NetworkImage(widget.imageURL!)
            : AssetImage("assets/default_profile.jpg") as ImageProvider,
        radius: 50,
        backgroundColor: AppColors.circle,
        foregroundColor: AppColors.white,
      ),
    );
  }
}
