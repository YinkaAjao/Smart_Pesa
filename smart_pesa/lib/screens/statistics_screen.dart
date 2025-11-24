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
      child: BlocBuilder<StatisticsCubit, StatisticsState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  // Top App Bar
                  _buildAppBar(context),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),

                            // Period Selector (Day / Month / Year)
                            _buildPeriodSelector(),

                            const SizedBox(height: 32),

                            // Line Chart Visualization
                            _buildLineChart(state),

                            const SizedBox(height: 24),

                            // Date Selector Row
                            _buildDateSelector(),

                            const SizedBox(height: 32),

                            // Category Summary Cards (2x2 Grid)
                            _buildCategorySummaryGrid(),

                            const SizedBox(height: 24),

                            // Monthly Summary Row
                            _buildMonthlySummaryRow(),

                            const SizedBox(height: 100), // Space for bottom nav
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Navigation
            bottomNavigationBar: _buildBottomSection(context),
            // Floating Add Button
            floatingActionButton: _buildFloatingAddButton(context),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }

  // 2. Top App Bar
  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Hamburger Menu
          Icon(
            Icons.menu,
            color: Colors.black,
            size: 28,
          ),

          // Center: Title
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          // Right: Star Icon in Circle
          GestureDetector(
            onTap: () {
              context.go('/premium');
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.star,
                color: Color(0xFFF2C94C),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. Period Selector Tabs
  Widget _buildPeriodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildPeriodTab('Day', false),
        const SizedBox(width: 24),
        _buildPeriodTab('Month', true), // Selected
        const SizedBox(width: 24),
        _buildPeriodTab('Year', false),
      ],
    );
  }

  Widget _buildPeriodTab(String label, bool isSelected) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: isSelected ? Colors.black : Colors.grey[500],
        decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
      ),
    );
  }

  // 4. Line Graph Section
  Widget _buildLineChart(StatisticsState state) {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: StatisticsChart(spots: state.monthlyExpenses),
    );
  }

  // 5. Date Selector Row
  Widget _buildDateSelector() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          final day = index + 1;
          final isSelected = day == 10; // 10th is selected

          return Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.grey[300]!, width: 1)
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              day.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.black : Colors.grey[400],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  // 6. Category Summary Cards (2x2 Grid)
  Widget _buildCategorySummaryGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildCategoryCard(
          '700,000 Rwf',
          Icons.restaurant_rounded,
          const Color(0xFFFFB6C1), // Pink
        ),
        _buildCategoryCard(
          '850,000 Rwf',
          Icons.shopping_bag_rounded,
          const Color(0xFFFF6B6B), // Red
        ),
        _buildCategoryCard(
          '135,000 Rwf',
          Icons.directions_bus_rounded,
          const Color(0xFF87CEEB), // Blue
        ),
        _buildCategoryCard(
          '672,000 Rwf',
          Icons.movie_rounded,
          const Color(0xFFF2C94C), // Yellow
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon in rounded square
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),

          // Amount
          Expanded(
            child: Text(
              amount,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 7. Monthly Summary Row
  Widget _buildMonthlySummaryRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Month and "Total" label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'September',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          // Right: Total amount
          const Text(
            '783,834 Rwf',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // 8. Bottom Navigation (consistent with Expenses screen)
  Widget _buildBottomSection(BuildContext context) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Left: Home
          IconButton(
            icon: const Icon(Icons.home, size: 28),
            onPressed: () {
              context.go('/');
            },
            color: Colors.black54,
          ),

          // Middle: Statistics (selected)
          IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFA26DF4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bar_chart_rounded, color: Colors.white, size: 22),
            ),
            onPressed: () {
              // Already on statistics
            },
          ),

          // Right: handled by FAB
          const SizedBox(width: 56), // Space for FAB
        ],
      ),
    );
  }

  // Floating Add Button (consistent with Expenses screen)
  Widget _buildFloatingAddButton(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFA26DF4),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA26DF4).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white, size: 32),
        onPressed: () {
          context.go('/expenses');
        },
      ),
    );
  }
}

