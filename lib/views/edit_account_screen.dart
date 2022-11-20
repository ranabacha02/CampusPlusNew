import 'package:campus_plus/controller/edit_profile_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/auth_controller.dart';
import '../controller/data_controller.dart';
import '../utils/app_colors.dart';

class EditAccountScreen extends StatefulWidget {
  final Map<String, dynamic> userInfo;

  EditAccountScreen({required this.userInfo});

  @override
  _EditAccountScreenState createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController graduationYearController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  late AuthController authController;

  //CollectionReference users = FirebaseFirestore.instance.collection('Users');
  FirebaseAuth auth = FirebaseAuth.instance;
  late EditProfileController editProfileController;

  late DataController dataController;
  late final userInfo;
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
    firstNameController.text = userInfo["firstName"];
    lastNameController.text = userInfo["lastName"];
    majorController.text = userInfo["major"];
    graduationYearController.text = userInfo["graduationYear"].toString();
    mobileNumberController.text = userInfo["mobilePhoneNumber"].toString();
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
                fontSize: 20,
              ),
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
          title: Text(
            "Edit Profile",
            style: TextStyle(
              fontSize: 25,
              color: AppColors.aubRed,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Done",
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 20,
                ),
              ),
              onPressed: () => {
                editProfileController.updateProfile(
                  firstName: firstNameController.text.trim(),
                  lastName: lastNameController.text.trim(),
                  major: majorController.text.trim(),
                  graduationYear:
                      int.parse(graduationYearController.text.trim()),
                  mobileNumber: int.parse(mobileNumberController.text.trim()),
                  context: context,
                  userInfo: userInfo,
                )
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
                Text(
                  "Edit Profile",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  "https://images.pexels.com/photos/3307758/pexels-photo-3307758.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=250",
                                ))),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Colors.green,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                buildTextField("First Name", "", false, firstNameController,
                    (String input) {}),
                buildTextField("Last Name", "", false, lastNameController,
                    (String input) {}),
                buildTextField(
                    "Major", "", false, majorController, (String input) {}),
                buildTextField(
                    "Graduation Year", "", false, graduationYearController,
                    (String input) {
                  print("hello i'm here");
                  if (int.tryParse(input) == null) {
                    print("only number");
                    Get.snackbar('Warning', 'Only numbers allowed',
                        colorText: Colors.white, backgroundColor: Colors.blue);
                    return '';
                  } else {
                    int gradYear = int.parse(input);
                    int currentYear = DateTime.now().year;
                    print(currentYear);
                    if (gradYear < currentYear) {
                      Get.snackbar(
                          'Warning', 'Graduation year cannot be in the past.',
                          colorText: Colors.white,
                          backgroundColor: Colors.blue);
                      return '';
                    }
                  }
                }),
                buildTextField(
                    "Mobile Number", "", false, mobileNumberController,
                    (String input) {
                  if (int.tryParse(input) == null) {
                    Get.snackbar('Warning', 'Only numbers allowed',
                        colorText: Colors.white, backgroundColor: Colors.blue);
                    return '';
                  }
                }),
                SizedBox(
                  height: 35,
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildTextField(
      String labelText,
      String placeholder,
      bool isPasswordTextField,
      TextEditingController controller,
      Function? validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        validator: (input) => validator!(input),
        controller: controller,
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
