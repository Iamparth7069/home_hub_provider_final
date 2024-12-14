import 'package:cloud_firestore/cloud_firestore.dart';

class OrderResModel {
  final String? userId;
  final String? serviceProviderId;
  final DateTime? createdAt;
  final DateTime? completeDate;
  String? status;
  final String? paymentStatus;
  final String? subServiceId;
  final String? orderId;
  final String? offerId;
  final int? amount;
  final String? servicesName;
  final String? transactionId;

  OrderResModel({
    this.userId,
    this.serviceProviderId,
    this.servicesName,
    this.createdAt,
    this.completeDate,
    this.status,
    this.paymentStatus,
    this.subServiceId,
    this.orderId,
    this.transactionId,
    this.amount,
    this.offerId,
  });

  factory OrderResModel.fromJson(Map<String, dynamic> json) => OrderResModel(
    userId: json['userId'] ?? "",
    servicesName: json["serviceName"] ?? "",
    serviceProviderId: json['serviceProviderId'] ?? "",
    createdAt: (json['createdAt'] as Timestamp).toDate(),
    completeDate: (json['complete_date'] as Timestamp).toDate(),
    status: json['status'] ?? "",
    paymentStatus: json['paymentStatus'] ?? "",
    subServiceId: json['subServiceId'] ?? "",
    orderId: json['orderId'] ?? "",
    offerId: json['offerId'] ?? "",
    amount: json['amount'] ?? 0,
    transactionId: json['transactionId'] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "serviceName" : servicesName ?? "",
    'userId': userId ?? "",
    'serviceProviderId': serviceProviderId ?? "",
    'createdAt': Timestamp.fromDate(createdAt!),
    'complete_date': Timestamp.fromDate(completeDate!),
    'status': status,
    'paymentStatus': paymentStatus,
    'subServiceId': subServiceId,
    'orderId': orderId,
    'offerId': offerId,
    'amount': amount,
    'transactionId': transactionId,
  };
}
