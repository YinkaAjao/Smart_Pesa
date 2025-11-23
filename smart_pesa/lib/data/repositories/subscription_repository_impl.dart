import 'package:dartz/dartz.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/firestore_subscription_datasource.dart';

/// Implementation of SubscriptionRepository
/// Wraps FirestoreSubscriptionDataSource and handles error conversion
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final FirestoreSubscriptionDataSource _subscriptionDataSource;

  SubscriptionRepositoryImpl({
    required FirestoreSubscriptionDataSource subscriptionDataSource,
  }) : _subscriptionDataSource = subscriptionDataSource;

  @override
  Future<Either<String, SubscriptionEntity?>> getCurrentSubscription() async {
    try {
      final subscription =
          await _subscriptionDataSource.getCurrentSubscription();
      return Right(subscription);
    } catch (e) {
      return Left('Failed to get subscription: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, SubscriptionEntity>> subscribe({
    required SubscriptionPlan plan,
  }) async {
    try {
      final subscription = await _subscriptionDataSource.subscribe(plan: plan);
      return Right(subscription);
    } catch (e) {
      return Left('Failed to subscribe: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> cancelSubscription() async {
    try {
      await _subscriptionDataSource.cancelSubscription();
      return const Right(null);
    } catch (e) {
      return Left('Failed to cancel subscription: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, SubscriptionEntity?>> restorePurchase() async {
    try {
      final subscription = await _subscriptionDataSource.restorePurchase();
      return Right(subscription);
    } catch (e) {
      return Left('Failed to restore purchase: ${e.toString()}');
    }
  }

  @override
  Future<bool> isPremiumActive() async {
    try {
      return await _subscriptionDataSource.isPremiumActive();
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<SubscriptionEntity?> get subscriptionStream {
    return _subscriptionDataSource.subscriptionStream;
  }

  @override
  Future<Either<String, Map<SubscriptionPlan, double>>> getPlans() async {
    try {
      final plans = await _subscriptionDataSource.getPlans();
      return Right(plans);
    } catch (e) {
      return Left('Failed to get plans: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, SubscriptionEntity>> updateAutoRenew(
    bool autoRenew,
  ) async {
    try {
      final subscription =
          await _subscriptionDataSource.updateAutoRenew(autoRenew);
      return Right(subscription);
    } catch (e) {
      return Left('Failed to update auto-renew: ${e.toString()}');
    }
  }
}

