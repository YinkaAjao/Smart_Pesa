import 'package:flutter/material.dart';
import 'presentation/screens/dashboard_screen.dart';
import 'presentation/screens/statistics_screen.dart';
import 'presentation/screens/expenses_screen.dart';
import 'presentation/screens/premium_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const DashboardScreen(),
  '/statistics': (context) => const StatisticsScreen(),
  '/expenses': (context) => const ExpensesScreen(),
  '/premium': (context) => const PremiumScreen(),
};
