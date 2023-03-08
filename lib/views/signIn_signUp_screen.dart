import 'dart:ui';

import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:campus_plus/controller/auth_controller.dart';

import 'package:campus_plus/widgets/app_widgets.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:quickalert/quickalert.dart';

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
          physics: NeverScrollableScrollPhysics(),
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
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          myText(
                            text: 'Sign Up',
                            style: TextStyle(
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
                  // Get.defaultDialog(
                  //     title: 'Forget Password?',
                  //     content: Container(
                  //       width: Get.width,
                  //       child: Column(
                  //         children: [
                  //           myTextField(
                  //               bool: false,
                  //               icon: 'assets/passwordIcon.png',
                  //               text: 'Enter your email...',
                  //               controller: forgetEmailController),
                  //           SizedBox(
                  //             height: 10,
                  //           ),
                  //           MaterialButton(
                  //             color: Colors.blue,
                  //             onPressed: () {
                  //               authController.forgetPassword(
                  //                   forgetEmailController.text.trim());
                  //             },
                  //             child: Text("Sent"),
                  //             minWidth: double.infinity,
                  //           )
                  //         ],
                  //       ),
                  //     ));
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
                buildTextField(
                    'Mobile Phone Number', '', false, majorController,
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
                              authController.signUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                                firstName: firstNameController.text.trim(),
                                lastName: lastNameController.text.trim(),
                                mobileNumber: int.parse(
                                    mobileNumberController.text.trim()),
                                major: majorController.text.trim(),
                                graduationYear:
                                    int.parse(gradYearController.text.trim()),
                              );
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
}
