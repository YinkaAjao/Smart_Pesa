import 'package:flutter_bloc/flutter_bloc.dart';
import '../expenses/expense_state.dart';
import '../expenses/expense_bloc.dart';
import '../expenses/expense_event.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final ExpenseBloc expenseBloc;
  late final Stream subscription;

  StatisticsBloc({required this.expenseBloc}) : super(StatisticsInitial()) {
    subscription = expenseBloc.stream.listen((expenseState) {
      if (expenseState is ExpenseLoadSuccess) {
        add(LoadStatistics());
      }
    });

    on<LoadStatistics>((event, emit) {
      if (expenseBloc.state is ExpenseLoadSuccess) {
        final expenses = (expenseBloc.state as ExpenseLoadSuccess).expenses;
        final totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);
        const totalIncome = 3700.0; // static income for now
        emit(StatisticsLoadSuccess(totalExpenses: totalExpenses, totalIncome: totalIncome));
      }
    });
  }

  @override
  Future<void> close() {
    subscription.cancel();
    return super.close();
  }
}