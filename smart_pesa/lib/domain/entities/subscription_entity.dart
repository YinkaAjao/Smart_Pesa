import 'package:equatable/equatable.dart';

/// Subscription plan types
enum SubscriptionPlan {
  free,
  monthly,
  yearly,
}

/// Subscription entity representing premium subscription details
class SubscriptionEntity extends Equatable {
  final String id;
  final String userId;
  final SubscriptionPlan plan;
  final double price;
  final String currency;
  final DateTime startDate;
  final DateTime expiryDate;
  final bool isActive;
  final bool autoRenew;
  final DateTime createdAt;

  const SubscriptionEntity({
    required this.id,
    required this.userId,
    required this.plan,
    required this.price,
    this.currency = 'USD',
    required this.startDate,
    required this.expiryDate,
    this.isActive = true,
    this.autoRenew = true,
    required this.createdAt,
  });

  /// Check if subscription is currently valid
  bool get isValid {
    return isActive && expiryDate.isAfter(DateTime.now());
  }

  /// Get days remaining until expiry
  int get daysRemaining {
    if (!isValid) return 0;
    return expiryDate.difference(DateTime.now()).inDays;
  }

  /// Get formatted price with currency
  String get formattedPrice {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Get price per month
  String get pricePerMonth {
    if (plan == SubscriptionPlan.yearly) {
      return '\$${(price / 12).toStringAsFixed(1)} /m';
    }
    return '\$${price.toStringAsFixed(0)} /m';
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        plan,
        price,
        currency,
        startDate,
        expiryDate,
        isActive,
        autoRenew,
        createdAt,
      ];

  SubscriptionEntity copyWith({
    String? id,
    String? userId,
    SubscriptionPlan? plan,
    double? price,
    String? currency,
    DateTime? startDate,
    DateTime? expiryDate,
    bool? isActive,
    bool? autoRenew,
    DateTime? createdAt,
  }) {
    return SubscriptionEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      plan: plan ?? this.plan,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      startDate: startDate ?? this.startDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
      autoRenew: autoRenew ?? this.autoRenew,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

