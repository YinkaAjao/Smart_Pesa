import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/expense_entity.dart';

/// Firestore Expense Data Source
/// Handles all Firestore operations for expenses
class FirestoreExpenseDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreExpenseDataSource({
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

  /// Get expenses collection reference for current user
  CollectionReference get _expensesCollection {
    return _firestore.collection('users/$_currentUserId/expenses');
  }

  /// Create a new expense
  Future<ExpenseEntity> createExpense({
    required String category,
    required String description,
    required double amount,
    required String currency,
    required String currencySymbol,
    required DateTime date,
  }) async {
    final now = DateTime.now();
    final docRef = _expensesCollection.doc();

    final data = {
      'id': docRef.id,
      'userId': _currentUserId,
      'category': category,
      'description': description,
      'amount': amount,
      'currency': currency,
      'currencySymbol': currencySymbol,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    };

    await docRef.set(data);

    return _expenseFromMap(data);
  }

  /// Get expense by ID
  Future<ExpenseEntity> getExpenseById(String id) async {
    final doc = await _expensesCollection.doc(id).get();

    if (!doc.exists) {
      throw Exception('Expense not found');
    }

    return _expenseFromMap(doc.data() as Map<String, dynamic>);
  }

  /// Get all expenses for current user
  Future<List<ExpenseEntity>> getAllExpenses() async {
    final querySnapshot = await _expensesCollection
        .orderBy('date', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => _expenseFromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get expenses by date range
  Future<List<ExpenseEntity>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final querySnapshot = await _expensesCollection
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .orderBy('date', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => _expenseFromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get expenses by category
  Future<List<ExpenseEntity>> getExpensesByCategory(String category) async {
    final querySnapshot = await _expensesCollection
        .where('category', isEqualTo: category)
        .orderBy('date', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => _expenseFromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get today's expenses
  Future<List<ExpenseEntity>> getTodayExpenses() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return getExpensesByDateRange(
      startDate: startOfDay,
      endDate: endOfDay,
    );
  }

  /// Get this month's expenses
  Future<List<ExpenseEntity>> getThisMonthExpenses() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return getExpensesByDateRange(
      startDate: startOfMonth,
      endDate: endOfMonth,
    );
  }

  /// Update an expense
  Future<ExpenseEntity> updateExpense({
    required String id,
    String? category,
    String? description,
    double? amount,
    String? currency,
    DateTime? date,
  }) async {
    final docRef = _expensesCollection.doc(id);
    final doc = await docRef.get();

    if (!doc.exists) {
      throw Exception('Expense not found');
    }

    final updateData = <String, dynamic>{
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    };

    if (category != null) updateData['category'] = category;
    if (description != null) updateData['description'] = description;
    if (amount != null) updateData['amount'] = amount;
    if (currency != null) updateData['currency'] = currency;
    if (date != null) updateData['date'] = Timestamp.fromDate(date);

    await docRef.update(updateData);

    final updatedDoc = await docRef.get();
    return _expenseFromMap(updatedDoc.data() as Map<String, dynamic>);
  }

  /// Delete an expense
  Future<void> deleteExpense(String id) async {
    await _expensesCollection.doc(id).delete();
  }

  /// Stream of expense changes (real-time updates)
  Stream<List<ExpenseEntity>> get expenseStream {
    return _expensesCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => _expenseFromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  /// Convert Firestore document to ExpenseEntity
  ExpenseEntity _expenseFromMap(Map<String, dynamic> data) {
    return ExpenseEntity(
      id: data['id'] as String,
      userId: data['userId'] as String,
      category: data['category'] as String,
      description: data['description'] as String,
      amount: (data['amount'] as num).toDouble(),
      currency: data['currency'] as String? ?? 'Rwf',
      currencySymbol: data['currencySymbol'] as String? ?? 'Rwf',
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}

