import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/app_color.dart';
import '../controller/Schedule_screen_controller.dart';


class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  SeduleScreen serviceProviderMenagementController = Get.put(SeduleScreen());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Schedule Screen",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            bottom: PreferredSize(
              preferredSize: Size(100.w, 5.h),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Tab(
                    text: "Pending",
                  ),
                  Tab(
                    text: "Accepted",
                  ),
                  Tab(
                    text: "Rejected",
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              todayScreen(),
              ConformScreen(),
              rejected()
            ],
          ),
        ),
      ),
    );
  }

  Widget todayScreen() {
    return GetBuilder<SeduleScreen>(
      builder: (controller) {
        return controller.load
            ? Center(
          child: CircularProgressIndicator(),
        )
            : controller.pending.isEmpty
            ? FutureBuilder(
          future: Future.delayed(Duration(seconds: 1)), // Introduce 1 second delay
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h); // Return an empty container while waiting
            } else {
              return Center(
                child: "No Pending Data".semiOpenSans(
                    fontColor: Colors.black, fontSize: 12.sp),
              );
            }
          },
        )
            : ListView.builder(
          padding: EdgeInsets.all(0),
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.pending.length,
          itemBuilder: (context, index) {
            DateTime? date = controller.pending[index].completeDate;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          )
                        ]),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "${controller.userdatas[index].firstName} ${controller.userdatas[index].lastName}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                "${controller.pending[index].servicesName}"),
                            trailing: CircleAvatar(
                              radius: 25,
                              backgroundImage: CachedNetworkImageProvider(
                                  controller.userdatas[index]
                                      .profileImage),
                            ),
                          ),
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(
                              thickness: 1,
                              height: 20,
                            ),
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${date!.day.toString()}-${date!.month.toString()}-${date.year.toString()}",
                                    style:
                                    TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${date.hour}:${date.minute} AM",
                                    style:
                                    TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: controller.pending[index]
                                            .paymentStatus ==
                                            "Pending"
                                            ? Colors.red
                                            : Colors.green,
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      "${controller.pending[index].paymentStatus}"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  controller.cancel(
                                      controller.pending[index]);
                                },
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F6FA),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Reject",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await controller.actupted(
                                      controller.pending[index],
                                      controller.userdatas[index]);
                                },
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                  decoration: BoxDecoration(
                                    color: appColor,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Accepted",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          1.5.h.addHSpace(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  Widget ConformScreen() {
    return GetBuilder<SeduleScreen>(
      builder: (controller) {
        return controller.load
            ? Center(
          child: CircularProgressIndicator(),
        )
            : controller.completed.isEmpty
            ? FutureBuilder(
          future: Future.delayed(Duration(seconds: 1)), // Introduce 1 second delay
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h); // Return an empty container while waiting
            } else {
              return Center(
                child: "No Pending Data".semiOpenSans(
                    fontColor: Colors.black, fontSize: 12.sp),
              );
            }
          },
        )
            : ListView.builder(
          padding: const EdgeInsets.all(0),
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.completed.length,
          itemBuilder: (context, index) {
            DateTime? date = controller.completed[index].completeDate;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          )
                        ]),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "${controller.userdatas[index].firstName} ${controller.userdatas[index].lastName}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                "${controller.completed[index].servicesName}"),
                            trailing: CircleAvatar(
                              radius: 25,
                              backgroundImage: CachedNetworkImageProvider(
                                  controller.userdatas[index]
                                      .profileImage),
                            ),
                          ),
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(
                              thickness: 1,
                              height: 20,
                            ),
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${date!.day.toString()}-${date!.month.toString()}-${date.year.toString()}",
                                    style:
                                    TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${date.hour}:${date.minute} AM",
                                    style:
                                    TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: controller.completed[index]
                                            .paymentStatus ==
                                            "Pending"
                                            ? Colors.red
                                            : Colors.green,
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      "${controller.completed[index].paymentStatus}"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if(controller.completed[index].status == "Completed"){
                                    await controller.deleteOrder(controller.completed[index].orderId!);
                                  }else{
                                    await controller.cancel(controller.completed[index]);
                                  }

                                },
                                child: Container(
                                  width: 150,
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: controller.completed[index].status ==  "Completed" ? Colors.red : Color(0xFFF4F6FA),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:  Center(
                                    child: Text(
                                      controller.completed[index].status == "Completed" ? "Deleted" : "Reject",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              InkWell(
                                onTap: () async {

                                  if(controller.completed[index].status == "Completed"){
                                    Get.snackbar("Services", "Services Completed");
                                  }else{
                                    controller.comp(controller.completed[index]);
                                  }

                                },
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: controller.completed[index].status ==  "Completed" ? Colors.grey : appColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:  Center(
                                    child: Text(
                                      controller.completed[index].status == "Accepted" ? "Complete" : "Finish",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          1.5.h.addHSpace(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget rejected() {
    return  GetBuilder<SeduleScreen>(
      builder: (controller) {
        return controller.load
            ? Center(
          child: CircularProgressIndicator(),
        )
            : controller.canceled.isEmpty
            ? FutureBuilder(
          future: Future.delayed(Duration(seconds: 1)), // Introduce 1 second delay
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingAnimationWidget.hexagonDots(color: appColor, size: 5.h);// Return an empty container while waiting
            } else {
              return Center(
                child: "No Rejecting Data".semiOpenSans(
                    fontColor: Colors.black, fontSize: 12.sp),
              );
            }
          },
        )
            : ListView.builder(
          padding: EdgeInsets.all(0),
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.canceled.length,
          itemBuilder: (context, index) {
            DateTime? date = controller.canceled[index].completeDate;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          )
                        ]),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "${controller.userdatas[index].firstName} ${controller.userdatas[index].lastName}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                "${controller.canceled[index].servicesName}"),
                            trailing: CircleAvatar(
                              radius: 25,
                              backgroundImage: CachedNetworkImageProvider(
                                  controller.userdatas[index]
                                      .profileImage),
                            ),
                          ),
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(horizontal: 15),
                            child: Divider(
                              thickness: 1,
                              height: 20,
                            ),
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${date!.day.toString()}-${date!.month.toString()}-${date.year.toString()}",
                                    style:
                                    TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_filled,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${date.hour}:${date.minute} AM",
                                    style:
                                    TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: controller.canceled[index]
                                            .paymentStatus ==
                                            "Pending"
                                            ? Colors.red
                                            : Colors.green,
                                        shape: BoxShape.circle),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                      "${controller.canceled[index].paymentStatus}"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await controller.deleteOrder(controller.canceled[index].orderId!);
                                },
                                child: Container(
                                  width: 150,
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF4F6FA),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Delete",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await controller.reConform(controller.canceled[index]);
                                },
                                child: Container(
                                  width: 150,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color:  appColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Reconfirm",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          1.5.h.addHSpace(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


}
