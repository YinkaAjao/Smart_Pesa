import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Domain layer
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../domain/repositories/subscription_repository.dart';

// Data layer (to be implemented)
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/expense_repository_impl.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/datasources/firestore_expense_datasource.dart';
import '../../data/datasources/firestore_subscription_datasource.dart';

// Application layer - BLoCs
import '../../application/blocs/auth/auth_bloc.dart';
import '../../application/blocs/expense/expense_bloc.dart';
import '../../application/blocs/subscription/subscription_bloc.dart';

/// Service Locator - Dependency Injection Container
///
/// Uses GetIt for managing dependencies across the application.
/// All dependencies are registered here and can be accessed globally.
///
/// Usage:
/// ```dart
/// final authBloc = sl<AuthBloc>();
/// ```
final sl = GetIt.instance;

/// Initialize all dependencies
/// Call this in main() before runApp()
Future<void> initializeDependencies() async {
  // ========== External Dependencies ==========

  // Firebase Auth instance
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Firestore instance
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // ========== Data Sources ==========

  // Firebase Auth Data Source
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(firebaseAuth: sl()),
  );

  // Firestore Expense Data Source
  sl.registerLazySingleton<FirestoreExpenseDataSource>(
    () => FirestoreExpenseDataSource(firestore: sl(), firebaseAuth: sl()),
  );

  // Firestore Subscription Data Source
  sl.registerLazySingleton<FirestoreSubscriptionDataSource>(
    () => FirestoreSubscriptionDataSource(firestore: sl(), firebaseAuth: sl()),
  );

  // ========== Repositories ==========

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authDataSource: sl()),
  );

  // Expense Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(expenseDataSource: sl()),
  );

  // Subscription Repository
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(subscriptionDataSource: sl()),
  );

  // ========== BLoCs ==========

  // Auth BLoC - Factory (new instance each time)
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: sl()),
  );

  // Expense BLoC - Factory (new instance each time)
  sl.registerFactory<ExpenseBloc>(
    () => ExpenseBloc(expenseRepository: sl()),
  );

  // Subscription BLoC - Factory (new instance each time)
  sl.registerFactory<SubscriptionBloc>(
    () => SubscriptionBloc(subscriptionRepository: sl()),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}

