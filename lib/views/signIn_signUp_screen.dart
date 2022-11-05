import 'dart:ui';

import 'package:campus_plus/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_plus/controller/auth_controller.dart';

import 'package:campus_plus/widgets/app_widgets.dart';
import 'package:campus_plus/utils/app_colors.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {


  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  int selectedRadio = 0;
  TextEditingController forgetEmailController = TextEditingController();

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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.aubRed,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Image.asset(
                    'assets/campus_logo.png',
                    height: 80,
                  width: 80,
                ),
                SizedBox(
                  height: Get.height * 0,
                ),
                Container(
                  child: myText(
                    text:
                    'Campus+',
                    // style: GoogleFonts.roboto(
                    //   letterSpacing: 0,
                    //   fontSize: 35,
                    //   fontWeight: FontWeight.w400,
                    // ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40,
                      color: AppColors.white,
                      fontWeight: FontWeight.w400,
                    )
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Container(
                  width: Get.width * 0.55,
                  child: TabBar(
                    labelPadding: EdgeInsets.all(Get.height * 0.01),
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.white,
                    indicatorColor: Colors.white,
                    onTap: (v) {
                      setState(() {
                        isSignUp = !isSignUp;
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget LoginWidget(){
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              myTextField(
                  bool: false,
                  icon: 'assets/userIcon.png',
                  text: 'E-mail',
                  validator: (String input){
                    if(input.isEmpty){
                      Get.snackbar('Warning', 'Email is required.',colorText: Colors.white,backgroundColor: Colors.blue);
                      return '';
                    }

                    if(!input.contains('@')){
                      Get.snackbar('Warning', 'Email is invalid.',colorText: Colors.white,backgroundColor: Colors.blue);
                      return '';
                    }
                  },
                  controller: emailController
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              myTextField(
                  bool: true,
                  icon: 'assets/passwordIcon.png',
                  text: 'password',
                  validator: (String input){
                    if(input.isEmpty){
                      Get.snackbar('Warning', 'Password is required.',colorText: Colors.white,backgroundColor: Colors.blue);
                      return '';
                    }

                    if(input.length <6){
                      Get.snackbar('Warning', 'Password should be 6+ characters.',colorText: Colors.white,backgroundColor: Colors.blue);
                      return '';
                    }
                  },
                  controller: passwordController
              ),
              InkWell(
                onTap: () {
                  Get.defaultDialog(
                      title: 'Forget Password?',
                      content: Container(
                        width: Get.width,
                        child: Column(
                          children: [
                            myTextField(
                                bool: false,
                                icon: 'assets/passwordIcon.png',
                                text: 'enter your email...',
                                controller: forgetEmailController
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            MaterialButton(
                              color: Colors.blue,
                              onPressed: (){
                                authController.forgetPassword(forgetEmailController.text.trim());
                              },child: Text("Sent"),minWidth: double.infinity,)

                          ],
                        ),
                      )
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: Get.height * 0.02,
                  ),
                  child: myText(
                      text: 'Forgot password?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                        color: AppColors.black,
                      )),
                ),
              ),
            ],
          ),
          Obx(()=> authController.isLoading.value? Center(child: CircularProgressIndicator(),) :Container(
            height: 50,
            margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.04),
            width: Get.width,
            child: elevatedButton(
              text: 'Login',
              onpress: () {

                if(!formKey.currentState!.validate()){
                  return;
                }

                authController.login(email: emailController.text.trim(),password: passwordController.text.trim());


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

  Widget SignUpWidget(){
    return SingleChildScrollView(
        child: Column(
          children: [
            myTextField(
              bool: false,
              text: 'First Name',
              icon: 'assets/userIcon.png',
              validator: (String input){
                //return '';
              },
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            myTextField(
              bool: false,
              text: 'Last Name',
              icon: 'assets/userIcon.png',
              validator: (String input){
                //return '';
              },
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            myTextField(
                bool: false,
                icon: 'assets/userIcon.png',
                text: 'E-mail',
                validator: (String input){
                  if(input.isEmpty){
                    Get.snackbar('Warning', 'E-mail is required.',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }

                  if(!input.contains('@')){
                    Get.snackbar('Warning', 'E-mail is invalid.',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }
                },
                controller: emailController
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            myTextField(
              bool: false,
              text: 'Major',
              icon: 'assets/userIcon.png',
              validator: (String input){
                //return '';
              },
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            myTextField(
              bool: false,
              text: 'Year Level',
              icon: 'assets/userIcon.png',
              validator: (String input){
               // return '';
              },
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            myTextField(
              bool: false,
              text: 'Mobile Phone Number',
              icon: 'assets/userIcon.png',
              validator: (String input){
              //  return '';
              },
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            myTextField(
                bool: true,
                icon: 'assets/passwordIcon.png',
                text: 'Password',
                validator: (String input){
                  if(input.isEmpty){
                    Get.snackbar('Warning', 'Password is required.',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }

                  if(input.length <6){
                    Get.snackbar('Warning', 'Password should be 6+ characters.',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }
                },
                controller: passwordController
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            myTextField(
                bool: true,
                icon: 'assets/passwordIcon.png',
                text: 'Re-enter your password',
                validator: (input){
                  if(input != passwordController.text.trim()){
                    Get.snackbar('Warning', 'Confirm Password is not same as password.',colorText: Colors.white,backgroundColor: Colors.blue);
                    return '';
                  }
                },
                controller: confirmPasswordController
            ),
            Obx(()=> authController.isLoading.value? Center(child: CircularProgressIndicator(),) : Container(
              height: 40,
              margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.03,
              ),
              width: Get.width,
              child: elevatedButton(
                text: 'Sign Up',
                onpress: () {
                  print("hello world");
                  if(!formKey.currentState!.validate()){
                    print("failure to sign up");
                    return '';
                  }
                  authController.signUp(email: emailController.text.trim(),password: passwordController.text.trim());
                },
              ),
            )),
          SizedBox(
              height: Get.height * 0.005,
            ),
            Container(
                width: Get.width * 0.8,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                        text:
                        'By signing up, you agree to our ',
                        style: TextStyle(
                            color: Color(0xff262628),
                            fontSize: 12)),
                    TextSpan(
                        text:
                        'terms, data policy and cookies policy.',
                        style: TextStyle(
                            color: Color(0xff262628),
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ]),
                )),
          ],
        )

    );
  }

}