import 'package:equatable/equatable.dart';

/// Base class for all expense events
abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all expenses
class ExpenseLoadAll extends ExpenseEvent {
  const ExpenseLoadAll();
}

/// Event to load today's expenses
class ExpenseLoadToday extends ExpenseEvent {
  const ExpenseLoadToday();
}

/// Event to load this month's expenses
class ExpenseLoadThisMonth extends ExpenseEvent {
  const ExpenseLoadThisMonth();
}

/// Event to load expenses by date range
class ExpenseLoadByDateRange extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  const ExpenseLoadByDateRange({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Event to load expenses by category
class ExpenseLoadByCategory extends ExpenseEvent {
  final String category;

  const ExpenseLoadByCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

/// Event to create a new expense
class ExpenseCreate extends ExpenseEvent {
  final String category;
  final String description;
  final double amount;
  final String currency;
  final String currencySymbol;
  final DateTime date;

  const ExpenseCreate({
    required this.category,
    required this.description,
    required this.amount,
    required this.currency,
    required this.currencySymbol,
    required this.date,
  });

  @override
  List<Object?> get props => [category, description, amount, currency, date];
}

/// Event to update an expense
class ExpenseUpdate extends ExpenseEvent {
  final String id;
  final String? category;
  final String? description;
  final double? amount;
  final String? currency;
  final DateTime? date;

  const ExpenseUpdate({
    required this.id,
    this.category,
    this.description,
    this.amount,
    this.currency,
    this.date,
  });

  @override
  List<Object?> get props => [id, category, description, amount, currency, date];
}

/// Event to delete an expense
class ExpenseDelete extends ExpenseEvent {
  final String id;

  const ExpenseDelete({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to get expense by ID
class ExpenseLoadById extends ExpenseEvent {
  final String id;

  const ExpenseLoadById({required this.id});

  @override
  List<Object?> get props => [id];
}

/// Event to load category totals
class ExpenseLoadCategoryTotals extends ExpenseEvent {
  final DateTime startDate;
  final DateTime endDate;

  const ExpenseLoadCategoryTotals({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

/// Event to subscribe to expense stream
class ExpenseSubscribeToStream extends ExpenseEvent {
  const ExpenseSubscribeToStream();
}

