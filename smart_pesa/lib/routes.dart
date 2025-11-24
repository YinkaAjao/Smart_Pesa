import 'package:flutter/material.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/statistics/presentation/screens/statistics_screen.dart';
import 'features/expenses/presentation/screens/expenses_screen.dart';
import 'features/premium/presentation/screens/premium_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const DashboardScreen(),
  '/statistics': (context) => const StatisticsScreen(),
  '/expenses': (context) => const ExpensesScreen(),
  '/premium': (context) => const PremiumScreen(),
};
