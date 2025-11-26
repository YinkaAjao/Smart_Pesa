import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../bloc/statistics_cubit.dart';
import '../bloc/statistics_state.dart';
import '../../../settings/presentation/cubit/currency_cubit.dart';
import '../../../../core/constants/countries.dart';
import '../../../../core/constants/app_colors.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticsCubit(),
      child: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          final currentCountry = context.watch<CurrencyCubit>().state;
          
          // Debug print to see what data we have
          if (!state.isLoading && state.error == null) {
            debugPrint('Chart data - Spots count: ${state.monthlyExpenses.length}');
            debugPrint('Chart data - Spots: ${state.monthlyExpenses}');
            debugPrint('Total spent: ${state.totalSpent}');
            debugPrint('Categories: ${state.categoryBreakdown}');
          }
          
          return Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                          color: Theme.of(context).iconTheme.color,
                        ),
                        Text(
                          'Statistics', 
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.titleLarge?.color,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Icon(
                            Icons.download_outlined,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (state.isLoading)
                    const Expanded(child: Center(child: CircularProgressIndicator(color: Color(0xFF7F3DFF))))
                  else if (state.error != null)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            state.error!,
                            style: TextStyle(
                              color: Theme.of(context).textTheme.titleLarge?.color,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<StatisticsCubit>().retry(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                            ),
                            child: const Text('Retry', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Line Chart Container
                            Container(
                              height: 220,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: _buildChart(state, context),
                            ),
                            
                            const SizedBox(height: 32),
                            
                            // Top Spending Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Top Spending", 
                                  style: TextStyle(
                                    fontSize: 18, 
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).textTheme.titleLarge?.color,
                                  ),
                                ),
                                Icon(
                                  Icons.sort, 
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 16),

                            // Category Grid
                            if (state.categoryBreakdown.isNotEmpty)
                              GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 1.2,
                                children: state.categoryBreakdown.entries.map((entry) {
                                  return _buildCategoryCard(
                                    entry.key, 
                                    entry.value, 
                                    context,
                                    currentCountry,
                                  );
                                }).toList(),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.all(40),
                                child: Center(
                                  child: Text(
                                    'No spending data available',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            
                            const SizedBox(height: 24),
                            
                            // Monthly Summary
                            _buildMonthlySummary(state, currentCountry, context),
                            
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChart(StatisticsState state, BuildContext context) {
    if (state.monthlyExpenses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'No expense data for this month',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
      );
    }

    final spots = state.monthlyExpenses.where((spot) => spot.y > 0).toList();
    
    // Sort spots by x to ensure correct min/max calculation
    spots.sort((a, b) => a.x.compareTo(b.x));

    if (spots.isEmpty) {
      return Center(
        child: Text('No data', style: TextStyle(color: Colors.grey[400])),
      );
    }

    double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    double minX = spots.first.x;
    double maxX = spots.last.x;

    if (maxX - minX < 6) {
      double center = minX == maxX ? minX : (minX + maxX) / 2;
      minX = center - 3;
      maxX = center + 3;
    }

    if (minX < 1) {
      double shift = 1 - minX;
      minX += shift;
      maxX += shift;
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 0 ? maxY / 3 : 100,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.withAlpha(35),
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: (value, meta) {
                // Only show integer labels within range
                if (value != value.toInt()) return const SizedBox();
                
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    value.toInt().toString().padLeft(2, '0'), // Format as 01, 02
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: minX,
        maxX: maxX,
        minY: 0,
        maxY: maxY * 1.25, // Add 25% padding on top for the curve
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: AppColors.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            // Only show the dot if there is exactly one data point, 
            // otherwise hide dots to match the clean Figma line
            dotData: FlDotData(show: spots.length == 1),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withAlpha(50),
                  AppColors.primary.withAlpha(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String name, double amount, BuildContext context, Country currentCountry) {
    final categoryIcons = {
      'Food': Icons.restaurant_rounded,
      'Shopping': Icons.shopping_bag_rounded,
      'Transport': Icons.directions_bus_rounded,
      'Entertainment': Icons.movie_rounded,
      'Bills': Icons.receipt_long_rounded,
      'Travel': Icons.flight_rounded,
      'Other': Icons.category_rounded,
    };

    final categoryColors = {
      'Food': const Color(0xFFFFB6C1),
      'Shopping': const Color(0xFFFF6B6B),
      'Transport': const Color(0xFF87CEEB),
      'Entertainment': const Color(0xFFF2C94C),
      'Bills': const Color(0xFF90EE90),
      'Travel': const Color(0xFFDDA0DD),
      'Other': AppColors.primary,
    };

    final icon = categoryIcons[name] ?? Icons.category_rounded;
    final color = categoryColors[name] ?? AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withAlpha(40),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${amount.toStringAsFixed(0)} ${currentCountry.currencySymbol}',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySummary(StatisticsState state, Country currentCountry, BuildContext context) {
    final now = DateTime.now();
    final monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                monthNames[now.month - 1],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total Spent',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Text(
            '${state.totalSpent.toStringAsFixed(0)} ${currentCountry.currencySymbol}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
        ],
      ),
    );
  }
}