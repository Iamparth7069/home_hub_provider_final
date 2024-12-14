

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../LocalStorage/StorageClass.dart';
import '../../Home/model/OrderResModel.dart';

import '../../SettingScreen/Review/model/UserData.dart';


class OrderHistoryController extends GetxController {
  final StorageService _storageService = StorageService();
  RxBool isLoading = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  bool checkData = false;
  List<OrderResModel> orderData = [];
  List<OrderResModel> filterData = [];
  List<UserData> userData = [];
  RxBool isFilter = false.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDataInFirebaseFireStore();
  }
  void dateFunction(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        initialDate: selectedDate.value);
    if (picked != null && picked != selectedDate){
      selectedDate.value = picked;
      isFilter.value = true;
      filterDataList(selectedDate.value);
    }
    update();
  }




  GetUserData(String? userId) async {
    CollectionReference serviceProviderUserCollection =
    FirebaseFirestore.instance.collection("User");
    QuerySnapshot userData = await serviceProviderUserCollection
        .where("uId", isEqualTo: userId)
        .get();
    if (userData.docs.isNotEmpty) {
      return UserData.fromJson(
          userData.docs.first.data() as Map<String, dynamic>);
    }
  }

  Future<void> getDataInFirebaseFireStore() async {
    isLoading.value = true;
    String uid = _storageService.getUserid();

    CollectionReference orderCollection = FirebaseFirestore.instance.collection("Orders");
    QuerySnapshot chatRoomData = await orderCollection.where("serviceProviderId", isEqualTo: uid).get();
    orderData.clear();
    userData.clear();

    for(var data in chatRoomData.docs){
      OrderResModel orderResModel = OrderResModel.fromJson(data.data() as Map<String, dynamic>);
      orderData.add(orderResModel);
      UserData userDatas = await GetUserData(orderResModel.userId);
      userData.add(userDatas);
    }
    isLoading.value = false;
    update();
    print(userData.length);
    print(orderData.length);
  }



  filterDataList(DateTime value){
    filterData = orderData.where((e) =>
    e.completeDate!.year == value.year &&
        e.completeDate!.month == value.month &&
        e.completeDate!.day == value.day
    ).toList();
    update();
  }



  void updateFilter(bool fil){
    isFilter.value = fil;
    update();
  }
}