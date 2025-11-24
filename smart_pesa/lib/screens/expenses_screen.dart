import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/expenses/expense_bloc.dart';
import '../bloc/expenses/expense_state.dart';
import '../core/constants/app_colors.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('All Expenses',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Expanded(
                  child: state is ExpenseLoadSuccess && state.expenses.isNotEmpty
                      ? ListView.builder(
                          itemCount: state.expenses.length,
                          itemBuilder: (context, index) {
                            final exp = state.expenses[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(exp.title),
                                subtitle: Text(
                                    exp.date.toLocal().toString().split(' ')[0]),
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
                      : const Center(child: Text('No expenses added yet')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}