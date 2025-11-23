import 'package:dartz/dartz.dart';
import '../entities/expense_entity.dart';

/// Expense repository interface
/// Defines all expense-related CRUD operations
abstract class ExpenseRepository {
  /// Create a new expense
  /// Returns Either<String, ExpenseEntity> where:
  /// - Left: error message
  /// - Right: created expense
  Future<Either<String, ExpenseEntity>> createExpense({
    required String category,
    required String description,
    required double amount,
    required String currency,
    required DateTime date,
  });

  /// Get expense by ID
  Future<Either<String, ExpenseEntity>> getExpenseById(String id);

  /// Get all expenses for current user
  Future<Either<String, List<ExpenseEntity>>> getAllExpenses();

  /// Get expenses for a specific date range
  Future<Either<String, List<ExpenseEntity>>> getExpensesByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get expenses for a specific category
  Future<Either<String, List<ExpenseEntity>>> getExpensesByCategory(
    String category,
  );

  /// Get today's expenses
  Future<Either<String, List<ExpenseEntity>>> getTodayExpenses();

  /// Get this month's expenses
  Future<Either<String, List<ExpenseEntity>>> getThisMonthExpenses();

  /// Update an existing expense
  Future<Either<String, ExpenseEntity>> updateExpense({
    required String id,
    String? category,
    String? description,
    double? amount,
    String? currency,
    DateTime? date,
  });

  /// Delete an expense
  Future<Either<String, void>> deleteExpense(String id);

  /// Stream of expense changes (real-time updates)
  Stream<List<ExpenseEntity>> get expenseStream;

  /// Get total amount for a date range
  Future<Either<String, double>> getTotalAmount({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get expenses grouped by category
  Future<Either<String, Map<String, List<ExpenseEntity>>>>
      getExpensesGroupedByCategory({
    required DateTime startDate,
    required DateTime endDate,
  });

  /// Get category totals
  Future<Either<String, Map<String, double>>> getCategoryTotals({
    required DateTime startDate,
    required DateTime endDate,
  });
}

