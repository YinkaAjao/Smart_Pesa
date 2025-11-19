import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../widgets/statistics_chart.dart';
import '../bloc/statistics/statistics_bloc.dart';
import '../bloc/statistics/statistics_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticsCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Statistics')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double chartHeight = constraints.maxHeight * 0.4;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Monthly Expenses',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: chartHeight,
                    child: BlocBuilder<StatisticsCubit, StatisticsState>(
                      builder: (context, state) {
                        return StatisticsChart(spots: state.monthlyExpenses);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go('/expenses'),
                    child: const Text('View Expenses'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}