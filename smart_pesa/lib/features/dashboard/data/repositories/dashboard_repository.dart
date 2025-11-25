import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DashboardRepository({
    FirebaseFirestore? firestore, 
    FirebaseAuth? auth
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _auth = auth ?? FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Stream<double> getTotalExpenses() {
    if (_userId.isEmpty) return Stream.value(0.0);
    return _firestore.collection('users').doc(_userId).collection('expenses')
        .snapshots()
        .map((s) => s.docs.fold(0.0, (total, doc) => total + (doc.data()['amount'] ?? 0.0)));
  }

  Stream<double> getTotalIncome() {
    if (_userId.isEmpty) return Stream.value(0.0);
    return _firestore.collection('users').doc(_userId).collection('income')
        .snapshots()
        .map((s) => s.docs.fold(0.0, (total, doc) => total + (doc.data()['amount'] ?? 0.0)));
  }

  Stream<double> getTotalSavings() {
    if (_userId.isEmpty) return Stream.value(0.0);
    return _firestore.collection('users').doc(_userId).collection('savings')
        .snapshots()
        .map((s) => s.docs.fold(0.0, (total, doc) => total + (doc.data()['amount'] ?? 0.0)));
  }

  Stream<double> getUserTaxRate() {
    if (_userId.isEmpty) return Stream.value(0.0);
    return _firestore.collection('users').doc(_userId).snapshots()
        .map((doc) => (doc.data()?['tax_rate'] ?? 0.0).toDouble());
  }

  Stream<List<Map<String, dynamic>>> getRecentTransactions() {
    if (_userId.isEmpty) return Stream.value([]);
    return _firestore.collection('users').doc(_userId).collection('expenses')
        .orderBy('date', descending: true)
        .limit(5)
        .snapshots()
        .map((s) => s.docs.map((doc) => doc.data()).toList());
  }
}