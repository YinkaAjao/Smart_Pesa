import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/expense_item.dart';
import '../../bloc/expenses/expenses_bloc.dart';
import '../../bloc/expenses/expenses_state.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExpensesCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Expenses')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double listWidth = constraints.maxWidth < 600
                ? constraints.maxWidth
                : constraints.maxWidth * 0.6;

            return Center(
              child: SizedBox(
                width: listWidth,
                child: BlocBuilder<ExpensesCubit, ExpensesState>(
                  builder: (context, state) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.expenses.length,
                      itemBuilder: (context, index) {
                        final expense = state.expenses[index];
                        return ExpenseItem(
                          title: expense['title']!,
                          amount: expense['amount']!,
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
