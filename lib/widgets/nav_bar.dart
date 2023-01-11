
import 'package:campus_plus/utils/app_colors.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:campus_plus/views/home_screen.dart';
import 'package:campus_plus/views/tutoring_section_screen.dart';
import 'package:campus_plus/views/rental_section_screen.dart';
import 'package:campus_plus/views/messaging_section_screen.dart';
import 'package:campus_plus/views/profile_screen.dart';


import '../controller/data_controller.dart';

class NavBarView extends StatefulWidget {
  int index;

  NavBarView({Key? key, required int this.index}) : super(key: key);

  @override
  State<NavBarView> createState() => _NavBarViewState(currentIndex: index);
}

class _NavBarViewState extends State<NavBarView> {
  int currentIndex = 0;

  _NavBarViewState({required int this.currentIndex});

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
  late DataController dataController;
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
    dataController = Get.put(DataController());
    dataController.getUserInfo();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          height: 80,
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
                      width: 20,
                      height: 20,
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
                      width: 20,
                      height: 20,
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
                        width: 20,
                        height: 20),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                        currentIndex == 3
                            ? 'assets/ChatIconPressed.png'
                            : 'assets/ChatIconNotPressed.png',
                        width: 20,
                        height: 20),
                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Image.asset(
                      currentIndex == 4
                          ? 'assets/ProfileIconPressed.png'
                          : 'assets/ProfileIconNotPressed.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                  label: ''),
            ],
          ),
        ),
        body: widgetOption[currentIndex]);
  }
}
