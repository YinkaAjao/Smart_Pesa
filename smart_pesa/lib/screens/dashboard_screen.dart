import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_colors.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../bloc/dashboard/dashboard_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  // Top Bar
                  _buildTopBar(context),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Main Balance Card
                            _buildBalanceCard(state),

                            const SizedBox(height: 24),

                            // Quick Stats Row
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    'Income',
                                    '\$${(state.balance + state.expenses).toStringAsFixed(0)}',
                                    Icons.arrow_downward_rounded,
                                    AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildStatCard(
                                    'Expenses',
                                    '\$${state.expenses.toStringAsFixed(0)}',
                                    Icons.arrow_upward_rounded,
                                    AppColors.danger,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Recent Transactions Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Recent Transactions',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'See all',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Transaction List
                            _buildTransactionItem('Soup', 'Food', '-\$8.50', AppColors.food),
                            _buildTransactionItem('Tea', 'Food', '-\$3.20', AppColors.food),
                            _buildTransactionItem('Bus ticket', 'Transport', '-\$2.40', AppColors.transport),
                            _buildTransactionItem('Exhibition', 'Entertainment', '-\$25.00', AppColors.exhibition),
                            _buildTransactionItem('Hotel', 'Travel', '-\$120.00', AppColors.hotel),
                            _buildTransactionItem('Dinner', 'Food', '-\$45.80', AppColors.food),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Navigation
            bottomNavigationBar: _buildBottomNavBar(context),
            // Floating Add Button
            floatingActionButton: _buildFloatingAddButton(context),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, size: 28),
            onPressed: () {},
            color: AppColors.textPrimary,
          ),
          const Text(
            'Smart Pesa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: IconButton(
                  icon: const Icon(Icons.star_rounded, size: 22),
                  onPressed: () {
                    context.go('/premium');
                  },
                  color: AppColors.primary,
                  padding: const EdgeInsets.all(8),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: IconButton(
                  icon: const Icon(Icons.settings_rounded, size: 22),
                  onPressed: () {},
                  color: AppColors.primary,
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(DashboardState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${state.balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: AppColors.accent,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '+12.5%',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'vs last month',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String category, String amount, Color categoryColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Color strip on the left
            Container(
              width: 4,
              height: 70,
              color: categoryColor,
            ),
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: categoryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(category),
                        color: categoryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title and category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Amount
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_bus_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'travel':
        return Icons.hotel_rounded;
      default:
        return Icons.attach_money_rounded;
    }
  }

  // Bottom Navigation Bar (consistent with other screens)
  Widget _buildBottomNavBar(BuildContext context) {
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
          // Left: Home (selected)
          IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFA26DF4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home, color: Colors.white, size: 22),
            ),
            onPressed: () {
              // Already on home/dashboard
            },
          ),

          // Middle: Statistics
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, size: 28),
            onPressed: () {
              context.go('/statistics');
            },
            color: Colors.black54,
          ),

          // Right: handled by FAB
          const SizedBox(width: 56), // Space for FAB
        ],
      ),
    );
  }

  // Floating Add Button
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

