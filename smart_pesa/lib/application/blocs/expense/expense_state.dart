import 'package:equatable/equatable.dart';
import '../../../domain/entities/expense_entity.dart';

/// Base class for all expense states
abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

/// State when expenses are being loaded
class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

/// State when expenses are successfully loaded
class ExpenseLoaded extends ExpenseState {
  final List<ExpenseEntity> expenses;
  final double totalAmount;

  const ExpenseLoaded({
    required this.expenses,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [expenses, totalAmount];

  /// Helper to get expenses by category
  List<ExpenseEntity> getByCategory(String category) {
    return expenses.where((e) => e.category == category).toList();
  }

  /// Helper to calculate total for a category
  double getCategoryTotal(String category) {
    return expenses
        .where((e) => e.category == category)
        .fold(0.0, (sum, e) => sum + e.amount);
  }
}

/// State when a single expense is loaded
class ExpenseSingleLoaded extends ExpenseState {
  final ExpenseEntity expense;

  const ExpenseSingleLoaded({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// State when expense operation fails
class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when expense is being created
class ExpenseCreating extends ExpenseState {
  const ExpenseCreating();
}

/// State when expense is successfully created
class ExpenseCreated extends ExpenseState {
  final ExpenseEntity expense;

  const ExpenseCreated({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// State when expense is being updated
class ExpenseUpdating extends ExpenseState {
  const ExpenseUpdating();
}

/// State when expense is successfully updated
class ExpenseUpdated extends ExpenseState {
  final ExpenseEntity expense;

  const ExpenseUpdated({required this.expense});

  @override
  List<Object?> get props => [expense];
}

/// State when expense is being deleted
class ExpenseDeleting extends ExpenseState {
  const ExpenseDeleting();
}

/// State when expense is successfully deleted
class ExpenseDeleted extends ExpenseState {
  final String id;

  const ExpenseDeleted({required this.id});

  @override
  List<Object?> get props => [id];
}

/// State when category totals are loaded
class ExpenseCategoryTotalsLoaded extends ExpenseState {
  final Map<String, double> categoryTotals;
  final double totalAmount;

  const ExpenseCategoryTotalsLoaded({
    required this.categoryTotals,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [categoryTotals, totalAmount];
}

