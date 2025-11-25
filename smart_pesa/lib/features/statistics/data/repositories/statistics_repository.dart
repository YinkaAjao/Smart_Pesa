import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatisticsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  Stream<List<Map<String, dynamic>>> getMonthlyExpenses() {
    if (_userId.isEmpty) return Stream.value([]);
    
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return _firestore.collection('users')
        .doc(_userId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .where((doc) {
                final data = doc.data();
                if (data['date'] is Timestamp) {
                  final date = (data['date'] as Timestamp).toDate();
                  return date.isAfter(startOfMonth.subtract(const Duration(days: 1))) && 
                         date.isBefore(endOfMonth.add(const Duration(days: 1)));
                }
                return false;
              })
              .map((doc) => doc.data())
              .toList();
        });
  }
}