import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String category;
  final double amount;
  final DateTime date;
  final String note;

  ExpenseModel({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json['id'],
        category: json['category'],
        amount: json['amount'],
        date: (json['date'] as Timestamp).toDate(),
        note: json['note'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'amount': amount,
        'date': date,
        'note': note,
      };
}