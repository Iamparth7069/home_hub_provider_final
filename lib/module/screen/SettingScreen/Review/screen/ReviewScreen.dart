import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../../../constants/app_color.dart';
import '../controller/ReviewScreenController.dart';
import '../review_continer.dart';

class ReviewScreen extends StatelessWidget {
  ReviewScreen({Key? key});
  final ReviewController reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ReviewController>(
        builder: (controller) {
          if (controller.isLoadding) {
            return Center(
              child: LoadingAnimationWidget.hexagonDots(
                color: appColor,
                size: 5.h,
              ),
            );
          } else {
            return CustomScrollView(
              slivers: [
                // SliverAppBar remains visible at all times
                SliverAppBar(
                  leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    'Reviews',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  floating: true,
                  expandedHeight: 150, // Adjust as per your design
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      'assets/images/rev.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Show Centered Message or the SliverList based on the data
                controller.userDataList.isEmpty
                    ? SliverFillRemaining(
                  hasScrollBody: false, // Ensures content is centered
                  child: Center(
                    child: Text(
                      "No reviews available",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    : SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return ReviewContainer(
                        reviews: controller.reviewsList[index],
                        userDataList: controller.userDataList[index],
                      );
                    },
                    childCount: controller.userDataList.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
