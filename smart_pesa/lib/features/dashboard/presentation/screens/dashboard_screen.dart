import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../bloc/dashboard_cubit.dart';
import '../../../settings/presentation/cubit/currency_cubit.dart';
import '../../../../core/constants/countries.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final currentCountry = context.watch<CurrencyCubit>().state;
        
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor, 
          body: SafeArea(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Safe-to-Spend Card
                          _buildBalanceCard(state, currentCountry),
                          
                          const SizedBox(height: 24),
                          
                          // 2. Income & Expenses Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Income',
                                  '${state.income.toStringAsFixed(0)} ${currentCountry.currencySymbol}',
                                  Icons.arrow_downward_rounded,
                                  AppColors.success,
                                  context,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildStatCard(
                                  'Expenses',
                                  '${state.expenses.toStringAsFixed(0)} ${currentCountry.currencySymbol}',
                                  Icons.arrow_upward_rounded,
                                  AppColors.danger,
                                  context,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // 3. Tax & Savings Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Tax Reserve',
                                  '${state.taxAmount.toStringAsFixed(0)} ${currentCountry.currencySymbol}',
                                  Icons.account_balance,
                                  Colors.orange,
                                  context,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildStatCard(
                                  'Savings',
                                  '${state.savings.toStringAsFixed(0)} ${currentCountry.currencySymbol}',
                                  Icons.savings,
                                  Colors.blue,
                                  context,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // 4. Transactions Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Expenses',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).textTheme.titleLarge?.color,
                                ),
                              ),
                              TextButton(
                                onPressed: () => context.go('/expenses'),
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
                          
                          // 5. Dynamic Transaction List
                          if (state.isLoading)
                            const Center(child: CircularProgressIndicator())
                          else if (state.recentTransactions.isEmpty)
                            _buildEmptyState(context)
                          else
                            ...state.recentTransactions.map((tx) {
                              return _buildTransactionItem(
                                tx['description'] ?? (tx['category'] ?? 'Expense'),
                                tx['category'] ?? 'General',
                                '-${(tx['amount'] ?? 0).toStringAsFixed(0)} ${currentCountry.currencySymbol}',
                                _getColorForCategory(tx['category'] ?? ''),
                                context,
                              );
                            }),
                            
                          const SizedBox(height: 100), 
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.go('/expenses'),
            backgroundColor: AppColors.primary,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 32),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, 
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            "No transactions yet",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tap the + button to add your first expense!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
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
            icon: Icon(Icons.menu_rounded, size: 28, color: Theme.of(context).iconTheme.color),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          Text(
            'Smart Pesa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          Row(children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: IconButton(
                icon: const Icon(Icons.star_rounded, size: 22), 
                onPressed: () => context.go('/premium'), 
                color: AppColors.primary, 
                padding: const EdgeInsets.all(8),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(DashboardState state, Country currentCountry) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3), // FIX DEPRECATION
            blurRadius: 20, 
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Safe to Spend',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14, 
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          state.isLoading
              ? const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  '${state.safeToSpend.toStringAsFixed(0)} ${currentCountry.currencySymbol}',
                  style: const TextStyle(
                    color: Colors.white, 
                    fontSize: 42, 
                    fontWeight: FontWeight.bold, 
                    letterSpacing: -1,
                  ),
                ),
          const SizedBox(height: 16),
          Container(
             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
             decoration: BoxDecoration(
               color: Colors.white.withValues(alpha: 0.2),
               borderRadius: BorderRadius.circular(8),
             ),
          )
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, BuildContext context) {
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, 
        borderRadius: BorderRadius.circular(20), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04), // FIX DEPRECATION
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1), // FIX DEPRECATION
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title, 
            style: TextStyle(
              fontSize: 12, 
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value, 
            style: TextStyle(
              fontSize: 16, 
              fontWeight: FontWeight.bold, 
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String category, String amount, Color color, BuildContext context) {
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03), // FIX DEPRECATION
            blurRadius: 8, 
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10), 
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1), // FIX DEPRECATION
            borderRadius: BorderRadius.circular(12),
          ), 
          child: Icon(Icons.category, color: color, size: 20),
        ),
        title: Text(
          title, 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          category,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 13,
          ),
        ),
        trailing: Text(
          amount, 
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food': return Colors.orange;
      case 'soup': return Colors.orangeAccent;
      case 'transport': return Colors.blue;
      case 'entertainment': return Colors.purple;
      case 'travel': return Colors.indigo;
      case 'hotel': return Colors.indigoAccent;
      default: return AppColors.primary;
    }
  }
}