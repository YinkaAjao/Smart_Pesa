import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionModel {
  final String uid;
  final String planType;
  final DateTime startDate;
  final DateTime endDate;

  SubscriptionModel({
    required this.uid,
    required this.planType,
    required this.startDate,
    required this.endDate,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        uid: json['uid'],
        planType: json['planType'],
        startDate: (json['startDate'] as Timestamp).toDate(),
        endDate: (json['endDate'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'planType': planType,
        'startDate': startDate,
        'endDate': endDate,
      };
}

