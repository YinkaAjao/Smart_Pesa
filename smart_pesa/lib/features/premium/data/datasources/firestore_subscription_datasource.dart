import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/subscription_entity.dart';

/// Firestore Subscription Data Source
/// Handles all Firestore operations for subscriptions
class FirestoreSubscriptionDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreSubscriptionDataSource({
    required FirebaseFirestore firestore,
    required FirebaseAuth firebaseAuth,
  })  : _firestore = firestore,
        _firebaseAuth = firebaseAuth;

  /// Get current user ID
  String get _currentUserId {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not authenticated');
    }
    return userId;
  }

  /// Get subscription document reference for current user
  DocumentReference get _subscriptionDoc {
    return _firestore.collection('subscriptions').doc(_currentUserId);
  }

  /// Get current subscription
  Future<SubscriptionEntity?> getCurrentSubscription() async {
    final doc = await _subscriptionDoc.get();

    if (!doc.exists) {
      return null;
    }

    return _subscriptionFromMap(doc.data() as Map<String, dynamic>);
  }

  /// Subscribe to a plan
  Future<SubscriptionEntity> subscribe({
    required SubscriptionPlan plan,
  }) async {
    final now = DateTime.now();
    DateTime expiryDate;
    double price;

    // Calculate expiry date and price based on plan
    switch (plan) {
      case SubscriptionPlan.monthly:
        expiryDate = DateTime(now.year, now.month + 1, now.day);
        price = 10.0;
        break;
      case SubscriptionPlan.yearly:
        expiryDate = DateTime(now.year + 1, now.month, now.day);
        price = 54.0;
        break;
      case SubscriptionPlan.free:
        expiryDate = DateTime(now.year, now.month, now.day);
        price = 0.0;
        break;
    }

    final data = {
      'id': _currentUserId,
      'userId': _currentUserId,
      'plan': plan.toString().split('.').last,
      'price': price,
      'currency': 'USD',
      'startDate': Timestamp.fromDate(now),
      'expiryDate': Timestamp.fromDate(expiryDate),
      'isActive': true,
      'autoRenew': true,
      'createdAt': Timestamp.fromDate(now),
    };

    await _subscriptionDoc.set(data);

    return _subscriptionFromMap(data);
  }

  /// Cancel subscription
  Future<void> cancelSubscription() async {
    await _subscriptionDoc.update({
      'isActive': false,
      'autoRenew': false,
    });
  }

  /// Check if user has active premium
  Future<bool> isPremiumActive() async {
    final subscription = await getCurrentSubscription();
    return subscription?.isValid ?? false;
  }

  /// Stream of subscription changes
  Stream<SubscriptionEntity?> get subscriptionStream {
    return _subscriptionDoc.snapshots().map((doc) {
      if (!doc.exists) return null;
      return _subscriptionFromMap(doc.data() as Map<String, dynamic>);
    });
  }

  /// Get subscription plans and pricing
  Future<Map<SubscriptionPlan, double>> getPlans() async {
    // In a real app, this would fetch from Firestore or a pricing API
    return {
      SubscriptionPlan.monthly: 10.0,
      SubscriptionPlan.yearly: 54.0,
    };
  }

  /// Update auto-renewal setting
  Future<SubscriptionEntity> updateAutoRenew(bool autoRenew) async {
    await _subscriptionDoc.update({'autoRenew': autoRenew});

    final doc = await _subscriptionDoc.get();
    return _subscriptionFromMap(doc.data() as Map<String, dynamic>);
  }

  /// Restore previous purchase
  /// This would typically integrate with in-app purchase systems
  Future<SubscriptionEntity?> restorePurchase() async {
    // For now, just return current subscription
    // In a real app, this would verify with app stores
    return getCurrentSubscription();
  }

  /// Convert Firestore document to SubscriptionEntity
  SubscriptionEntity _subscriptionFromMap(Map<String, dynamic> data) {
    return SubscriptionEntity(
      id: data['id'] as String,
      userId: data['userId'] as String,
      plan: _planFromString(data['plan'] as String),
      price: (data['price'] as num).toDouble(),
      currency: data['currency'] as String? ?? 'USD',
      startDate: (data['startDate'] as Timestamp).toDate(),
      expiryDate: (data['expiryDate'] as Timestamp).toDate(),
      isActive: data['isActive'] as bool? ?? true,
      autoRenew: data['autoRenew'] as bool? ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Convert string to SubscriptionPlan enum
  SubscriptionPlan _planFromString(String planString) {
    switch (planString.toLowerCase()) {
      case 'monthly':
        return SubscriptionPlan.monthly;
      case 'yearly':
        return SubscriptionPlan.yearly;
      default:
        return SubscriptionPlan.free;
    }
  }
}

