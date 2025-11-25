import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/expense_repository.dart';
import 'expense_event.dart';
import 'expense_state.dart';

/// ExpenseBloc - Manages expense state and CRUD operations
class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository _expenseRepository;
  StreamSubscription? _expenseStreamSubscription;

  ExpenseBloc({required ExpenseRepository expenseRepository})
      : _expenseRepository = expenseRepository,
        super(const ExpenseInitial()) {
    // Register event handlers
    on<ExpenseLoadAll>(_onLoadAll);
    on<ExpenseLoadToday>(_onLoadToday);
    on<ExpenseLoadThisMonth>(_onLoadThisMonth);
    on<ExpenseLoadByDateRange>(_onLoadByDateRange);
    on<ExpenseLoadByCategory>(_onLoadByCategory);
    on<ExpenseCreate>(_onCreate);
    on<ExpenseUpdate>(_onUpdate);
    on<ExpenseDelete>(_onDelete);
    on<ExpenseLoadById>(_onLoadById);
    on<ExpenseLoadCategoryTotals>(_onLoadCategoryTotals);
    on<ExpenseSubscribeToStream>(_onSubscribeToStream);
  }

  /// Load all expenses
  Future<void> _onLoadAll(
    ExpenseLoadAll event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await _expenseRepository.getAllExpenses();

    result.fold(
      (error) => emit(ExpenseError(message: error)),
      (expenses) {
        final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
        emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
      },
    );
  }

  /// Load today's expenses
  Future<void> _onLoadToday(
    ExpenseLoadToday event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await _expenseRepository.getTodayExpenses();

    result.fold(
      (error) => emit(ExpenseError(message: error)),
      (expenses) {
        final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
        emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
      },
    );
  }

  /// Load this month's expenses
  Future<void> _onLoadThisMonth(
    ExpenseLoadThisMonth event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await _expenseRepository.getThisMonthExpenses();

    result.fold(
      (error) => emit(ExpenseError(message: error)),
      (expenses) {
        final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
        emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
      },
    );
  }

  /// Load expenses by date range
  Future<void> _onLoadByDateRange(
    ExpenseLoadByDateRange event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await _expenseRepository.getExpensesByDateRange(
      startDate: event.startDate,
      endDate: event.endDate,
    );

    result.fold(
      (error) => emit(ExpenseError(message: error)),
      (expenses) {
        final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
        emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
      },
    );
  }

  /// Load expenses by category
  Future<void> _onLoadByCategory(
    ExpenseLoadByCategory event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await _expenseRepository.getExpensesByCategory(
      event.category,
    );

    result.fold(
      (error) => emit(ExpenseError(message: error)),
      (expenses) {
        final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
        emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
      },
    );
  }

  /// Create a new expense
  Future<void> _onCreate(
    ExpenseCreate event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseCreating());

    final result = await _expenseRepository.createExpense(
      category: event.category,
      description: event.description,
      amount: event.amount,
      currency: event.currency,
      currencySymbol: event.currencySymbol,
      date: event.date,
    );

    result.fold(
      (error) => emit(ExpenseError(message: error)),
      (expense) {
        emit(ExpenseCreated(expense: expense));
        // Reload expenses after creating
        add(const ExpenseLoadAll());
      },
    );
  }

  /// Update an existing expense
  Future<void> _onUpdate(
    ExpenseUpdate event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseUpdating());

    final result = await _expenseRepository.updateExpense(
      id: event.id,
      category: event.category,
      description: event.description,
      amount: event.amount,
      currency: event.currency,
      date: event.date,
    );

    result.fold(
      (error) => emit(ExpenseError(message: error)),
      (expense) {
        emit(ExpenseUpdated(expense: expense));
        // Reload expenses after updating
        add(const ExpenseLoadAll());
      },
    );
  }

  /// Delete an expense
  Future<void> _onDelete(
    ExpenseDelete event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseDeleting());

    final result = await _expenseRepository.deleteExpense(event.id);

    result.fold(
      (error) => emit(ExpenseError(message: error)),
      (_) {
        emit(ExpenseDeleted(id: event.id));
        // Reload expenses after deleting
        add(const ExpenseLoadAll());
      },
    );
  }

  /// Load a single expense by ID
  Future<void> _onLoadById(
    ExpenseLoadById event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await _expenseRepository.getExpenseById(event.id);

    result.fold(
      (error) => emit(ExpenseError(message: error)),
      (expense) => emit(ExpenseSingleLoaded(expense: expense)),
    );
  }

  /// Load category totals for a date range
  Future<void> _onLoadCategoryTotals(
    ExpenseLoadCategoryTotals event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(const ExpenseLoading());

    final result = await _expenseRepository.getCategoryTotals(
      startDate: event.startDate,
      endDate: event.endDate,
    );

    result.fold(
      (error) => emit(ExpenseError(message: error)),
      (categoryTotals) {
        final total = categoryTotals.values.fold(0.0, (sum, amount) => sum + amount);
        emit(ExpenseCategoryTotalsLoaded(
          categoryTotals: categoryTotals,
          totalAmount: total,
        ));
      },
    );
  }

  /// Subscribe to real-time expense stream
  Future<void> _onSubscribeToStream(
    ExpenseSubscribeToStream event,
    Emitter<ExpenseState> emit,
  ) async {
    await _expenseStreamSubscription?.cancel();

    _expenseStreamSubscription = _expenseRepository.expenseStream.listen(
      (expenses) {
        final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
        emit(ExpenseLoaded(expenses: expenses, totalAmount: total));
      },
      onError: (error) {
        emit(ExpenseError(message: error.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _expenseStreamSubscription?.cancel();
    return super.close();
  }
}

