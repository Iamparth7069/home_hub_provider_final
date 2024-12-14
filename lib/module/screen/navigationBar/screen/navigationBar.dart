import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/app_color.dart';
import '../controller/navigationBar_Controller.dart';


class NavBarRoot extends StatelessWidget {

  NavbarController _navbarController = Get.put(NavbarController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      body: Obx(() {
        return _navbarController.screens[_navbarController.selectedIndex.value];
      },),
      bottomNavigationBar: Obx(
            () {
          return  BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xFF2D33A6),
            unselectedItemColor: Colors.black26,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            currentIndex: _navbarController.selectedIndex.value,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chat_bubble_text_fill), label: "Messages"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: "Schedule"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Settings"),
            ],
            onTap: (index) {
              _navbarController.selectedIndex.value = index;
            },
          );
        },
      ),
    );
  }

}

