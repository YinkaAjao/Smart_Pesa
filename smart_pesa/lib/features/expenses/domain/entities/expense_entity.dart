import 'package:equatable/equatable.dart';

/// Expense entity representing a single expense transaction
/// Domain layer - framework independent
class ExpenseEntity extends Equatable {
  final String id;
  final String userId;
  final String category;
  final String description;
  final double amount;
  final String currency;
  final String currencySymbol;
  final DateTime date;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ExpenseEntity({
    required this.id,
    required this.userId,
    required this.category,
    required this.description,
    required this.amount,
    required this.currency,
    required this.currencySymbol,
    required this.date,
    required this.createdAt,
    this.updatedAt,
  });

  /// Get formatted amount with currency
  String get formattedAmount {
    return '${amount.toStringAsFixed(0)} $currency';
  }

  /// Check if expense is from today
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if expense is from this month
  bool get isThisMonth {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        category,
        description,
        amount,
        currency,
        date,
        createdAt,
        updatedAt,
      ];

  ExpenseEntity copyWith({
    String? id,
    String? userId,
    String? category,
    String? description,
    double? amount,
    String? currency,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

