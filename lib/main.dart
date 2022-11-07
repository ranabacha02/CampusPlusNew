import 'package:campus_plus/views/signIn_signUp_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(CampusPlus());
}

class CampusPlus extends StatefulWidget {
  @override
  State<CampusPlus> createState() => _CampusPlusState();

}

class _CampusPlusState extends State<CampusPlus>{
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Campus+',
        theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
        Theme.of(context).textTheme, // If this is not set, then ThemeData.light().textTheme is used.
    ),
    ),
    home:  LoginView(),
    );
  }

}

