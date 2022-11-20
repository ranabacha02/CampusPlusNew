import 'package:campus_plus/views/signIn_signUp_screen.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs =await SharedPreferences.getInstance();
  var email=prefs.getString("email");
  runApp(CampusPlus(email: email,));
}

class CampusPlus extends StatefulWidget {
  final String? email;
  const CampusPlus ({ Key? key, this.email }): super(key: key);
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
    home:  widget.email==null?LoginView():NavBarView(),
    );
  }

}

