import 'package:equatable/equatable.dart';
import '../../domain/entities/subscription_entity.dart';

/// Base class for all subscription states
abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SubscriptionInitial extends SubscriptionState {
  const SubscriptionInitial();
}

/// State when subscription data is being loaded
class SubscriptionLoading extends SubscriptionState {
  const SubscriptionLoading();
}

/// State when user has no active subscription (free tier)
class SubscriptionFree extends SubscriptionState {
  const SubscriptionFree();
}

/// State when user has active subscription
class SubscriptionActive extends SubscriptionState {
  final SubscriptionEntity subscription;

  const SubscriptionActive({required this.subscription});

  @override
  List<Object?> get props => [subscription];

  /// Helper to check if subscription is about to expire (less than 7 days)
  bool get isExpiringSoon {
    return subscription.daysRemaining <= 7 && subscription.daysRemaining > 0;
  }
}

/// State when subscription has expired
class SubscriptionExpired extends SubscriptionState {
  final SubscriptionEntity subscription;

  const SubscriptionExpired({required this.subscription});

  @override
  List<Object?> get props => [subscription];
}

/// State when subscription operation fails
class SubscriptionError extends SubscriptionState {
  final String message;

  const SubscriptionError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when subscribing to a plan
class SubscriptionSubscribing extends SubscriptionState {
  final SubscriptionPlan plan;

  const SubscriptionSubscribing({required this.plan});

  @override
  List<Object?> get props => [plan];
}

/// State when subscription is successful
class SubscriptionSubscribed extends SubscriptionState {
  final SubscriptionEntity subscription;

  const SubscriptionSubscribed({required this.subscription});

  @override
  List<Object?> get props => [subscription];
}

/// State when canceling subscription
class SubscriptionCanceling extends SubscriptionState {
  const SubscriptionCanceling();
}

/// State when subscription is canceled
class SubscriptionCanceled extends SubscriptionState {
  const SubscriptionCanceled();
}

/// State when restoring purchase
class SubscriptionRestoring extends SubscriptionState {
  const SubscriptionRestoring();
}

/// State when purchase is restored
class SubscriptionRestored extends SubscriptionState {
  final SubscriptionEntity? subscription;

  const SubscriptionRestored({this.subscription});

  @override
  List<Object?> get props => [subscription];
}

/// State when pricing plans are loaded
class SubscriptionPlansLoaded extends SubscriptionState {
  final Map<SubscriptionPlan, double> plans;

  const SubscriptionPlansLoaded({required this.plans});

  @override
  List<Object?> get props => [plans];

  /// Get price for a specific plan
  double? getPlanPrice(SubscriptionPlan plan) {
    return plans[plan];
  }

  /// Get formatted price for a plan
  String getFormattedPrice(SubscriptionPlan plan) {
    final price = plans[plan];
    if (price == null) return 'N/A';

    if (plan == SubscriptionPlan.yearly) {
      return '\$${(price / 12).toStringAsFixed(1)} /m';
    }
    return '\$${price.toStringAsFixed(0)} /m';
  }
}

