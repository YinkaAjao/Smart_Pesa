import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expenses/expense_bloc.dart';
import '../bloc/expenses/expense_state.dart';
import '../models/user.dart';
import '../core/constants/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        double totalIncome = 0;
        double totalExpenses = 0;

        if (state is ExpenseLoadSuccess) {
          totalIncome = state.expenses
              .where((e) => e.type == 'income')
              .fold(0, (sum, e) => sum + e.amount);
          totalExpenses = state.expenses
              .where((e) => e.type == 'expense')
              .fold(0, (sum, e) => sum + e.amount);
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${currentUser.name}',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildSummaryCard(
                        title: 'Income',
                        amount: totalIncome,
                        color: AppColors.income),
                    const SizedBox(width: 16),
                    _buildSummaryCard(
                        title: 'Expenses',
                        amount: totalExpenses,
                        color: AppColors.expense),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Recent Transactions',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: state is ExpenseLoadSuccess &&
                          state.expenses.isNotEmpty
                      ? ListView.builder(
                          itemCount:
                              state.expenses.length > 5 ? 5 : state.expenses.length,
                          itemBuilder: (context, index) {
                            final exp = state.expenses[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(exp.title),
                                subtitle: Text(exp.date.toLocal().toString().split(' ')[0]),
                                trailing: Text(
                                  '${exp.type == 'expense' ? '-' : '+'}\$${exp.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      color: exp.type == 'expense'
                                          ? AppColors.expense
                                          : AppColors.income,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(child: Text('No transactions yet')),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
      {required String title, required double amount, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('\$${amount.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}