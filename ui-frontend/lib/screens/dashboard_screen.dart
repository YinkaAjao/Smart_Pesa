import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/dashboard_card.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth = constraints.maxWidth < 600
                ? constraints.maxWidth
                : constraints.maxWidth / 2 - 20;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<DashboardCubit, DashboardState>(
                builder: (context, state) {
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      DashboardCard(
                        width: cardWidth,
                        title: 'Total Balance',
                        value: '\$${state.balance}',
                        icon: Icons.account_balance_wallet,
                      ),
                      DashboardCard(
                        width: cardWidth,
                        title: 'Expenses',
                        value: '\$${state.expenses}',
                        icon: Icons.money_off,
                      ),
                      DashboardCard(
                        width: cardWidth,
                        title: 'Savings',
                        value: '\$${state.savings}',
                        icon: Icons.savings,
                      ),
                      DashboardCard(
                        width: cardWidth,
                        title: 'Investments',
                        value: '\$${state.investments}',
                        icon: Icons.trending_up,
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
