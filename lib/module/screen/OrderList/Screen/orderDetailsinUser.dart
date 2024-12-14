import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:home_hub_provider_final/utils/extension.dart';

import 'package:sizer/sizer.dart';

import '../../Home/model/OrderResModel.dart';
import '../../SettingScreen/Review/model/UserData.dart';


class OrderDetailsScreen extends StatefulWidget {

  UserData userData;
  OrderResModel orderData;
  OrderDetailsScreen(this.userData,this.orderData);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              2.h.addHSpace(),
              Center(
                child: Container(
                  height: 13.h,
                  width: 13.h,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: widget.userData.profileImage ?? "")),
                ),
              ),
              2.h.addHSpace(),
              Center(
                child: "${widget.userData.firstName} ${widget.userData.lastName}"
                    .boldOpenSans(fontSize: 13.sp, fontColor: Colors.black),
              ),
              5.h.addHSpace(),
              Card(
                child: Container(
                  width: 100.w,
                  height: 7.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Email : "
                          .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      "${widget.userData.email}"
                          .semiOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                    ],
                  ),
                ),
              ),
              1.h.addHSpace(),
              Card(
                child: Container(
                  width: 100.w,
                  height: 7.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Contact : ".boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      "${widget.userData.phoneNumber}".semiOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                    ],
                  ),
                ),
              ),
              1.h.addHSpace(),
              Card(
                child: Container(
                  width: 100.w,
                  height: 7.5.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Address :  "
                          .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      Expanded(
                        child: "${widget.userData.address}".semiOpenSans(
                            fontSize: 12.sp,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontColor: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              1.h.addHSpace(),
              Card(
                child: Container(
                  width: 100.w,
                  height: 7.5.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Service :  "
                          .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      Flexible(
                        child: "${widget.orderData.servicesName}".semiOpenSans(
                            fontSize: 12.sp,
                            textOverflow: TextOverflow.ellipsis,
                            fontColor: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              2.h.addHSpace(),
              Card(
                child: Container(
                  width: 100.w,
                  height: 7.5.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Payment Status :  "
                          .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      Expanded(
                        child: "${widget.orderData.paymentStatus}".semiOpenSans(
                            fontSize: 12.sp,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontColor: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              2.h.addHSpace(),

              Card(
                child: Container(
                  width: 100.w,
                  height: 7.5.h,
                  child: Row(
                    children: [
                      3.w.addWSpace(),
                      "Work Status :  "
                          .boldOpenSans(fontSize: 12.sp, fontColor: Colors.black),
                      Expanded(
                        child: "${widget.orderData.status}".semiOpenSans(
                            fontSize: 12.sp,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontColor: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              2.h.addHSpace(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Expanded(
                        child: appButton(
                            onTap: () {
                              Get.back();
                            },
                            text: "Back",
                            color: Colors.green,
                            fontSize: 12.sp,
                            borderRadius: 12,
                            fontColor: Colors.white)),
                  )
                ],
              ),
              const Spacer(),
            ],
          ).paddingSymmetric(horizontal: 2.w),
        ),
    );
  }

}
