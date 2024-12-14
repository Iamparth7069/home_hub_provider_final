import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../LocalStorage/StorageClass.dart';
import '../../../Routes/Routes.dart';

class SplashScreenController extends GetxController {

  String displayText = '';
  int index = 0;
  final StorageService _storageService = StorageService();
  final String _fullText = 'Help Harbor';

  @override
  void onInit() {
    super.onInit();
    _startTyping();
    _navigate();
  }

  void _navigate() {
    Future.delayed(const Duration(seconds: 3)).then(
      (value) async {

        // if(_storageService.getLoginStatus()){
        //     Get.offAllNamed(Routes.loginScreen);
        // }else{
        //     Get.offAllNamed(Routes.loginScreen);
        // }

        if(_storageService.getLoginStatus()){
          Get.offAllNamed(Routes.navbarRoots);
        }else if(_storageService.getRegisterStatus()){
          if(_storageService.getProfileDataStatus()){
            Get.offAllNamed(Routes.loginScreen);
          }else{
            Get.offAllNamed(Routes.registerDetails);
          }
        }else{
          Get.offAllNamed(Routes.loginScreen);
        }
        // if(_storageService.getRegisterStatus()){
        //   if(_storageService.getProfileDataStatus()){
        //     Get.offAllNamed(Routes.loginScreen);
        //   }else{
        //     Get.offAllNamed(Routes.registerDetails) ;
        //   }
        // }else if(_storageService.getLoginStatus()){
        //
        // }
        // if(_storageService.getLoginStatus()){
        //   Get.offAllNamed(Routes.checkBiometric);
        // }else if(_storageService.getRegisterStatus()){
        //   Get.offAllNamed(Routes.loginScreen);
        // }else{
        //   Get.offAllNamed(Routes.loginScreen);
        // }
       },
     );
  }

  void _startTyping() {
    const typingInterval = Duration(milliseconds: 200);

    Timer.periodic(typingInterval, (Timer timer) {
      if (index < _fullText.length) {
        displayText = _fullText.substring(0, index + 1);
        index++;
        update();
      } else {
        timer.cancel();
      }
    });
  }
}
