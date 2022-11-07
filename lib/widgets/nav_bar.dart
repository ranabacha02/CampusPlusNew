
import 'package:campus_plus/utils/app_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:campus_plus/views/home_screen.dart';
import 'package:campus_plus/views/tutoring_section_screen.dart';
import 'package:campus_plus/views/rental_section_screen.dart';
import 'package:campus_plus/views/messaging_section_screen.dart';
import 'package:campus_plus/views/profile_screen.dart';

class NavBarView extends StatefulWidget {
  NavBarView({Key? key}) : super(key: key);

  @override
  State<NavBarView> createState() => _NavBarViewState();
}

class _NavBarViewState extends State<NavBarView> {
  int currentIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  List<Widget> widgetOption = [
    RentalSectionScreen(),
    TutoringSectionScreen(),
    HomeScreen(),
    MessagingSectionScreen(),
    ProfileScreen()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get.put(DataController(),permanent: true);
    // FirebaseMessaging.instance.getInitialMessage();
    // FirebaseMessaging.onMessage.listen((message) {
    //   LocalNotificationService.display(message);
    // });
    //
    // LocalNotificationService.storeToken();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          height: 100,
          child: BottomNavigationBar(
            onTap: onItemTapped,
            selectedItemColor: Colors.black,
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                      currentIndex == 0
                          ? 'assets/RentIconPressed.png'
                          : 'assets/RentIconNotPressed.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                      currentIndex == 1
                          ? 'assets/TutorIconPressed.png'
                          : 'assets/TutorIconNotPressed.png',
                      width: 45,
                      height: 45,
                    ),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                        currentIndex == 2
                            ? 'assets/HomeIconPressed.png'
                            : 'assets/HomeIconNotPressed.png',
                        width: 35,
                        height: 35),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                        currentIndex == 3
                            ? 'assets/ChatIconPressed.png'
                            : 'assets/ChatIconNotPressed.png',
                        width: 35,
                        height: 35),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                      currentIndex == 4
                          ? 'assets/ProfileIconPressed.png'
                          : 'assets/ProfileIconNotPressed.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  label: ''),
            ],
          ),
        ),
        body: widgetOption[currentIndex]);
  }
}
