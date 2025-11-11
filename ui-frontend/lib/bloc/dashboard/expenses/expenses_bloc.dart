import 'package:flutter_bloc/flutter_bloc.dart';
import 'expenses_state.dart';

class ExpensesCubit extends Cubit<ExpensesState> {
  ExpensesCubit()
      : super(const ExpensesState(expenses: [
          {'title': 'Groceries', 'amount': 120.0},
          {'title': 'Transport', 'amount': 60.0},
          {'title': 'Subscriptions', 'amount': 30.0},
          {'title': 'Dining Out', 'amount': 75.0},
          {'title': 'Entertainment', 'amount': 50.0},
        ]));

  void addExpense(Map<String, dynamic> expense) {
    final updated = List<Map<String, dynamic>>.from(state.expenses)
      ..add(expense);
    emit(ExpensesState(expenses: updated));
  }
}
