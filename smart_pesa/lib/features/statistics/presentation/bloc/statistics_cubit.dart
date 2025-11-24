import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../data/repositories/statistics_repository.dart';

class StatisticsState extends Equatable {
  final double totalSpent;
  final Map<String, double> categoryBreakdown;
  final List<FlSpot> dailySpots;
  final bool isLoading;

  const StatisticsState({
    this.totalSpent = 0,
    this.categoryBreakdown = const {},
    this.dailySpots = const [],
    this.isLoading = true,
  });

  @override
  List<Object> get props => [totalSpent, categoryBreakdown, dailySpots, isLoading];
}

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository _repo = StatisticsRepository();
  StreamSubscription? _sub;

  StatisticsCubit() : super(const StatisticsState()) {
    _loadData();
  }

  void _loadData() {
    _sub = _repo.getMonthlyExpenses().listen((expenses) {
      double total = 0;
      Map<String, double> categories = {};
      Map<int, double> dailyMap = {};

      for (var e in expenses) {
        final amount = (e['amount'] as num).toDouble();
        final cat = e['category'] as String;
        
        // Handle Timestamp conversion safely
        DateTime date;
        if (e['date'] is Timestamp) {
          date = (e['date'] as Timestamp).toDate();
        } else {
          date = DateTime.now(); // Fallback
        }

        total += amount;
        categories[cat] = (categories[cat] ?? 0) + amount;
        dailyMap[date.day] = (dailyMap[date.day] ?? 0) + amount;
      }

      List<FlSpot> spots = dailyMap.entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList();
      spots.sort((a, b) => a.x.compareTo(b.x));

      emit(StatisticsState(
        totalSpent: total,
        categoryBreakdown: categories,
        dailySpots: spots,
        isLoading: false,
      ));
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}