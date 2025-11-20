import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_colors.dart';
import 'screens/dashboard_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/expenses_screen.dart';
import 'screens/premium_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SmartPesaApp());
}

class SmartPesaApp extends StatefulWidget {
  const SmartPesaApp({super.key});

  @override
  State<SmartPesaApp> createState() => _SmartPesaAppState();
}

class _SmartPesaAppState extends State<SmartPesaApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();

    _router = GoRouter(
      initialLocation: '/',
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              body: child,
              // Bottom navigation is now handled by each individual screen
            );
          },
          routes: [
            GoRoute(
              name: 'dashboard',
              path: '/',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const DashboardScreen(),
                transitionsBuilder: _transitionBuilder,
              ),
            ),
            GoRoute(
              name: 'statistics',
              path: '/statistics',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const StatisticsScreen(),
                transitionsBuilder: _transitionBuilder,
              ),
            ),
            GoRoute(
              name: 'expenses',
              path: '/expenses',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ExpensesScreen(),
                transitionsBuilder: _transitionBuilder,
              ),
            ),
            GoRoute(
              name: 'premium',
              path: '/premium',
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const PremiumScreen(),
                transitionsBuilder: _transitionBuilder,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _transitionBuilder(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    final offsetAnimation = Tween<Offset>(begin: const Offset(0.2, 0), end: Offset.zero).animate(animation);
    return FadeTransition(opacity: animation, child: SlideTransition(position: offsetAnimation, child: child));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.black.withValues(alpha: 0.05),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
      ),
      themeMode: ThemeMode.light,
      routerConfig: _router,
    );
  }
}