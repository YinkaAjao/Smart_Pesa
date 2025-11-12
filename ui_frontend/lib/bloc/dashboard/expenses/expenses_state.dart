import 'package:equatable/equatable.dart';

class ExpensesState extends Equatable {
  final List<Map<String, dynamic>> expenses;

  const ExpensesState({required this.expenses});

  @override
  List<Object> get props => [expenses];
}
