import 'package:flutter/material.dart';
import 'screens/home_wrapper.dart';
import 'screens/add_transaction_screen.dart';
import 'screens/premium_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  // Main app screens wrapped with bottom navigation
  '/': (context) => const HomeWrapper(),

  // Add Transaction (opened via FAB)
  '/add': (context) => const AddTransactionScreen(),

  // Premium screen
  '/premium': (context) => const PremiumScreen(),
};