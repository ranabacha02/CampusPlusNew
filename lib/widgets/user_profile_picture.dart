import 'package:cached_network_image/cached_network_image.dart';
import 'package:campus_plus/views/image_preview_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../views/user_info_screen.dart';

class UserProfilePicture extends StatefulWidget {
  final String? imageURL;
  final String caption;
  final double radius;
  bool preview;
  String userId;

  UserProfilePicture({
    Key? key,
    required this.imageURL,
    required this.caption,
    required this.radius,
    bool? preview,
    String? userId,
  })  : this.preview = preview != null ? preview : true,
        this.userId = userId ?? "",
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
        else if(widget.userId.isNotEmpty){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return UserInfoScreen(userId: widget.userId);
          }));
        }
      },
      child: CircleAvatar(
        // to be changed
        backgroundImage: widget.imageURL != null && widget.imageURL != ""
            ? CachedNetworkImageProvider(widget.imageURL!)
            : const AssetImage("assets/default_profile.jpg") as ImageProvider,
        radius: widget.radius,
        backgroundColor: AppColors.circle,
        foregroundColor: AppColors.white,
      ),
    );
  }
}
