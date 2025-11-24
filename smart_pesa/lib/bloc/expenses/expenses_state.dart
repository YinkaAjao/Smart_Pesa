import 'package:equatable/equatable.dart';

class Expense {
  final String title;
  final double amount;
  final DateTime date;

  Expense({required this.title, required this.amount, required this.date});
}

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoadInProgress extends ExpenseState {}

class ExpenseLoadSuccess extends ExpenseState {
  final List<Expense> expenses;

  const ExpenseLoadSuccess(this.expenses);

  @override
  List<Object> get props => [expenses];
}

class ExpenseLoadFailure extends ExpenseState {
  final String message;

  const ExpenseLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}