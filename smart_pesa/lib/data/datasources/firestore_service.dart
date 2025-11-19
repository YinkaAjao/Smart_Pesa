import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/expense_model.dart';
import '../models/subscription_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // -------------------
  // USERS
  // -------------------
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toJson());
  }

  Future<void> deleteUser(String uid) async {
    await _db.collection('users').doc(uid).delete();
  }

  // -------------------
  // EXPENSES / TRANSACTIONS
  // -------------------
  Future<void> addExpense(String uid, ExpenseModel expense) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(expense.id)
        .set(expense.toJson());
  }

  Future<List<ExpenseModel>> getExpenses(String uid) async {
    final snapshot =
        await _db.collection('users').doc(uid).collection('transactions').get();

    return snapshot.docs.map((doc) => ExpenseModel.fromJson(doc.data())).toList();
  }

  Future<void> updateExpense(String uid, ExpenseModel expense) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(expense.id)
        .update(expense.toJson());
  }

  Future<void> deleteExpense(String uid, String expenseId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .doc(expenseId)
        .delete();
  }

  // -------------------
  // SUBSCRIPTIONS
  // -------------------
  Future<void> addSubscription(String uid, SubscriptionModel sub) async {
    await _db.collection('subscriptions').doc(uid).set(sub.toJson());
  }

  Future<SubscriptionModel?> getSubscription(String uid) async {
    final doc = await _db.collection('subscriptions').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return SubscriptionModel.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> updateSubscription(String uid, SubscriptionModel sub) async {
    await _db.collection('subscriptions').doc(uid).update(sub.toJson());
  }

  Future<void> deleteSubscription(String uid) async {
    await _db.collection('subscriptions').doc(uid).delete();
  }
}
