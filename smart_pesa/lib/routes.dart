import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/expenses_screen.dart';
import 'screens/premium_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const DashboardScreen(),
  '/statistics': (context) => const StatisticsScreen(),
  '/expenses': (context) => const ExpensesScreen(),
  '/premium': (context) => const PremiumScreen(),
};
