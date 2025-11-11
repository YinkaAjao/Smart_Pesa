import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit()
      : super(const DashboardState(
          balance: 12345,
          expenses: 2300,
          savings: 5200,
          investments: 8900,
        ));

  void updateBalance(double newBalance) {
    emit(state.copyWith(balance: newBalance));
  }

  void updateExpenses(double newExpenses) {
    emit(state.copyWith(expenses: newExpenses));
  }

  void updateSavings(double newSavings) {
    emit(state.copyWith(savings: newSavings));
  }

  void updateInvestments(double newInvestments) {
    emit(state.copyWith(investments: newInvestments));
  }
}
