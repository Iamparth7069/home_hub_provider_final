import 'package:flutter/animation.dart';
import 'package:get/get.dart';


import '../../Home/screen/Home_Screen.dart';
import '../../Message/screen/MessageScreen.dart';
import '../../Schedule/Screen/Schedule_Screen.dart';
import '../../SettingScreen/screen/SettingScreen.dart';


class NavbarController extends GetxController{
  RxInt selectedIndex = 0.obs;

  final screens = [
    HomeScreen(),
    MessageScreen(),
    OrderHistory(),
    SettingScreen(),
  ].obs;

}
