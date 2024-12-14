import 'package:get/get_navigation/src/routes/get_route.dart';

import '../module/screen/Home/screen/Home_Screen.dart';
import '../module/screen/Login/LoginScreen.dart';
import '../module/screen/ManageServices/AddServices/Screen/Addservices.dart';
import '../module/screen/ManageServices/ServicesInfo/Screen/servicesInfo.dart';
import '../module/screen/ManageServices/UpdateServices/Screen/update.dart';
import '../module/screen/ManageServices/deniedServices/Screen/deletedServices.dart';
import '../module/screen/OrderList/Screen/newordercode.dart';
import '../module/screen/Register/RegisterScreen.dart';
import '../module/screen/RegisterDetails/screen/RegisterDetailsUser.dart';
import '../module/screen/Schedule/Screen/Schedule_Screen.dart';
import '../module/screen/SettingScreen/Review/screen/ReviewScreen.dart';
import '../module/screen/SettingScreen/UpdatePassword/screen/update_password.dart';
import '../module/screen/SplashScreen/splash_screen.dart';
import '../module/screen/navigationBar/screen/navigationBar.dart';

class Routes{


  static String splashScreen = "/";
  static String loginScreen = "/login";
  static String registerScreen = "/register";
  static String registerDetails = '/registerDetails';
  static String forgetPassword = '/otp';
  static String otpCheck = '/otpCheck';
  static String homeScreen = '/homeScreen';
  static String navbarRoots = '/navbarRoots';
  static String otpInForgetPassword = '/forgetOtp';
  static String password = '/Password';
  static String addServices = '/addServices';
  static String servicesInfo = '/ServicesInfo';
  static String orderHistory = '/orderHistory';
  static String checkBiometric = '/checkBiometric';
  static String servicesOff = '/deliedServices';
  static String updatePasseword = '/UpdatePassword';
  static String updateServices = '/UpdateServices';
  static String review = "/reviews";
  static String OrderHistoryShow = "/orderHistoryManage";

  static final getPages = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(
      name: loginScreen,
      page: () => Login(),
    ),
    GetPage(
      name: registerScreen,
      page: () => Register(),
    ),
    GetPage(
      name: registerDetails,
      page: () => RegisterDetails(),
    ),
    GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
    ),
    GetPage(
      name: navbarRoots,
      page: () => NavBarRoot(),
    ),

    GetPage(
      name: review,
      page: () => ReviewScreen(),
    ),

    GetPage(
      name: updatePasseword,
      page: () => updatePassword(),
    ),

    GetPage(
      name: addServices,
      page: () => AddServices(),
    ),
    GetPage(
      name: servicesOff,
      page: () => ServicesOff(),
    ),
    GetPage(
      name: servicesInfo,
      page: () => ServicesInfo(),
    ),
    GetPage(
      name: updateServices,
      page: () => Update(),
    ),


    GetPage(
      name: orderHistory,
      page: () => OrderHistory(),
    ),

    GetPage(
      name: OrderHistoryShow,
      page: () => OrderHistoryRecoad(),
    ),

  ];
}