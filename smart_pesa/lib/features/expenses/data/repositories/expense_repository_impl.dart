import 'package:dartz/dartz.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/firestore_expense_datasource.dart';

/// Implementation of ExpenseRepository
/// Wraps FirestoreExpenseDataSource and handles error conversion
class ExpenseRepositoryImpl implements ExpenseRepository {
  final FirestoreExpenseDataSource _expenseDataSource;

  ExpenseRepositoryImpl({required FirestoreExpenseDataSource expenseDataSource})
      : _expenseDataSource = expenseDataSource;

  @override
  Future<Either<String, ExpenseEntity>> createExpense({
    required String category,
    required String description,
    required double amount,
    required String currency,
    required String currencySymbol,
    required DateTime date,
  }) async {
    try {
      final expense = await _expenseDataSource.createExpense(
        category: category,
        description: description,
        amount: amount,
        currency: currency,
        currencySymbol: currencySymbol,
        date: date,
      );
      return Right(expense);
    } catch (e) {
      return Left('Failed to create expense: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ExpenseEntity>> getExpenseById(String id) async {
    try {
      final expense = await _expenseDataSource.getExpenseById(id);
      return Right(expense);
    } catch (e) {
      return Left('Failed to get expense: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<ExpenseEntity>>> getAllExpenses() async {
    try {
      final expenses = await _expenseDataSource.getAllExpenses();
      return Right(expenses);
    } catch (e) {
      return Left('Failed to get expenses: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<ExpenseEntity>>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final expenses = await _expenseDataSource.getExpensesByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
      return Right(expenses);
    } catch (e) {
      return Left('Failed to get expenses: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<ExpenseEntity>>> getExpensesByCategory(
    String category,
  ) async {
    try {
      final expenses = await _expenseDataSource.getExpensesByCategory(category);
      return Right(expenses);
    } catch (e) {
      return Left('Failed to get expenses: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<ExpenseEntity>>> getTodayExpenses() async {
    try {
      final expenses = await _expenseDataSource.getTodayExpenses();
      return Right(expenses);
    } catch (e) {
      return Left('Failed to get today\'s expenses: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<ExpenseEntity>>> getThisMonthExpenses() async {
    try {
      final expenses = await _expenseDataSource.getThisMonthExpenses();
      return Right(expenses);
    } catch (e) {
      return Left('Failed to get this month\'s expenses: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, ExpenseEntity>> updateExpense({
    required String id,
    String? category,
    String? description,
    double? amount,
    String? currency,
    DateTime? date,
  }) async {
    try {
      final expense = await _expenseDataSource.updateExpense(
        id: id,
        category: category,
        description: description,
        amount: amount,
        currency: currency,
        date: date,
      );
      return Right(expense);
    } catch (e) {
      return Left('Failed to update expense: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> deleteExpense(String id) async {
    try {
      await _expenseDataSource.deleteExpense(id);
      return const Right(null);
    } catch (e) {
      return Left('Failed to delete expense: ${e.toString()}');
    }
  }

  @override
  Stream<List<ExpenseEntity>> get expenseStream {
    return _expenseDataSource.expenseStream;
  }

  @override
  Future<Either<String, double>> getTotalAmount({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final expenses = await _expenseDataSource.getExpensesByDateRange(
        startDate: startDate,
        endDate: endDate,
      );
      final total = expenses.fold(0.0, (sum, expense) => sum + expense.amount);
      return Right(total);
    } catch (e) {
      return Left('Failed to calculate total: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Map<String, List<ExpenseEntity>>>>
      getExpensesGroupedByCategory({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final expenses = await _expenseDataSource.getExpensesByDateRange(
        startDate: startDate,
        endDate: endDate,
      );

      final grouped = <String, List<ExpenseEntity>>{};
      for (final expense in expenses) {
        if (!grouped.containsKey(expense.category)) {
          grouped[expense.category] = [];
        }
        grouped[expense.category]!.add(expense);
      }

      return Right(grouped);
    } catch (e) {
      return Left('Failed to group expenses: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, Map<String, double>>> getCategoryTotals({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final expenses = await _expenseDataSource.getExpensesByDateRange(
        startDate: startDate,
        endDate: endDate,
      );

      final totals = <String, double>{};
      for (final expense in expenses) {
        totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
      }

      return Right(totals);
    } catch (e) {
      return Left('Failed to calculate category totals: ${e.toString()}');
    }
  }
}

