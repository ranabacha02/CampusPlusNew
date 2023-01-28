import 'package:campus_plus/views/home_screen.dart';
import 'package:campus_plus/views/signIn_signUp_screen.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'controller/data_controller.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.remove("email");
  var email = prefs.getString("email");
  DataController dataController = Get.put(DataController());
  FirebaseAuth auth = FirebaseAuth.instance;
  if (email != null) {
    prefs.printInfo();
    print(email);
    print(auth.currentUser);
    // print("email not null");
    await dataController.getUserInfo();
  }
  runApp(CampusPlus(
    email: email,
  ));

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
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
      ),
      home: widget.email == null
          ? LoginView()
          : NavBarView(
              index: 2,
            ),
    );
  }

}









