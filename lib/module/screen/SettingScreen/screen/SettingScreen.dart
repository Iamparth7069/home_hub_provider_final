import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../../Routes/Routes.dart';
import '../../../../constants/app_color.dart';
import '../ProfileData/screen/Profile_Screen.dart';
import '../controller/SettingScreenController.dart';
import '../transection/screen/transection_screen.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  SettingsControllers _controllers = Get.put(SettingsControllers());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Setting",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                0.2.h.addHSpace(),
                Obx(() {
                  if (_controllers.isLoading.value) {
                    return LoadingAnimationWidget.hexagonDots(
                        color: appColor, size: 5.h);
                  } else {
                    final servicesData = _controllers.servicesData.value;
                    if (servicesData != null) {
                      return ListTile(
                        title: Text(
                          servicesData.fname ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                          ),
                        ),
                        leading: SizedBox(
                          height: 60,
                          width: 60,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              placeholder: (context, url) {
                                return LoadingAnimationWidget.hexagonDots(
                                    color: appColor, size: 5.h);
                              },
                              imageUrl: servicesData.Images ?? '',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        subtitle: Text(servicesData.services ?? ''),
                      );
                    } else {
                      // Return a placeholder or alternative widget if servicesData is null
                      return SizedBox();
                    }
                  }
                }),
                Divider(
                  height: 50,
                ),
                ListTile(
                  onTap: () {
                    Get.to(ProfileData());
                  },
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.person,
                      color: Colors.blue,
                      size: 35,
                    ),
                  ),
                  title: Text(
                    "profile",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: ()  {
                    Get.toNamed(Routes.review);
                  },
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.feedback,
                      color: Colors.blue,
                      size: 35,
                    ),
                  ),
                  title: const Text(
                    "Review",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Get.toNamed(Routes.updatePasseword, arguments: _controllers.servicesData.value);
                  },
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.privacy_tip_outlined,
                      color: Colors.blue,
                      size: 35,
                    ),
                  ),
                  title: Text(
                    "Privacy",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {

                  },
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.settings_suggest_outlined,
                      color: Colors.blue,
                      size: 35,
                    ),
                  ),
                  title: Text(
                    "Notification",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () {
                    Get.to(Transection());
                  },
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset("assets/images/6466947.png"),
                  ),
                  title: const Text(
                    "Transaction",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  onTap: () async {
                    await _launchUrl();
                    //
                  },
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.orange,
                      size: 35,
                    ),
                  ),
                  title: Text(
                    "About Us",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
                Divider(
                  height: 40,
                ),
                ListTile(
                  onTap: () async {
                    await _controllers.signOut();
                  },
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.logout,
                      color: Colors.redAccent.shade100,
                      size: 35,
                    ),
                  ),
                  title: Text(
                    "Log Out",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios_rounded),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> launchUrl(String urlString) async {
  //   if (await launchUrl(urlString)) { // Check if the URL can be launched
  //     await launch(urlString);
  //   } else {
  //     throw 'Could not launch $urlString'; // throw could be used to handle erroneous situations
  //   }
  // }
  Future<void> _launchUrl() async {
    final Uri _url = Uri.parse('https://help.fiverr.com/hc/en-us/');
    // if (!await launchUrl(_url)) {
    //   throw Exception('Could not launch $_url');
    // }
  }


  // void _openNotificationSettings() {
  //   AppSettings.openAppSettings();
  // }
}
