import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/subscription_repository.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

/// SubscriptionBloc - Manages premium subscription state
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final SubscriptionRepository _subscriptionRepository;
  StreamSubscription? _subscriptionStreamSubscription;

  SubscriptionBloc({required SubscriptionRepository subscriptionRepository})
      : _subscriptionRepository = subscriptionRepository,
        super(const SubscriptionInitial()) {
    // Register event handlers
    on<SubscriptionLoadCurrent>(_onLoadCurrent);
    on<SubscriptionCheckPremium>(_onCheckPremium);
    on<SubscriptionSubscribe>(_onSubscribe);
    on<SubscriptionCancel>(_onCancel);
    on<SubscriptionRestore>(_onRestore);
    on<SubscriptionLoadPlans>(_onLoadPlans);
    on<SubscriptionUpdateAutoRenew>(_onUpdateAutoRenew);
    on<SubscriptionSubscribeToStream>(_onSubscribeToStream);
  }

  /// Load current subscription
  Future<void> _onLoadCurrent(
    SubscriptionLoadCurrent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());

    final result = await _subscriptionRepository.getCurrentSubscription();

    result.fold(
      (error) => emit(SubscriptionError(message: error)),
      (subscription) {
        if (subscription == null) {
          emit(const SubscriptionFree());
        } else if (subscription.isValid) {
          emit(SubscriptionActive(subscription: subscription));
        } else {
          emit(SubscriptionExpired(subscription: subscription));
        }
      },
    );
  }

  /// Check premium status
  Future<void> _onCheckPremium(
    SubscriptionCheckPremium event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());

    final isPremium = await _subscriptionRepository.isPremiumActive();

    if (isPremium) {
      // Load full subscription details
      final result = await _subscriptionRepository.getCurrentSubscription();
      result.fold(
        (error) => emit(SubscriptionError(message: error)),
        (subscription) {
          if (subscription != null) {
            emit(SubscriptionActive(subscription: subscription));
          } else {
            emit(const SubscriptionFree());
          }
        },
      );
    } else {
      emit(const SubscriptionFree());
    }
  }

  /// Subscribe to a plan
  Future<void> _onSubscribe(
    SubscriptionSubscribe event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(SubscriptionSubscribing(plan: event.plan));

    final result = await _subscriptionRepository.subscribe(plan: event.plan);

    result.fold(
      (error) => emit(SubscriptionError(message: error)),
      (subscription) {
        emit(SubscriptionSubscribed(subscription: subscription));
        // Update to active state
        emit(SubscriptionActive(subscription: subscription));
      },
    );
  }

  /// Cancel subscription
  Future<void> _onCancel(
    SubscriptionCancel event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionCanceling());

    final result = await _subscriptionRepository.cancelSubscription();

    result.fold(
      (error) => emit(SubscriptionError(message: error)),
      (_) {
        emit(const SubscriptionCanceled());
        // Update to free state
        emit(const SubscriptionFree());
      },
    );
  }

  /// Restore previous purchase
  Future<void> _onRestore(
    SubscriptionRestore event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionRestoring());

    final result = await _subscriptionRepository.restorePurchase();

    result.fold(
      (error) => emit(SubscriptionError(message: error)),
      (subscription) {
        emit(SubscriptionRestored(subscription: subscription));

        // Update state based on restored subscription
        if (subscription == null) {
          emit(const SubscriptionFree());
        } else if (subscription.isValid) {
          emit(SubscriptionActive(subscription: subscription));
        } else {
          emit(SubscriptionExpired(subscription: subscription));
        }
      },
    );
  }

  /// Load available pricing plans
  Future<void> _onLoadPlans(
    SubscriptionLoadPlans event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());

    final result = await _subscriptionRepository.getPlans();

    result.fold(
      (error) => emit(SubscriptionError(message: error)),
      (plans) => emit(SubscriptionPlansLoaded(plans: plans)),
    );
  }

  /// Update auto-renewal setting
  Future<void> _onUpdateAutoRenew(
    SubscriptionUpdateAutoRenew event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());

    final result = await _subscriptionRepository.updateAutoRenew(
      event.autoRenew,
    );

    result.fold(
      (error) => emit(SubscriptionError(message: error)),
      (subscription) => emit(SubscriptionActive(subscription: subscription)),
    );
  }

  /// Subscribe to real-time subscription stream
  Future<void> _onSubscribeToStream(
    SubscriptionSubscribeToStream event,
    Emitter<SubscriptionState> emit,
  ) async {
    await _subscriptionStreamSubscription?.cancel();

    _subscriptionStreamSubscription =
        _subscriptionRepository.subscriptionStream.listen(
      (subscription) {
        if (subscription == null) {
          emit(const SubscriptionFree());
        } else if (subscription.isValid) {
          emit(SubscriptionActive(subscription: subscription));
        } else {
          emit(SubscriptionExpired(subscription: subscription));
        }
      },
      onError: (error) {
        emit(SubscriptionError(message: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _subscriptionStreamSubscription?.cancel();
    return super.close();
  }
}

