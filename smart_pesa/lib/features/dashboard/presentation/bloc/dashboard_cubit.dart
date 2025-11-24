import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/dashboard_repository.dart';

class DashboardState extends Equatable {
  final double income;
  final double expenses;
  final double savings;
  final double taxRate;
  final double taxAmount;
  final double safeToSpend;
  final List<Map<String, dynamic>> recentTransactions;
  final bool isLoading;

  const DashboardState({
    this.income = 0,
    this.expenses = 0,
    this.savings = 0,
    this.taxRate = 0,
    this.taxAmount = 0,
    this.safeToSpend = 0,
    this.recentTransactions = const [],
    this.isLoading = true,
  });

  @override
  List<Object> get props => [income, expenses, savings, taxRate, taxAmount, safeToSpend, recentTransactions, isLoading];

  DashboardState copyWith({
    double? income,
    double? expenses,
    double? savings,
    double? taxRate,
    double? taxAmount,
    double? safeToSpend,
    List<Map<String, dynamic>>? recentTransactions,
    bool? isLoading,
  }) {
    return DashboardState(
      income: income ?? this.income,
      expenses: expenses ?? this.expenses,
      savings: savings ?? this.savings,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      safeToSpend: safeToSpend ?? this.safeToSpend,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository _repository;
  final List<StreamSubscription> _subs = [];

  DashboardCubit(this._repository) : super(const DashboardState()) {
    _init();
  }

  void _init() {
    _subs.add(_repository.getTotalIncome().listen((val) => _recalculate(newIncome: val)));
    _subs.add(_repository.getTotalExpenses().listen((val) => _recalculate(newExpenses: val)));
    _subs.add(_repository.getTotalSavings().listen((val) => _recalculate(newSavings: val)));
    _subs.add(_repository.getUserTaxRate().listen((val) => _recalculate(newTaxRate: val)));
    
    // Listen to Transactions
    _subs.add(_repository.getRecentTransactions().listen((val) {
      emit(state.copyWith(recentTransactions: val));
    }));
  }

  void _recalculate({double? newIncome, double? newExpenses, double? newSavings, double? newTaxRate}) {
    final income = newIncome ?? state.income;
    final expenses = newExpenses ?? state.expenses;
    final savings = newSavings ?? state.savings;
    final taxRate = newTaxRate ?? state.taxRate;
    final taxAmount = income * taxRate;
    final safe = income - (expenses + savings + taxAmount);

    emit(state.copyWith(
      income: income, expenses: expenses, savings: savings,
      taxRate: taxRate, taxAmount: taxAmount, safeToSpend: safe,
      isLoading: false,
    ));
  }

  @override
  Future<void> close() {
    for (var sub in _subs) {sub.cancel();}
    return super.close();
  }
}