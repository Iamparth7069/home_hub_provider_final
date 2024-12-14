import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppAssets {
  static const imagePath = "assets/images/";
  static const lottiePath = "assets/lottie/";
  static const svgImagePath = "assets/images/svg/";

  static const loginAnimation = "${lottiePath}login.json";
  static const reistrationAnimation = "${lottiePath}reistration.json";

  static const svgLogo = "${svgImagePath}app_logo.svg";
  static const appLogo = "${imagePath}app_logo.png";
  static const sallerLogo = "${imagePath}saller.png";
  static const registerLogo = "${imagePath}register.png";
  static final _emailregex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final _passregex =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static bool isvalidemail(String email) {
    return _emailregex.hasMatch(email);
  }

  static bool isvalidpassword(String password) {
    return _passregex.hasMatch(password);
  }

  static bool isvalidmobile(String values) {
    if (values.length != 10) {
      values = "'Mobile Number must be of 10 digit'";
      return false;
    } else {
      return true;
    }
  }
}

Widget assetImage(String image,
    {double? height, double? width, Color? color, BoxFit? fit}) {
  return Image.asset(
    image,
    height: height,
    width: width,
    color: color,
    fit: fit ?? BoxFit.contain,
  );
}

AssetImage assetsImage2(String image,
    {double? height, double? width, Color? color}) {
  return AssetImage(image);
}

LottieBuilder assetLottieAnimation({required String path}) {
  return Lottie.asset(path);
}
