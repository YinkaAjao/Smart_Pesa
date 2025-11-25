import 'package:equatable/equatable.dart';
import '../../domain/entities/subscription_entity.dart';

/// Base class for all subscription events
abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load current subscription
class SubscriptionLoadCurrent extends SubscriptionEvent {
  const SubscriptionLoadCurrent();
}

/// Event to check premium status
class SubscriptionCheckPremium extends SubscriptionEvent {
  const SubscriptionCheckPremium();
}

/// Event to subscribe to a plan
class SubscriptionSubscribe extends SubscriptionEvent {
  final SubscriptionPlan plan;

  const SubscriptionSubscribe({required this.plan});

  @override
  List<Object?> get props => [plan];
}

/// Event to cancel subscription
class SubscriptionCancel extends SubscriptionEvent {
  const SubscriptionCancel();
}

/// Event to restore purchase
class SubscriptionRestore extends SubscriptionEvent {
  const SubscriptionRestore();
}

/// Event to load pricing plans
class SubscriptionLoadPlans extends SubscriptionEvent {
  const SubscriptionLoadPlans();
}

/// Event to update auto-renewal setting
class SubscriptionUpdateAutoRenew extends SubscriptionEvent {
  final bool autoRenew;

  const SubscriptionUpdateAutoRenew({required this.autoRenew});

  @override
  List<Object?> get props => [autoRenew];
}

/// Event to subscribe to subscription stream
class SubscriptionSubscribeToStream extends SubscriptionEvent {
  const SubscriptionSubscribeToStream();
}

