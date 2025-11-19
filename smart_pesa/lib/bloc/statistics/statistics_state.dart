import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsState extends Equatable {
  final List<FlSpot> monthlyExpenses;

  const StatisticsState({required this.monthlyExpenses});

  @override
  List<Object> get props => [monthlyExpenses];
}
