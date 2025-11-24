import 'package:flutter_bloc/flutter_bloc.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    final List<Expense> _expenses = [];

    on<LoadExpenses>((event, emit) {
      emit(ExpenseLoadSuccess(List.from(_expenses)));
    });

    on<AddExpense>((event, emit) {
      _expenses.add(Expense(title: event.title, amount: event.amount, date: event.date));
      emit(ExpenseLoadSuccess(List.from(_expenses)));
    });

    on<DeleteExpense>((event, emit) {
      if (event.index >= 0 && event.index < _expenses.length) {
        _expenses.removeAt(event.index);
      }
      emit(ExpenseLoadSuccess(List.from(_expenses)));
    });
  }
}