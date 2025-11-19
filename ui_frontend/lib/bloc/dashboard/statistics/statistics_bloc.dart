import 'package:flutter_bloc/flutter_bloc.dart';
import 'statistics_state.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  StatisticsCubit()
      : super(const StatisticsState(monthlyExpenses: [
          FlSpot(0, 1),
          FlSpot(1, 1.5),
          FlSpot(2, 1.4),
          FlSpot(3, 3.4),
          FlSpot(4, 2),
          FlSpot(5, 2.2),
          FlSpot(6, 1.8),
        ]));

  void updateExpenses(List<FlSpot> newData) {
    emit(StatisticsState(monthlyExpenses: newData));
  }
}
