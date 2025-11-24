import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../bloc/statistics_cubit.dart';
import '../../../settings/presentation/cubit/currency_cubit.dart';
import '../../../../core/constants/countries.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatisticsCubit(),
      child: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final currentCountry = context.watch<CurrencyCubit>().state;
          
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
                  else
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 220,
                              child: LineChart(
                                LineChartData(
                                  gridData: const FlGridData(show: false),
                                  titlesData: const FlTitlesData(show: false),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: state.dailySpots,
                                      isCurved: true,
                                      color: const Color(0xFF7F3DFF),
                                      barWidth: 4,
                                      dotData: const FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true, 
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFF7F3DFF).withAlpha(67), 
                                            Colors.transparent
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 32),
                            
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

                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.4,
                              children: state.categoryBreakdown.entries.map((entry) {
                                return _buildCategoryCard(
                                  entry.key, 
                                  entry.value, 
                                  isDark, 
                                  context,
                                  currentCountry,
                                );
                              }).toList(),
                            ),
                            
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

  Widget _buildCategoryCard(String name, double amount, bool isDark, BuildContext context, Country currentCountry) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 13), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
             padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(
               color: const Color(0xFF7F3DFF).withAlpha(25), 
               borderRadius: BorderRadius.circular(12)
             ),
             child: const Icon(Icons.category, color: Color(0xFF7F3DFF), size: 20),
          ),
          const Spacer(),
          Text(
            name, 
            style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '- ${amount.toStringAsFixed(0)} ${currentCountry.currencySymbol}',
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)
          ),
        ],
      ),
    );
  }
}