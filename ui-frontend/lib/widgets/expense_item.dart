import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  final String title;
  final double amount;

  const ExpenseItem({
    super.key,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.receipt_long),
        title: Text(title),
        trailing: Text('\$${amount.toStringAsFixed(2)}'),
      ),
    );
  }
}