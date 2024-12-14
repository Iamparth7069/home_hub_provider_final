import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:sizer/sizer.dart';

import '../../../../Routes/Routes.dart';
import '../../../../constants/app_color.dart';
import '../../../../constants/chartContainer.dart';
import '../../IncomeScreen/Screen/income_screen.dart';
import '../../ManageServices/ServicesOn/Screen/servicesOn.dart';
import '../controller/Home_Screen_Controller.dart';



class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeScreenController _homeScreenController = Get.put(HomeScreenController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Obx(
                    () {
                  return ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: _homeScreenController.userData.value.Images,
                      fit: BoxFit.cover,
                      width: 130.0,
                      // Set the width and height to create a perfect circle
                      height: 50.0,
                      placeholder: (context, url) =>
                          LoadingAnimationWidget.hexagonDots(
                              color: appColor, size: 5.h),
                    ),
                  );
                },
              ),
            ),
            ExpansionTile(
              leading: Icon(Icons.category),
              title: Text('Services Management'),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListTile(
                    trailing: Icon(Icons.design_services),
                    title: const Text('Add Services'),
                    onTap: () {
                       Get.toNamed(Routes.addServices);
                      // Handle category 1 tap
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListTile(
                    trailing: Icon(Icons.delete),
                    title: const Text('Denied Services'),
                    onTap: () {
                      Get.toNamed(Routes.servicesOff);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListTile(
                    trailing: Icon(Icons.update),
                    title: const Text('Update Services'),
                    onTap: () {
                       Get.toNamed(Routes.updateServices);
                      // Handle category 1 tap
                    },
                  ),
                ),
                // Add more list tiles for other categories
              ],
            ),
            ListTile(
              leading: Icon(Icons.cleaning_services),
              title: Text("Service Start"),
              onTap: () {
                Get.to(ServicesOn());
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Exit app'),
              onTap: () {
                exitApp();
              },
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (_homeScreenController.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h),
              ],
            ),
          );
        } else {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              _scaffoldKey.currentState?.openDrawer();
                            },
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: _homeScreenController.userData.value.Images,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            // Adjust vertical padding as needed
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    "Good Morning".mediumReadex(
                                      fontColor: Colors.black38,
                                      fontSize: 13,
                                    ),
                                    Image.asset(
                                      "assets/images/hello.png",
                                      scale: 13,
                                      color: Colors.yellow.shade800,
                                    ),
                                  ],
                                ),
                                "${_homeScreenController.userData.value.fname} ${_homeScreenController.userData.value.lname}"
                                    .mediumRoboto(
                                  fontColor: Colors.black,
                                  fontSize: 23,
                                )
                              ],
                            ),
                          ),
                        ),
                        CustomRoundedIcons(
                          iconData: Icons.notification_important,
                          onPress: () {},
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          child: ChartContainer(
                              discountTitle: "Admin",
                              discount: "%20",
                              onTap: () {
                                Get.to(IncomeScreen(_homeScreenController.order,_homeScreenController.userData));
                              },
                              chartColor: Colors.green,
                              chartValue: "+10%",
                              title: "Income",
                              value: "${_homeScreenController.userData.value.totalPayment}"),
                        ),
                        SizedBox(width: 5.w),
                        Container(
                          child: ChartContainer(
                              discountTitle: "",
                              discount: "",
                              onTap: () {

                              },
                              chartColor: Colors.red,
                              chartValue: "-5%",
                              title: "Order",
                              value: "${_homeScreenController.order.length}"),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 15),
                    1.h.addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.OrderHistoryShow);
                          },
                          child: Container(
                            width: 47.w,
                            decoration: BoxDecoration(
                              color: Colors.green.shade300,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 12),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${_homeScreenController.order.length}",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        0.7.h.addHSpace(),
                                        Text(
                                          "NEW ORDER",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        SizedBox(
                                          height: 2,
                                          width: double.infinity,
                                          child: Divider(
                                            thickness: 1,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 7,
                                              vertical: 3),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "assets/images/increase.png",
                                                scale: 16,
                                              ),
                                              Text(
                                                "Increase 20%",
                                                style:
                                                TextStyle(fontSize: 15),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 47.w,
                          decoration: BoxDecoration(
                            color: Colors.red.shade500,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${_homeScreenController.pendings.length}",
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      0.3.h.addHSpace(),
                                      Text(
                                        "Pandding",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 2,
                                        width: double.infinity,
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 3),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              "assets/images/increase.png",
                                              scale: 16,
                                            ),
                                            Text(
                                              "Increase 20%",
                                              style:
                                              TextStyle(fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    2.h.addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 47.w,
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade900,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${_homeScreenController.userData.value.clicks}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23,
                                            color: Colors.black),
                                      ),
                                      0.3.h.addHSpace(),
                                      Text(
                                        "Watching",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      SizedBox(
                                        height: 2,
                                        width: double.infinity,
                                        child: Divider(
                                          thickness: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 3),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              "assets/images/increase.png",
                                              scale: 16,
                                            ),
                                            Text(
                                              "Increase 20%",
                                              style:
                                              TextStyle(fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 47.w,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${_homeScreenController.order.length}",
                                        style: TextStyle(
                                            fontSize: 23,
                                            color: Colors.white),
                                      ),
                                      0.3.h.addHSpace(),
                                      Text(
                                        "Total User",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 2,
                                        width: double.infinity,
                                        child: Divider(
                                          thickness: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 3),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Image.asset(
                                              "assets/images/increase.png",
                                              scale: 16,
                                            ),
                                            Text(
                                              "Increase 20%",
                                              style:
                                              TextStyle(fontSize: 15),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),1.h.addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Services".mediumReadex(
                            fontSize: 20, fontColor: Colors.black),
                        Icon(Icons.more_vert, color: Colors.black)
                      ],
                    ),
                    1.h.addHSpace(),
                    Obx(
                          () => _homeScreenController.services.isEmpty ? Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20), // Adjust the radius here
                          border: Border.all(
                            color: Colors.black38,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("No Services add"),
                              IconButton(onPressed: () {
                                Get.toNamed(Routes.addServices);
                              }, icon: Icon(Icons.add))
                            ],
                          ),
                        ),) : Obx(
                            () => Swiper(

                            loop: false,
                            layout: SwiperLayout.CUSTOM,
                            customLayoutOption: CustomLayoutOption(
                                startIndex: -1,
                                stateCount: 3
                            )
                              ..addRotate([
                                -45.0/180,
                                0.0,
                                45.0/180
                              ])
                              ..addTranslate([
                                Offset(-500.0, -40.0),
                                Offset(0.0, 0.0),
                                Offset(500.0, -40.0)
                              ]),
                            itemWidth: 360,
                            itemHeight: 34.h,

                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.servicesInfo,arguments: _homeScreenController.services[index]);
                                },
                                child: Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 180,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20), // Adjust the radius here
                                        border: Border.all(
                                          color: Colors.black38,
                                          width: 2,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect( // Use ClipRRect to apply BorderRadius to the child
                                            borderRadius: BorderRadius.circular(20), // Adjust the same radius here
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) {
                                                return  LoadingAnimationWidget.hexagonDots(
                                                    color: appColor, size: 5.h);
                                              },
                                              fit: BoxFit.fill,
                                              height: 28.h,
                                              width: double.infinity,
                                              imageUrl: _homeScreenController.services[index].images[0],
                                            ),
                                          ),
                                          SizedBox(height: 10), // Adjust spacing between image and name
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  _homeScreenController.services[index].serviceName,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Center(child: _homeScreenController.services[index].serviceStatus == "denied" ? Icon(Icons.cancel,color: Colors.red,) : Container()),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            itemCount: _homeScreenController.services.length
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }

  void exitApp() {
    if (Platform.isAndroid || Platform.isIOS) {
      exit(0); // Exit app on mobile platforms
    } else {
      // Handle other platforms if needed
    }
  }


  void showNetworkErrorDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Network Error'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('No internet connection.'),
                Text('Please check your network settings and try again.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (Platform.isAndroid || Platform.isIOS) {
                  exit(0); // Exit app on mobile platforms
                } else {
                  // Handle other platforms if needed
                } // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
