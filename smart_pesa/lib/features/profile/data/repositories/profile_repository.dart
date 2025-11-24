import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get userId => _auth.currentUser?.uid ?? '';

  Future<void> updateVitalInfo({
    required double income,
    required double taxRate,
    required double savingsGoal,
  }) async {
    if (userId.isEmpty) return;

    final batch = _firestore.batch();
    final userDoc = _firestore.collection('users').doc(userId);

    // 1. Update Tax Rate on User Doc
    batch.set(userDoc, {'tax_rate': taxRate}, SetOptions(merge: true));

    // 2. Update Income (Simplified: Single source for now)
    final incomeDoc = userDoc.collection('income').doc('primary_income');
    batch.set(incomeDoc, {
      'amount': income,
      'date': FieldValue.serverTimestamp(),
    });

    // 3. Update Savings Goal
    final savingsDoc = userDoc.collection('savings').doc('primary_goal');
    batch.set(savingsDoc, {
      'amount': savingsGoal,
      'date': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  // Get current values to pre-fill the form
  Future<Map<String, double>> loadVitalInfo() async {
    if (userId.isEmpty) return {};

    double tax = 0;
    double income = 0;
    double savings = 0;

    // Fetch Tax
    final userSnapshot = await _firestore.collection('users').doc(userId).get();
    tax = (userSnapshot.data()?['tax_rate'] ?? 0.0).toDouble();

    // Fetch Income
    final incomeSnapshot = await _firestore.collection('users').doc(userId).collection('income').doc('primary_income').get();
    income = (incomeSnapshot.data()?['amount'] ?? 0.0).toDouble();

    // Fetch Savings
    final savingsSnapshot = await _firestore.collection('users').doc(userId).collection('savings').doc('primary_goal').get();
    savings = (savingsSnapshot.data()?['amount'] ?? 0.0).toDouble();

    return {'tax': tax, 'income': income, 'savings': savings};
  }
}