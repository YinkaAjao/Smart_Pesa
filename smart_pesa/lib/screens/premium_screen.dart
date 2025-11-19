import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/premium_card.dart';
import '../../bloc/premium/premium_bloc.dart';
import '../../bloc/premium/premium_state.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PremiumCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Get Premium')),
        body: LayoutBuilder(
          builder: (context, constraints) {
            double cardWidth = constraints.maxWidth < 600
                ? constraints.maxWidth
                : constraints.maxWidth * 0.7;

            return Center(
              child: SizedBox(
                width: cardWidth,
                child: Column(
                  children: [
                    BlocBuilder<PremiumCubit, PremiumState>(
                      builder: (context, state) {
                        return PremiumCard(
                          title: 'Unlock Advanced Features',
                          description: state.isPremium
                              ? 'Premium Active: Access all features!'
                              : 'Access detailed statistics, budgeting tools, and more!',
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<PremiumCubit>().unlockPremium(),
                      child: const Text('Subscribe Now'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
