import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_hub_provider_final/utils/extension.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../../constants/app_color.dart';
import '../Controller/newordercodecontroller.dart';
import 'orderDetailsinUser.dart';

class OrderHistoryRecoad extends StatelessWidget {
  final OrderHistoryController controller = Get.put(OrderHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<OrderHistoryController>(
          builder: (controller) {
            return Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    "Order List",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back), // Back arrow icon
                    onPressed: () {
                      Get.back(); // Navigate to the previous screen
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.filter_alt_outlined),
                      onPressed: () {
                        controller.dateFunction(context);
                      },
                    ),
                    SizedBox(width: 2.w),
                  ],
                ),
                controller.isLoading.value
                    ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.hexagonDots(
                            color: appColor, size: 5.h),
                      ],
                    ),
                  ),
                )
                    : Expanded(
                  child: ListView.builder(
                    itemCount: controller.isFilter.value
                        ? controller.filterData.length
                        : controller.userData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          trailing: IconButton(
                            onPressed: () {
                              Get.to(OrderDetailsScreen(
                                controller.userData[index],
                                controller.isFilter.value
                                    ? controller.filterData[index]
                                    : controller.orderData[index],
                              ));
                            },
                            icon: Icon(Icons.navigate_next_rounded),
                          ),
                          title: Text(
                              "${controller.userData[index].firstName} ${controller.userData[index].lastName}"),
                          subtitle: Text(
                              "${controller.isFilter.value ? controller.filterData[index].completeDate!.day : controller.orderData[index].completeDate!.day}/${controller.isFilter.value ? controller.filterData[index].completeDate!.month : controller.orderData[index].completeDate!.month}/${controller.isFilter.value ? controller.filterData[index].completeDate!.year : controller.orderData[index].completeDate!.year}"),
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            backgroundImage: CachedNetworkImageProvider(
                                controller.userData[index].profileImage),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (controller.isFilter.value)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      color: appColor,
                      height: 45,
                      minWidth: double.infinity,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        controller.updateFilter(false);
                      },
                      child: Text(
                        "Clear All",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                1.h.addHSpace(),
              ],
            );
          },
        ),
      ),
    );
  }
}
