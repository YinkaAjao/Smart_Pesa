import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'core/constants/app_colors.dart';
import 'core/di/dependency_injection.dart';
import 'core/theme/theme_cubit.dart';
import 'firebase_options.dart';

// Import Screens & Blocs
import 'features/auth/presentation/screens/auth_screen.dart';
import 'features/dashboard/presentation/screens/dashboard_screen.dart';
import 'features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'features/dashboard/data/repositories/dashboard_repository.dart';
import 'features/statistics/presentation/screens/statistics_screen.dart';
import 'features/expenses/presentation/screens/expenses_screen.dart';
import 'features/expenses/presentation/bloc/expense_bloc.dart';
import 'features/expenses/presentation/bloc/expense_event.dart';
import 'features/expenses/data/datasources/firestore_expense_datasource.dart';
import 'features/expenses/data/repositories/expense_repository_impl.dart';
import 'features/premium/presentation/screens/premium_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/settings/presentation/cubit/currency_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();
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
      redirect: (context, state) {
        final loggedIn = FirebaseAuth.instance.currentUser != null;
        final loggingIn = state.uri.toString() == '/auth';
        if (!loggedIn && !loggingIn) return '/auth';
        if (loggedIn && loggingIn) return '/';
        return null;
      },
      routes: [
        GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
        
        // SHELL ROUTE HANDLES GLOBAL NAV & DRAWER
        ShellRoute(
          builder: (context, state, child) {
            return Scaffold(
              // GLOBAL DRAWER
              drawer: Drawer(
                child: Column(
                  children: [
                    DrawerHeader(
                      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.account_balance_wallet, size: 50, color: Colors.white),
                            const SizedBox(height: 10),
                            Text("Smart-Pesa", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    _buildDrawerItem(context, 'Dashboard', Icons.home, '/'),
                    _buildDrawerItem(context, 'Statistics', Icons.bar_chart, '/statistics'),
                    _buildDrawerItem(context, 'Expenses', Icons.attach_money, '/expenses'),
                    _buildDrawerItem(context, 'Profile', Icons.person, '/profile'),
                    const Divider(),
                    
                    // Dark Mode Toggle
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, mode) {
                        final isDark = mode == ThemeMode.dark;
                        return SwitchListTile(
                          title: const Text("Dark Mode"),
                          secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                          value: isDark,
                          onChanged: (value) {
                            context.read<ThemeCubit>().toggleTheme(value);
                          },
                        );
                      },
                    ),

                    const Spacer(),
                    ListTile(
                      title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                      leading: const Icon(Icons.exit_to_app, color: Colors.red),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pop(context); // Close drawer
                        context.go('/auth');
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              body: child,
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _getIndex(state),
                onTap: (i) => _onTap(context, i),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
                  BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
                ],
              ),
            );
          },
          routes: [
            GoRoute(name: 'dashboard', path: '/', builder: (context, state) => const DashboardScreen()),
            GoRoute(name: 'statistics', path: '/statistics', builder: (context, state) => const StatisticsScreen()),
            GoRoute(name: 'profile', path: '/profile', builder: (context, state) => const ProfileScreen()),
            GoRoute(name: 'expenses', path: '/expenses', builder: (context, state) => const ExpensesScreen()),
            GoRoute(name: 'premium', path: '/premium', builder: (context, state) => const PremiumScreen()),
          ],
        ),
      ],
    );
  }

  // Helper to build drawer items and close drawer on tap
  Widget _buildDrawerItem(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // <--- CLOSE DRAWER
        context.go(route);      // <--- NAVIGATE
      },
    );
  }

  int _getIndex(GoRouterState state) {
    if (state.uri.toString().startsWith('/statistics')) return 1;
    if (state.uri.toString().startsWith('/profile')) return 2;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    if (index == 0) context.go('/');
    if (index == 1) context.go('/statistics');
    if (index == 2) context.go('/profile');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()), 
        BlocProvider(create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested())),
        BlocProvider(create: (_) => DashboardCubit(DashboardRepository())),
        BlocProvider(create: (_) => CurrencyCubit()),
        BlocProvider(create: (_) {
           final repo = ExpenseRepositoryImpl(expenseDataSource: FirestoreExpenseDataSource(firestore: FirebaseFirestore.instance, firebaseAuth: FirebaseAuth.instance));
           return ExpenseBloc(expenseRepository: repo)..add(const ExpenseSubscribeToStream());
        }),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Smart-Pesa',
            themeMode: themeMode, 
            // Light Theme
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light),
              scaffoldBackgroundColor: AppColors.background,
              textTheme: GoogleFonts.poppinsTextTheme(),
              appBarTheme: const AppBarTheme(backgroundColor: Colors.white, elevation: 0, iconTheme: IconThemeData(color: Colors.black)),
            ),
            // Dark Theme
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark),
              scaffoldBackgroundColor: const Color(0xFF121212),
              textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
              appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF1E1E1E), elevation: 0),
              drawerTheme: const DrawerThemeData(backgroundColor: Color(0xFF1E1E1E)),
            ),
            routerConfig: _router,
          );
        },
      ),
    );
  }
}