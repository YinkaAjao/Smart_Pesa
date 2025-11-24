import 'package:dartz/dartz.dart';
import '../entities/subscription_entity.dart';

/// Subscription repository interface
/// Defines all subscription and premium-related operations
abstract class SubscriptionRepository {
  /// Get current subscription for user
  Future<Either<String, SubscriptionEntity?>> getCurrentSubscription();

  /// Subscribe to a plan
  Future<Either<String, SubscriptionEntity>> subscribe({
    required SubscriptionPlan plan,
  });

  /// Cancel subscription
  Future<Either<String, void>> cancelSubscription();

  /// Restore previous purchase
  Future<Either<String, SubscriptionEntity?>> restorePurchase();

  /// Check if user has active premium
  Future<bool> isPremiumActive();

  /// Stream of subscription changes
  Stream<SubscriptionEntity?> get subscriptionStream;

  /// Get subscription plans and pricing
  Future<Either<String, Map<SubscriptionPlan, double>>> getPlans();

  /// Update auto-renewal setting
  Future<Either<String, SubscriptionEntity>> updateAutoRenew(bool autoRenew);
}

