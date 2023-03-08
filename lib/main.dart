import 'package:campus_plus/localStorage/realm/realm_firestore_syncing.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:campus_plus/utils/app_colors.dart';
import 'package:campus_plus/views/chat_page_screen.dart';
import 'package:campus_plus/views/home_screen.dart';
import 'package:campus_plus/views/notifications.dart';
import 'package:campus_plus/views/signIn_signUp_screen.dart';
import 'package:campus_plus/views/signIn_signUp_screen_updated.dart';
import 'package:campus_plus/widgets/nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'controller/data_controller.dart';
import 'controller/notification_controller.dart';
import 'firebase_options.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() async {
  await NotificationController.initializeLocalNotifications();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //prefs.remove("email");
  var email = prefs.getString("email");
  DataController dataController = Get.put(DataController());
  FirebaseAuth auth = FirebaseAuth.instance;
  if (email != null) {
    prefs.printInfo();
    print(email);
    print(auth.currentUser);
    realmSyncing(auth.currentUser!.uid);
    await dataController.getUserInfo();
  }
  runApp(CampusPlus(
    email: email,
  ));
}

class CampusPlus extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  final String? email;

  const CampusPlus({Key? key, this.email}) : super(key: key);

  @override
  State<CampusPlus> createState() => _CampusPlusState();
}

class _CampusPlusState extends State<CampusPlus> {
  static const String routeHome = '/', routeNotification = '/notification-page';

  @override
  void initState() {
    NotificationController.startListeningNotificationEvents();
    super.initState();
  }

  List<Route<dynamic>> onGenerateInitialRoutes(String initialRouteName) {
    List<Route<dynamic>> pageStack = [];
    pageStack.add(MaterialPageRoute(
        builder: (_) => widget.email == null
            ? LoginView()
            : NavBarView(
                index: 2,
              )));
    if (initialRouteName == routeNotification &&
        NotificationController.initialAction != null) {
      pageStack.add(MaterialPageRoute(
          builder: (_) => NavBarView(
                index: 3,
              )));
    }
    return pageStack;
  }

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return MaterialPageRoute(
            builder: (_) => widget.email == null
                ? LoginView()
                : NavBarView(
                    index: 2,
                  ));

      case routeNotification:
        ReceivedAction receivedAction = settings.arguments as ReceivedAction;
        return MaterialPageRoute(
            builder: (_) => ChatPageScreen(
                //refreshCourses: widget.refreshCourses,
                chatId: receivedAction.payload!["chatId"]!,
                chatName: receivedAction.payload!["sender"]!,
                privateChat: receivedAction.payload!["isGroup"]! == "true",
                imageURL: receivedAction.payload!["chatIcon"]!));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Campus+',
      navigatorKey: CampusPlus.navigatorKey,

      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onGenerateRoute: onGenerateRoute,
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context)
              .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
        ),
        focusColor: AppColors.aubRed,
        colorScheme: ColorScheme.light(primary: AppColors.aubRed),
      ),
      // home: widget.email == null
      //     ? LoginView()
      //     : NavBarView(
      //   index: 2,
      // ),
    );
  }

}









