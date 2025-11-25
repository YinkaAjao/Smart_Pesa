import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/repositories/statistics_repository.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository _repo = StatisticsRepository();
  StreamSubscription? _sub;

  StatisticsCubit() : super(const StatisticsState()) {
    _loadData();
  }

  void _loadData() {
    emit(state.copyWith(isLoading: true));
    
    _sub = _repo.getMonthlyExpenses().listen(
      (expenses) {
        try {
          double total = 0;
          Map<String, double> categories = {};
          Map<int, double> dailyMap = {};

          debugPrint('StatisticsCubit: Processing ${expenses.length} expenses');

          for (var e in expenses) {
            final amount = (e['amount'] as num).toDouble();
            final cat = e['category'] as String;
            
            DateTime date;
            if (e['date'] is Timestamp) {
              date = (e['date'] as Timestamp).toDate();
            } else {
              date = DateTime.now();
            }

            total += amount;
            categories[cat] = (categories[cat] ?? 0) + amount;
            
            // Group by day for the chart
            final day = date.day;
            dailyMap[day] = (dailyMap[day] ?? 0) + amount;
          }

          // Convert to FlSpot for the chart
          List<FlSpot> monthlyExpenses = dailyMap.entries
              .map((e) => FlSpot(e.key.toDouble(), e.value))
              .toList();
          monthlyExpenses.sort((a, b) => a.x.compareTo(b.x));

          debugPrint('StatisticsCubit: Total spent: $total, Categories: ${categories.keys.toList()}');

          emit(StatisticsState(
            totalSpent: total,
            categoryBreakdown: categories,
            monthlyExpenses: monthlyExpenses,
            isLoading: false,
          ));
        } catch (error, stackTrace) {
          debugPrint('StatisticsCubit: Error processing expenses - $error');
          debugPrint('StatisticsCubit: Stack trace - $stackTrace');
          emit(StatisticsState(
            totalSpent: 0,
            categoryBreakdown: {},
            monthlyExpenses: [],
            isLoading: false,
            error: 'Failed to load statistics',
          ));
        }
      },
      onError: (error, stackTrace) {
        debugPrint('StatisticsCubit: Error in statistics stream - $error');
        debugPrint('StatisticsCubit: Stack trace - $stackTrace'); 
        emit(StatisticsState(
          totalSpent: 0,
          categoryBreakdown: {},
          monthlyExpenses: [],
          isLoading: false,
          error: 'Failed to load statistics',
        ));
      },
    );
  }

  void changePeriod(String period) {
    emit(state.copyWith(selectedPeriod: period));
  }

  void retry() {
    _sub?.cancel();
    _loadData();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}