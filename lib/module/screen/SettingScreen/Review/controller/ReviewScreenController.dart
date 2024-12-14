import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../../LocalStorage/StorageClass.dart';
import '../model/UserData.dart';
import '../model/reviews.dart';

class ReviewController extends GetxController{
  bool isLoadding =  false;
  StorageService service = StorageService();
  List<Reviews> reviewsList = [];
  List<UserData> userDataList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadServicesReview();
  }

  Future<void> loadServicesReview() async {
    isLoadding = true;
    try {
      String userid = service.getUserid();

      CollectionReference collectionReference = FirebaseFirestore.instance.collection("Services-Provider(Provider)");
      var query = await collectionReference.where("userId", isEqualTo: userid).get();

      if (query.docs.isEmpty) {
        print("No documents found for user $userid");
        isLoadding = false;
        update();
        return;
      }

      for (var doc in query.docs) {
        CollectionReference _collection = doc.reference.collection("ratings");
        QuerySnapshot review = await _collection.get();

        if (review.docs.isEmpty) {
          print("No reviews found for user $userid");
          continue;
        }

        for (var element in review.docs) {
          Map<String, dynamic> data = element.data() as Map<String, dynamic>;
          print("Data is $data");
          Reviews reviews = Reviews.fromJson(data);
          print(reviews.userId);
          reviewsList.add(reviews);
          UserData userData = await loadUserData(reviews);
          userDataList.add(userData);
        }
      }


      isLoadding = false;
      update();
    } catch (e) {
      print("Error loading services review: $e");
    }
  }


  loadUserData(Reviews reviews) async {
    String userid = reviews.userId;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection("User");
    QuerySnapshot userData = await collectionReference.where("uId", isEqualTo: userid).get();
    if (userData.docs.isNotEmpty) {
      return UserData.fromJson(userData.docs.first.data() as Map<String, dynamic>);
    } else {
      return [];
    }
  }

}
