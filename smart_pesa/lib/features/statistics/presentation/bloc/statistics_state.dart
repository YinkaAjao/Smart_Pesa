import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsState extends Equatable {
  final double totalSpent;
  final Map<String, double> categoryBreakdown;
  final List<FlSpot> monthlyExpenses;
  final bool isLoading;
  final String? error;
  final String selectedPeriod; // 'Day', 'Month', 'Year'

  const StatisticsState({
    this.totalSpent = 0,
    this.categoryBreakdown = const {},
    this.monthlyExpenses = const [],
    this.isLoading = true,
    this.error,
    this.selectedPeriod = 'Month',
  });

  @override
  List<Object?> get props => [
    totalSpent, 
    categoryBreakdown, 
    monthlyExpenses, 
    isLoading, 
    error,
    selectedPeriod,
  ];

  StatisticsState copyWith({
    double? totalSpent,
    Map<String, double>? categoryBreakdown,
    List<FlSpot>? monthlyExpenses,
    bool? isLoading,
    String? error,
    String? selectedPeriod,
  }) {
    return StatisticsState(
      totalSpent: totalSpent ?? this.totalSpent,
      categoryBreakdown: categoryBreakdown ?? this.categoryBreakdown,
      monthlyExpenses: monthlyExpenses ?? this.monthlyExpenses,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
    );
  }
}