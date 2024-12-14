import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:readmore/readmore.dart';

import 'package:sizer/sizer.dart';
import '../../../../../constants/app_color.dart';
import '../../../../../utils/extension.dart';
import '../../../Home/model/services.dart';

import '../../../OrderList/Screen/newordercode.dart';
import '../../../Schedule/Screen/Schedule_Screen.dart';
import '../../UpdateServices/Screen/update1.dart';
import '../Controller/servicesInfoController.dart';

class ServicesInfo extends StatelessWidget {
  final ServiceResponseModel getdata = Get.arguments;
  final ServiceInfoController homeScreenController = Get.put(ServiceInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomSheet:   Container(
        color: Colors.white,
        width: 100.w,
        height: 8.h,
        child: Row(
          children: [
            Expanded(
                child: roundCornurButton(
                    onTap: () {
                      Get.to(UpdateData1(getdata));
                    },
                    text: "Edit",
                    color: const Color(0xfff1e7ff))),
            2.w.addWSpace(),
            Expanded(
                child: roundCornurButton(
                    onTap: () {
                      Get.to(OrderHistoryRecoad());
                    },
                    color: blueColor,
                    text: "Order List",
                    textColor: whiteColor)),
          ],
        ).paddingSymmetric(horizontal: 2.w),
      ),
      body: GetBuilder<ServiceInfoController>(
        builder: (controller) {
          return SafeArea(
            child: Column(
              children: [
                Container(
                  width: 100.w,
                  height: 92.h,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 34.h,
                              width: 100.w,
                              child: CarouselSlider.builder(
                                itemCount: getdata.images.length,
                                itemBuilder: (context, index, realIndex) {
                                  return CachedNetworkImage(
                                    placeholder: (context, url) {
                                      return  LoadingAnimationWidget.hexagonDots(
                                          color: appColor, size: 5.h);
                                    },
                                    fit: BoxFit.fill,
                                    height: 28.h,
                                    width: double.infinity,
                                    imageUrl: getdata.images[index],
                                  );
                                },
                                options: CarouselOptions(
                                  height: 34.h,
                                  aspectRatio: 0.7,
                                  viewportFraction: 1,
                                  autoPlay: true,
                                  onPageChanged: (index, reason) {
                                    controller.setSelectedPosterImageIndex(
                                        value: index);
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              top: 30,
                              child: IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: whiteColor,
                                  )),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    4,
                                        (index) => controller
                                        .selectedPosterImageIndex ==
                                        index
                                        ? Container(
                                      width: 7.w,
                                      height: 6,
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                              colors: [
                                                Color(0xffc992fc),
                                                appColor
                                              ]),
                                          borderRadius:
                                          BorderRadius.circular(50)),
                                    )
                                        : CircleAvatar(
                                      radius: 3,
                                      backgroundColor:
                                      Colors.white.withOpacity(0.8),
                                    ).paddingSymmetric(horizontal: 1.w)),
                              ),
                            )
                          ],
                        ),
                        0.7.h.addHSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: "${getdata.serviceName}".boldOpenSans(
                                  fontColor: blackColor, fontSize: 20.sp,textOverflow: TextOverflow.ellipsis,),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                  "assets/images/svg/bookmark.svg",
                                  color: appColor,
                                  width: 5.w),
                            ),
                          ],
                        ).paddingOnly(left: 2.w),
                        1.2.h.addHSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            "Vyas Parth".boldOpenSans(
                                fontColor: appColor, fontSize: 14.sp),
                            3.w.addWSpace(),
                            Image.asset(
                              "assets/images/rating.png",
                              width: 4.w,
                            ),
                            1.w.addWSpace(),
                            "4.8 (4,479 reviews)".mediumOpenSans(
                                fontSize: 10.sp,
                                fontColor: Colors.black.withOpacity(0.8))
                          ],
                        ).paddingSymmetric(horizontal: 2.w),
                        1.2.h.addHSpace(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xfff4ecff),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: "${getdata.categoryName}".semiOpenSans(
                                    fontColor: appColor, fontSize: 13.sp),
                              ).paddingSymmetric(
                                  horizontal: 3.w, vertical: 0.5.h),
                            ),
                            5.w.addWSpace(),
                            SvgPicture.asset(
                              "assets/images/svg/marker.svg",
                              width: 4.w,
                              color: appColor,
                            ),
                            1.w.addWSpace(),
                            "${getdata.address}".mediumOpenSans(
                                fontColor: Colors.black.withOpacity(0.6),
                                fontSize: 13.sp,
                                maxLine: 1,
                                textOverflow: TextOverflow.ellipsis)
                          ],
                        ).paddingSymmetric(horizontal: 2.w),
                        2.5.h.addHSpace(),
                        Row(
                          children: [
                            "\$${getdata.price}".extraBoldOpenSans(
                                fontColor: appColor, fontSize: 22.sp),
                            3.w.addWSpace(),
                            "(Min Price)".mediumOpenSans(
                                fontColor: Colors.black.withOpacity(0.6),
                                fontSize: 12.sp,
                                maxLine: 1,
                                textOverflow: TextOverflow.ellipsis)
                          ],
                        ).paddingSymmetric(horizontal: 2.w),
                        1.h.addHSpace(),
                        0.2
                            .h
                            .appDivider(color: Colors.black.withOpacity(0.05))
                            .paddingSymmetric(horizontal: 2.w),
                        1.h.addHSpace(),
                        "About me"
                            .boldOpenSans(fontColor: blackColor, fontSize: 17.sp)
                            .paddingSymmetric(horizontal: 2.w),
                        1.h.addHSpace(),
                        ReadMoreText(
                          '${getdata.description}',
                          trimLines: 3,
                          colorClickableText: Colors.pink,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: '  Show more',
                          trimExpandedText: '  Show less',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: "OpenSans"),
                          lessStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: appColor,
                              fontFamily: "OpenSans"),
                          moreStyle: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: appColor,
                              fontFamily: "OpenSans"),
                        ).paddingSymmetric(horizontal: 2.w),
                        4.h.addHSpace(),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}
