import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../LocalStorage/StorageClass.dart';
import '../../SettingScreen/Review/model/UserData.dart';
import '../Model/ChatRoomResModel.dart';

class MessegeController extends GetxController {
  final StorageService _storageService = StorageService();

  Rx<DateTime> selectedDate = Rx<DateTime>(DateTime.now());
  Rx<UserData> userData = UserData(
      address: "",
      email: "",
      fcmToken: "",
      firstName: "",
      lastName: "",
      phoneNumber: "",
      profileImage: "",
      uId: "")
      .obs;

  @override
  void onInit() {
    super.onInit();
    getData();
  }

  RxBool isSearch = false.obs;
  RxBool isLoading = true.obs;
  RxList<ChatRoomResModel> chatrooms = <ChatRoomResModel>[].obs;
  RxList<UserData> userDatas = <UserData>[].obs;
  StreamSubscription<QuerySnapshot>? _subscription;
  RxList<String> roomId = <String>[].obs;

  RxList<ChatRoomResModel> searchChatRooms = <ChatRoomResModel>[].obs;
  RxList<UserData> searchUserData = <UserData>[].obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> getData() async {
    isLoading.value = true;
    try {
      String userid = _storageService.getUserid();
      CollectionReference chatRoomCollection = firestore.collection("chatRoom");
      QuerySnapshot chatRoomData = await chatRoomCollection
          .where("secondUid", isEqualTo: userid)
          .get();

      print(userid);
      chatrooms.clear();
      userDatas.clear();
      roomId.clear();

      for (var element in chatRoomData.docs) {
        roomId.add(element["roomId"]);
        ChatRoomResModel chatRooms =
        ChatRoomResModel.fromJson(element.data() as Map<String, dynamic>);
        chatrooms.add(chatRooms);
        print(chatRooms.firstUid);

        UserData? userData = await getUserData(UserId: chatRooms.firstUid);
        if (userData != null) {
          userDatas.add(userData);
        } else {
          print("No Record");
        }
      }
    } catch (e, stackTrace) {
      print("Error in getData: $e");
      print(stackTrace);
      // Optionally, you can add a more user-friendly error log or UI alert.
    } finally {
      isLoading.value = false;
      update();
    }

    print(chatrooms.length);
    print(userDatas.length);
  }

  Future<UserData?> getUserData({required String UserId}) async {
    try {
      CollectionReference serviceProviderUserCollection =
      firestore.collection("User");
      QuerySnapshot userData = await serviceProviderUserCollection
          .where("uId", isEqualTo: UserId)
          .get();

      if (userData.docs.isNotEmpty) {
        return UserData.fromJson(
            userData.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e, stackTrace) {
      print("Error in getUserData for UserId: $UserId: $e");
      print(stackTrace);
      return null;
    }
  }

  Future<bool> sendTheOffers(DateTime date, String price, String description,
      String docId, String category, String token, String Sname) async {
    try {
      DateTime currentDate = DateTime.now();
      DateTime selected = selectedDate.value;
      Duration positiveDifference = selected.difference(currentDate);

      Map<String, dynamic> message = {
        "sendBy": _storageService.getUserid(),
        "price": int.parse(price),
        "description": description,
        "sId": category,
        "daysToWork": Timestamp.fromDate(selected),
        "msgType": "offers",
        "status": "pending",
        "service_name": Sname,
        "messageId": null,
        "createdAt": DateTime.now(),
      };

      String name = _storageService.getName();
      DocumentReference documentReference = await FirebaseFirestore.instance
          .collection('chatRoom')
          .doc(docId)
          .collection('messages')
          .add(message);

      String messageId = documentReference.id;
      await documentReference.update({'messageId': messageId});

      return true;
    } catch (e, stackTrace) {
      print("Error in sendTheOffers: $e");
      print(stackTrace);
      return false;
    }
  }

  Future<void> deletedOffer(String messageId) async {
    try {
      String userid = _storageService.getUserid();
      QuerySnapshot roomSnapshot = await firestore
          .collection('chatRoom')
          .where("secondUid", isEqualTo: userid)
          .get();

      for (QueryDocumentSnapshot roomDoc in roomSnapshot.docs) {
        String roomId = roomDoc.id;
        DocumentReference messageRef = firestore
            .collection('chatRoom')
            .doc(roomId)
            .collection('messages')
            .doc(messageId);
        await messageRef.delete();
      }
    } catch (e, stackTrace) {
      print("Error in deletedOffer: $e");
      print(stackTrace);
    }
  }

  getSearchMesseges({required String searchValue}) {
    try {
      searchChatRooms.clear();
      searchUserData.clear();

      for (int i = 0; i < chatrooms.length; i++) {
        if (userDatas[i]
            .firstName
            .toLowerCase()
            .contains(searchValue.toLowerCase()) ||
            userDatas[i]
                .lastName
                .toLowerCase()
                .contains(searchValue.toLowerCase())) {
          searchChatRooms.add(chatrooms[i]);
          searchUserData.add(userDatas[i]);
        }
      }
    } catch (e, stackTrace) {
      print("Error in getSearchMesseges: $e");
      print(stackTrace);
    }
  }

  void setSearchValue({required bool value}) {
    isSearch.value = value;
    update();
  }

  void cleanDateTime() {
    selectedDate.value = DateTime.now();
  }

  void select(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101),
        initialDate: selectedDate.value);
    if (picked != null && picked != selectedDate) {
      selectedDate.value = picked;
    }
    update();
  }


}
