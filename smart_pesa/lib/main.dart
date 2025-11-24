import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/constants/app_colors.dart';
import 'bloc/expenses/expense_bloc.dart';
import 'bloc/statistics/statistics_bloc.dart';
import 'bloc/premium/premium_bloc.dart';
import 'bloc/profile/profile_bloc.dart';
import 'screens/home_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const SmartPesaApp());
}

class SmartPesaApp extends StatelessWidget {
  const SmartPesaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ExpenseBloc>(
          create: (context) => ExpenseBloc()..add(LoadExpenses()),
        ),
        BlocProvider<StatisticsBloc>(
          create: (context) => StatisticsBloc(
              expenseBloc: BlocProvider.of<ExpenseBloc>(context))
            ..add(LoadStatistics()),
        ),
        BlocProvider<PremiumBloc>(
          create: (context) => PremiumBloc()..add(LoadSubscription()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc()..add(LoadProfile()),
        ),
        // Optional: DashboardBloc if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart-Pesa',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
            primary: AppColors.primary,
            secondary: AppColors.accent,
            surface: AppColors.surface,
          ),
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.poppinsTextTheme().copyWith(
            bodyLarge: const TextStyle(color: AppColors.textPrimary),
            bodyMedium: const TextStyle(color: AppColors.textSecondary),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
        ),
        home: const HomeWrapper(),
      ),
    );
  }
}