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
import '../widgets/image_file_picker.dart';
import '../utils/app_colors.dart';
import '../widgets/nav_bar.dart';

class EditAccountScreen extends StatefulWidget {
  final MyUser userInfo;
  bool delete;
  File? photo;
  Image? displayImage;


  EditAccountScreen({required this.userInfo,
    required this.delete,
    this.photo,
    this.displayImage});

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState(
      delete: delete, photo: photo, displayImage: displayImage);
}

class _EditAccountScreenState extends State<EditAccountScreen> {
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

  Image? displayImage;
  File? photo;
  bool delete;

  _EditAccountScreenState({required this.delete, this.photo, this.displayImage});

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
    nicknameController.text = userInfo.nickname.toString();

    displayImage ??= Image.asset("assets/default_profile.jpg");

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
                      childCurrent: EditAccountScreen(
                        userInfo: userInfo,
                        delete: false,
                        displayImage: photo == null ? null : Image.file(photo!),
                      )))
            },
          ),
          title: Text(
            "Edit Profile",
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
                  dataController.updateProfile(
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    major: majorController.text.trim(),
                    graduationYear:
                        int.parse(graduationYearController.text.trim()),
                    mobilePhoneNumber:
                        int.parse(mobileNumberController.text.trim()),
                    context: context,
                    photo: photo,
                    delete: false,
                    description: descriptionController.text.trim(),
                    nickname: nicknameController.text.trim(),
                  )
                  ;
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
                  "Edit Profile",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      ImageUploads(displayImage: displayImage),
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
                          "First Name", "", false, firstNameController,
                          (String input) {
                        if (input.removeAllWhitespace == "") {
                          return "First name cannot be empty";
                        }
                        if (!input.isAlphabetOnly) {
                          return 'First name can only contains letters';
                        }
                        return null;
                      }, false),
                      buildTextField("Last Name", "", false, lastNameController,
                          (String input) {
                        if (input.removeAllWhitespace == "") {
                          return "Last name cannot be empty";
                        }
                        if (!input.isAlphabetOnly) {
                          return 'Last name can only contains letters';
                        }
                        return null;
                      }, false),
                      buildTextField("Major", "", false, majorController,
                          (String input) {
                        if (input.removeAllWhitespace == "") {
                          return "Major cannot be empty";
                        }
                        if (!input.isAlphabetOnly) {
                          return 'Major can only contains letters';
                        }
                        return null;
                      }, false),
                      // To do: check the input and make sure it's one of the options
                      buildTextField("Graduation Year", "", false,
                          graduationYearController, (String input) {
                        if (input.removeAllWhitespace == "") {
                          return "Graduation year cannot be empty";
                        }
                        if (int.tryParse(input) == null) {
                          return 'Invalid format. Please enter only numbers';
                        } else {
                          int gradYear = int.parse(input);
                          int currentYear = DateTime.now().year;
                          if (gradYear < currentYear) {
                            return 'Graduation year cannot be in the past.';
                          }
                          return null;
                        }
                      }, false),
                      buildTextField(
                          "Mobile Number", "", false, mobileNumberController,
                          (String input) {
                        if (input.removeAllWhitespace == "") {
                          return "Mobile phone number cannot be empty";
                        }
                        if (int.tryParse(input) == null) {
                          return 'Invalid format. Please enter only numbers';
                        }
                        return null;
                      }, false),
                      buildTextField(
                          "Description",
                          "",
                          false,
                          descriptionController,
                          (String input) {},
                          maxLength: 150,
                          true),
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
