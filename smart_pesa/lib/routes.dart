import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'screens/home_wrapper.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/premium_screen.dart';
=======
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/statistics/presentation/screens/statistics_screen.dart';
import 'features/expenses/presentation/screens/expenses_screen.dart';
import 'features/premium/presentation/screens/premium_screen.dart';
>>>>>>> e23ea40f5eb05d39289006142ea24d7788a6f6d7

final Map<String, WidgetBuilder> appRoutes = {
  // Main app screens wrapped with bottom navigation
  '/': (context) => const HomeWrapper(),

  // Add Transaction (opened via FAB)
  '/add': (context) => const AddTransactionScreen(),

  // Premium screen
  '/premium': (context) => const PremiumScreen(),
};