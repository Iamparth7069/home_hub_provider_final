
import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceResponseModel {
  String serviceStatus;
  final DateTime createdAt;
  final double averageRating;
  final List<String> images;
  final String address;
  final String categoryName;
  final String serviceName;
  final int price;
  final String description;
  final int totalRating;
  String? serviceIds;
  final String userName;
  final String userId;
  List? savedBy;
  ServiceResponseModel({
    required this.serviceStatus,
    required this.savedBy,
    required this.createdAt,
    required this.averageRating,
    required this.images,
    required this.address,
    required this.categoryName,
    required this.serviceName,
    required this.price,
    required this.description,
    required this.totalRating,
    required this.serviceIds,
    required this.userName,
    required this.userId,
  });


  factory ServiceResponseModel.fromMap(Map<String, dynamic> map) {
    return ServiceResponseModel(
      serviceStatus: map["serviceStatus"]?? "",
      savedBy: List<String>.from(map['sendBy'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      averageRating: map['average_rating'].toDouble(),
      images: List<String>.from(map['images']),
      address: map['address'],
      categoryName: map['category_name'],
      serviceName: map['service_name'],
      price: map['price'],
      description: map['description'],
      totalRating: map['total_rating'],
      serviceIds: map['service_ids'],
      userName: map['userName'],
      userId: map['userId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'serviceStatus' : serviceStatus,
      'savedBy' : savedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'average_rating': averageRating,
      'images': images,
      'address': address,
      'category_name': categoryName,
      'service_name': serviceName,
      'price': price,
      'description': description,
      'total_rating': totalRating,
      'service_ids': serviceIds,
      'userName': userName,
      'userId': userId,
    };
  }
}