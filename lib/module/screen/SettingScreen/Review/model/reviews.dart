

import 'package:cloud_firestore/cloud_firestore.dart';

class Reviews{
  String userId;
  String orderId;
  double ratings;
  String description;
  String serviceId;
  final List<String> whatsLike;
  final DateTime createdAt;


  Reviews(
      {required this.userId,
        required this.orderId,
        required this.ratings,
        required this.description,
        required this.serviceId,
        required this.whatsLike,
        required this.createdAt});

  Map<String, dynamic> toJson() {
    return {
      "userId": this.userId,
      "orderId": this.orderId,
      "ratings": this.ratings,
      "description": this.description,
      "serviceId": this.serviceId,
      "whatLike":this.whatsLike,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Reviews.fromJson(Map<String, dynamic> json) {
    return Reviews(
      userId: json["userId"],
      orderId: json["orderId"],
      ratings: json["ratings"],
      description: json["description"],
      serviceId: json["serviceId"],
      whatsLike:  List<String>.from(json['whatLike']),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }
//
}