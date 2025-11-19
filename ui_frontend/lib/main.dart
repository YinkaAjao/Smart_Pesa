import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_colors.dart';
import 'core/constants/app_text_styles.dart';
import 'core/constants/app_icons.dart';
import 'presentation/widgets/bottom_nav_bar.dart';
import 'presentation/widgets/app_bar_widget.dart';
import 'screens/dashboard_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/expenses_screen.dart';
import 'screens/premium_screen.dart';

void main() {
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
              appBar: const AppBarWidget(title: 'Smart-Pesa'),
              body: child,
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                onPressed: () => _router.go('/expenses'),
                child: const Icon(Icons.add),
                backgroundColor: AppColors.primary,
              ),
              bottomNavigationBar: BottomNavBar(
                currentLocation: state.location,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      _router.go('/');
                      break;
                    case 1:
                      _router.go('/statistics');
                      break;
                    case 2:
                      _router.go('/expenses');
                      break;
                    case 3:
                      _router.go('/premium');
                      break;
                  }
                },
                onFabTap: () => _router.go('/expenses'),
              ),
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
    // Fade + slide from right
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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark),
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
      ),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
