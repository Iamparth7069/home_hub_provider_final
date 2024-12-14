import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ServiceInfoController extends GetxController{
  int selectedPosterImageIndex = 0;

  int buttonindex = 0;
  List<String> items = [
    "Order",
    "Review"
  ];
  List<String> icons = [
    "assets/images/svg/order.svg",
    "assets/images/svg/review.svg"
  ];

  int current = 0;
  PageController pageController = PageController(initialPage: 0);

  void updateIndex(int index){
    buttonindex = index;
    update();
  }
  void setSelectedPosterImageIndex({required int value}) {
    selectedPosterImageIndex = value;
    update();
  }

}