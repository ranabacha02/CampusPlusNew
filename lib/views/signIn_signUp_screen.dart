import 'dart:ui';

import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:campus_plus/controller/auth_controller.dart';

import 'package:campus_plus/widgets/app_widgets.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:quickalert/quickalert.dart';

import '../model/app_enums.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  Size size = WidgetsBinding.instance.window.physicalSize /
      WidgetsBinding.instance.window.devicePixelRatio;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  int selectedRadio = 0;
  TextEditingController forgetEmailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  TextEditingController gradYearController = TextEditingController();
  Gender? selectedGender = null;
  Faculty? selectedDepartment = null;

  String dropdownValue = 'Computer and Communication Engineering';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  bool isSignUp = false;

  late AuthController authController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController = Get.put(AuthController());
  }

  @override
  StatefulWidget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.05,
              ),
              Container(
                padding: const EdgeInsets.only(top: 50, bottom: 15),
                child: Icon(
                  Icons.school,
                  color: AppColors.aubRed,
                  size: 70,
                ),
              ),
              Container(
                child: myText(
                    text: 'Campus+',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: AppColors.aubRed,
                      fontWeight: FontWeight.w400,
                    )),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Container(
                padding: EdgeInsets.all(20),
                // decoration: BoxDecoration(
                //   ///  color: Colors.white,
                //     borderRadius: BorderRadius.circular(30),
                //     boxShadow: const [BoxShadow(blurRadius: 10, spreadRadius: 5, color: Colors.black26)]
                // ),

                child: Column(
                  children: [
                    Container(
                      width: Get.width * 0.55,
                      child: TabBar(
                        labelPadding: EdgeInsets.all(Get.height * 0.01),
                        unselectedLabelColor: Colors.grey,
                        labelColor: AppColors.aubRed,
                        indicatorColor: AppColors.aubRed,
                        onTap: (v) {
                          setState(() {
                            isSignUp = !isSignUp;
                            passwordController.clear();
                            emailController.clear();
                          });
                        },
                        tabs: [
                          myText(
                            text: 'Login',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          myText(
                            text: 'Sign Up',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.04,
                    ),
                    Container(
                      width: Get.width,
                      height: Get.height * 0.7,
                      child: Form(
                        key: formKey,
                        child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            LoginWidget(),
                            SignUpWidget(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget LoginWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              buildTextField('E-mail', '', false, emailController,
                  (String input) {
                if (input.isEmpty) {
                  EmailFieldValidator.validate;
                  return 'Email is required.';
                }

                if (!input.contains('@')) {
                  EmailFieldValidator.validate;
                  return 'Email is invalid';
                }
                List<String> x = input.split("@");
                EmailFieldValidator.validate;
                if (x[1] != "mail.aub.edu") {
                  return 'Email should end with @mail.aub.edu';
                }
              }, false),
              buildTextField('Password', "", true, passwordController,
                  (String input) {
                if (input.isEmpty) {
                  PasswordFieldValidator.validate;
                  return 'Password is required.';
                }
                if (input.length < 6) {
                  PasswordFieldValidator.validate;
                  return 'Password should have more than 6 characters.';
                }
                PasswordFieldValidator.validate;
              }, false),
              InkWell(
                onTap: () {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.custom,
                    barrierDismissible: true,
                    confirmBtnText: 'Send E-mail',
                    confirmBtnColor: AppColors.whitegrey,
                    customAsset: 'assets/forgotPassword.gif',
                    widget: TextFormField(
                      decoration: const InputDecoration(
                        alignLabelWithHint: true,
                        hintText: 'Enter your e-mail',
                        prefixIcon: Icon(
                          Icons.group,
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      onChanged: (value) => forgetEmailController.text = value,
                    ),
                    onConfirmBtnTap: () {
                      authController
                          .forgetPassword(forgetEmailController.text.trim());
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Text('Forgot password?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        color: AppColors.black,
                        fontFamily: 'Avenir',
                      )),
                ),
              ),
            ],
          ),
          Obx(() => authController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
            height: Get.width * 0.1,
                  margin: EdgeInsets.symmetric(vertical: Get.height * 0.04),
                  width: Get.width * 0.5,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(AppColors.grey),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0))),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      authController.signIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          context: context);
                    },
                  ),
                )),
          SizedBox(
            height: Get.height * 0.02,
          ),
        ],
      ),
    );
  }

  Widget SignUpWidget() {
    return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                buildTextField('First Name', '', false, firstNameController,
                    (String input) {
                  if (input.removeAllWhitespace.isEmpty) {
                    return 'First name is required';
                  }
                  if (!input.isAlphabetOnly) {
                    return 'First name can only contain letters';
                  }
                  return null;
                }, false),
                buildTextField('Last Name', '', false, lastNameController,
                    (String input) {
                  if (input.removeAllWhitespace.isEmpty) {
                    return 'Last name is required';
                  }
                  if (!input.isAlphabetOnly) {
                    return 'Last name can only contain letters';
                  }
                  return null;
                }, false),
                buildTextField('E-mail', '', false, emailController,
                    (String input) {
                  if (input.isEmpty) {
                    EmailFieldValidator.validate;
                    return 'Email is required.';
                  }

                  if (!input.contains('@')) {
                    EmailFieldValidator.validate;
                    return 'Email is invalid';
                  }
                  List<String> x = input.split("@");
                  EmailFieldValidator.validate;
                  if (x[1] != "mail.aub.edu") {
                    return 'Email should end with @mail.aub.edu';
                  }
                }, false),
                buildTextField('Major', '', false, majorController,
                    (String input) {
                  if (input.removeAllWhitespace.isEmpty) {
                    return 'Major is required';
                  }
                  if (!input.isAlphabetOnly) {
                    return 'Major can only contain letters';
                  }
                  return null;
                }, false),
                buildTextField('Graduation Year', '', false, gradYearController,
                    (String input) {
                  if (input.removeAllWhitespace.isEmpty) {
                    return 'Graduation Year cannot be empty';
                  }
                  if (int.tryParse(input) == null) {
                    return 'Graduation year should be a number';
                  }
                  return null;
                }, false),
                genderDropDownMenu(),
                facultiesDropDownMenu(),
                buildTextField(
                    'Mobile Phone Number', '', false, mobileNumberController,
                    (String input) {
                  if (input.removeAllWhitespace.isEmpty) {
                    return 'Mobile Phone Number is required';
                  }
                  if (int.tryParse(input) == null) {
                    return 'Mobile Phone Number should be a number';
                  }
                  return null;
                }, false),
                buildTextField('Password', "", true, passwordController,
                    (String input) {
                  if (input.isEmpty) {
                    PasswordFieldValidator.validate;
                    return 'Password is required.';
                  }
                  if (input.length < 6) {
                    PasswordFieldValidator.validate;
                    return 'Password should have more than 6 characters.';
                  }
                  PasswordFieldValidator.validate;
                }, false),
                buildTextField(
                    'Verify password', "", true, confirmPasswordController,
                    (String input) {
                  if (input.isEmpty) {
                    PasswordFieldValidator.validate;
                    return 'Please verify your password.';
                  }
                  if (input != passwordController.text) {
                    PasswordFieldValidator.validate;
                    return 'Passwords do not match.';
                  }
                  PasswordFieldValidator.validate;
                }, false),
                Obx(() => authController.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(
                          vertical: Get.height * 0.03,
                        ),
                        width: Get.width * 0.5,
                        child: elevatedButton(
                          text: 'Sign Up',
                          onpress: () async {
                            print("hello world");
                            if (!formKey.currentState!.validate()) {
                              print("failure to sign up");
                              return '';
                            }
                            if (_formKey.currentState!.validate()) {
                              if (selectedGender != null) {
                                if (selectedDepartment != null) {
                                  authController.signUp(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    firstName: firstNameController.text.trim(),
                                    lastName: lastNameController.text.trim(),
                                    mobileNumber: int.parse(
                                        mobileNumberController.text.trim()),
                                    major: majorController.text.trim(),
                                    graduationYear: int.parse(
                                        gradYearController.text.trim()),
                                    gender: selectedGender!.gender,
                                    department:
                                        selectedDepartment!.departmentName,
                                  );
                                } else {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.error,
                                      text: "Please select your department.",
                                      confirmBtnColor: Colors.black38);
                                }
                              } else {
                                QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    text: "Please select your gender.");
                              }
                            }
                          },
                        ),
                      )),
                Container(
                    width: Get.width * 0.8,
                    height: 150,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(children: [
                        TextSpan(
                            text: 'By signing up, you agree to our ',
                            style: TextStyle(
                                color: Color(0xff262628), fontSize: 12)),
                        TextSpan(
                            text: 'terms, data policy and cookies policy.',
                            style: TextStyle(
                                color: Color(0xff262628),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ]),
                    )),
              ],
            )));
  }

  Widget genderDropDownMenu() {
    final List<DropdownMenuItem<Gender>> genderEntries =
        <DropdownMenuItem<Gender>>[];
    for (final Gender gender in Gender.values) {
      genderEntries.add(DropdownMenuItem<Gender>(
        value: gender,
        child: Text(gender.gender),
      ));
    }
    return SizedBox(
        height: 75,
        width: Get.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Gender",
            style: TextStyle(
                fontSize: 14, fontFamily: 'Roboto', color: Colors.black54),
            textAlign: TextAlign.start,
          ),
          DropdownButton<Gender>(
            underline: const Divider(
              thickness: 0.7,
              color: Colors.black54,
              height: 5,
            ),
            // Initial Value
            value: selectedGender,
            style: const TextStyle(
                fontSize: 14, fontFamily: 'Roboto', color: Colors.black54),
            isExpanded: true,
            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: genderEntries,
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (Gender? newValue) {
              setState(() {
                selectedGender = newValue!;
              });
            },
          ),
        ]));
  }

  Widget facultiesDropDownMenu() {
    final List<DropdownMenuItem<Faculty>> facultyEntries =
        <DropdownMenuItem<Faculty>>[];
    for (final Faculty faculty in Faculty.values) {
      facultyEntries.add(DropdownMenuItem<Faculty>(
        value: faculty,
        child: Text(faculty.departmentName),
      ));
    }
    return Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        height: 90,
        width: Get.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Department",
            style: TextStyle(
                fontSize: 14, fontFamily: 'Roboto', color: Colors.black54),
            textAlign: TextAlign.start,
          ),
          DropdownButton<Faculty>(
            underline: const Divider(
              thickness: 0.7,
              color: Colors.black54,
              height: 5,
            ),
            // Initial Value
            value: selectedDepartment,
            style: const TextStyle(
                fontSize: 14, fontFamily: 'Roboto', color: Colors.black54),
            isExpanded: true,
            // Down Arrow Icon
            icon: const Icon(Icons.keyboard_arrow_down),

            // Array list of items
            items: facultyEntries,
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (Faculty? newValue) {
              setState(() {
                selectedDepartment = newValue!;
              });
            },
          ),
        ]));
  }
}
