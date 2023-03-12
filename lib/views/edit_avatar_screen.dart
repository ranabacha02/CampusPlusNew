import 'dart:core';
import 'dart:io';

import 'package:campus_plus/controller/edit_profile_controller.dart';
import 'package:campus_plus/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:page_transition/page_transition.dart';

import '../controller/auth_controller.dart';
import '../controller/data_controller.dart';
import '../widgets/avatar_image_file_picker.dart';
import '../widgets/image_file_picker.dart';
import '../utils/app_colors.dart';
import '../widgets/nav_bar.dart';
import 'package:random_avatar/random_avatar.dart';

class EditAvatarScreen extends StatefulWidget {
  final MyUser userInfo;
  bool deleteavatar;
  File? avatarphoto;
  Image? displayAvatarImage;




  EditAvatarScreen({required this.userInfo,
    required this.deleteavatar,
    this.avatarphoto,
    this.displayAvatarImage});

  @override
  _EditAvatarScreenState createState() => _EditAvatarScreenState(
      deleteavatar: deleteavatar, avatarphoto: avatarphoto, displayAvatarImage: displayAvatarImage);
}

class _EditAvatarScreenState extends State<EditAvatarScreen> {
  final _formKey = GlobalKey<FormState>();

  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController graduationYearController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();

  
  late AuthController authController;

  //CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  late EditProfileController editProfileController;

  Image? displayAvatarImage;
  File? avatarphoto;
  bool deleteavatar;

  _EditAvatarScreenState({required this.deleteavatar, this.avatarphoto, this.displayAvatarImage});

  late DataController dataController;
  late MyUser userInfo;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    editProfileController = Get.put(EditProfileController());
    authController = Get.put(AuthController());
    dataController = Get.put(DataController());
    userInfo = dataController.getLocalData();
  }

  @override
  Widget build(BuildContext context) {
    firstNameController.text = userInfo.firstName;
    lastNameController.text = userInfo.lastName;
    majorController.text = userInfo.major;
    graduationYearController.text = userInfo.graduationYear.toString();
    mobileNumberController.text = userInfo.mobilePhoneNumber.toString();
    descriptionController.text = userInfo.description.toString();
    nicknameController.text = userInfo.nickname;
    displayAvatarImage ??= Image.asset("assets/default_profile.jpg");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          automaticallyImplyLeading: false,
          centerTitle: false,
          elevation: 0.2,
          leadingWidth: 100,
          titleSpacing: 55,
          leading: TextButton(
            child: Text(
              "Cancel",
              style: TextStyle(
                color: AppColors.black,
                fontSize: 15,
              ),
            ),
            onPressed: () => {
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.topToBottomPop,
                      child: NavBarView(index: 4),
                      childCurrent: EditAvatarScreen(
                        userInfo: userInfo,
                        deleteavatar: false,
                        displayAvatarImage: avatarphoto == null ? null : Image.file(avatarphoto!),
                      )))
            },
          ),
          title: Text(
            "Edit Avatar",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.aubRed,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Done",
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 15,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  dataController.updateAvatar(
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    major: majorController.text.trim(),
                    graduationYear:
                    int.parse(graduationYearController.text.trim()),
                    mobilePhoneNumber:
                    int.parse(mobileNumberController.text.trim()),
                    description: descriptionController.text.trim(),
                    nickname: nicknameController.text.trim(),
                    avatarphoto: avatarphoto,
                    deleteavatar: false, context2: context,
                  );
                }
              },
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                const Text(
                  "Edit Avatar",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      AvatarImageUploads(displayAvatarImage: displayAvatarImage),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildTextField(
                          "Nickname", "", false, nicknameController,
                              (String input) {
                            if (input.removeAllWhitespace == "") {
                              return "First name cannot be empty";
                            }
                            if (!input.isAlphabetOnly) {
                              return 'First name can only contains letters';
                            }
                            return null;
                          }, false),
                      // To do: check the input and make sure it's one of the options
                    ],
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildTextField(String labelText,
      String placeholder,
      bool isPasswordTextField,
      TextEditingController controller,
      Function? validator,
      bool expandable,
      {int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        validator: (input) => validator!(input),
        controller: controller,
        maxLength: maxLength,
        maxLines: expandable ? null : 1,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }


}
