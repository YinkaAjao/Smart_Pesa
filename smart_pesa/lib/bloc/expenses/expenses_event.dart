import 'package:equatable/equatable.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadExpenses extends ExpenseEvent {}

class AddExpense extends ExpenseEvent {
  final String title;
  final double amount;
  final DateTime date;

  const AddExpense({required this.title, required this.amount, required this.date});

  @override
  List<Object> get props => [title, amount, date];
}

class DeleteExpense extends ExpenseEvent {
  final int index;

  const DeleteExpense(this.index);

  @override
  List<Object> get props => [index];
}