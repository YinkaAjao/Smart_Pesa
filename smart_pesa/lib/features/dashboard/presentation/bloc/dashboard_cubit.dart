import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth;
  final List<StreamSubscription> _subs = [];
  StreamSubscription? _authSubscription;

  DashboardCubit(this._repository, {FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance,
        super(const DashboardState()) {
    _listenToAuthChanges();
    _init();
  }

  void _listenToAuthChanges() {
    _authSubscription = _auth.authStateChanges().listen((user) {
      if (user == null) {
        // User logged out, clear all data
        _clearData();
      } else {
        // User logged in, reinitialize data
        _reinitialize();
      }
    });
  }

  void _init() {
    // Only initialize if user is logged in
    if (_auth.currentUser == null) {
      emit(const DashboardState(isLoading: false));
      return;
    }

    _subs.add(_repository.getTotalIncome().listen((val) => _recalculate(newIncome: val)));
    _subs.add(_repository.getTotalExpenses().listen((val) => _recalculate(newExpenses: val)));
    _subs.add(_repository.getTotalSavings().listen((val) => _recalculate(newSavings: val)));
    _subs.add(_repository.getUserTaxRate().listen((val) => _recalculate(newTaxRate: val)));
    
    // Listen to Transactions
    _subs.add(_repository.getRecentTransactions().listen((val) {
      emit(state.copyWith(recentTransactions: val));
    }));
  }

  void _clearData() {
    // Cancel all existing subscriptions
    for (var sub in _subs) {
      sub.cancel();
    }
    _subs.clear();

    // Reset state to initial values
    emit(const DashboardState(isLoading: false));
  }

  void _reinitialize() {
    // Clear existing subscriptions first
    for (var sub in _subs) {
      sub.cancel();
    }
    _subs.clear();

    // Reset to loading state
    emit(const DashboardState(isLoading: true));

    // Reinitialize with new user data
    _init();
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
    _authSubscription?.cancel();
    for (var sub in _subs) {
      sub.cancel();
    }
    return super.close();
  }
}