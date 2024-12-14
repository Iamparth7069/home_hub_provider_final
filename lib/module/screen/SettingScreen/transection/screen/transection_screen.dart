import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../controller/transection_screen_controller.dart';

class Transection extends StatelessWidget {
  Transection({Key? key}) : super(key: key);
  TransactionController trackingScrollController = Get.put(TransactionController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   "Transactions".boldOpenSans(
          fontColor: Colors.black,
          fontSize: 14.sp,
        ),
      ),
      body: GetBuilder<TransactionController>(
        builder: (controller) {
          return controller.isLoading.value == true
              ? Center(
            child: CircularProgressIndicator(),
          )
              : controller.allData.isEmpty
              ? Center(
            child: "No Transaction Found"
                .semiOpenSans(fontColor: Colors.black),
          )
              : ListView.builder(
            itemCount: controller.allData.length,
            itemBuilder: (context, index) {
              return ListTile(

                title: Text(controller.allData[index].from == "admin" ? "Admin To withdraw" : "${controller.userData[index]?.firstName}  ${controller.userData[index]?.lastName}"),
                leading: controller.allData[index].from == "admin"
                    ? CircleAvatar(
                  backgroundImage: AssetImage('assets/images/images.png'),
                  radius: 35, // Adjust radius as needed
                )
                    : CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(controller.userData[index]!.profileImage), // Assuming profileImage is the field for the image URL in UserData
                  radius: 35, // Adjust radius as needed
                ),
                subtitle:
                "${DateFormat('d MMM yyyy, HH:mm a').format(controller.allData[index].time)}"
                    .mediumOpenSans(
                    fontSize: 9.sp,
                    fontColor: Colors.black26),
                trailing: controller.allData[index].from == "admin"
                    ? "- ₹${controller.allData[index].amount}"
                    .boldOpenSans(
                    fontSize: 12.5.sp, fontColor: Colors.red)
                    : "+ ₹${controller.allData[index].amount}"
                    .boldOpenSans(
                    fontSize: 12.5.sp,
                    fontColor: Colors.green),
              );
            },
          );
        },
      ),
    );
  }
}
