import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

/// Authentication repository interface
/// Defines all authentication-related operations
/// Implementation will be in the data layer
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<String, UserEntity>> login({
    required String email,
    required String password,
  });

  /// Register new user with email and password
  Future<Either<String, UserEntity>> register({
    required String email,
    required String password,
    String? displayName,
  });

  /// Sign in with Google
  Future<Either<String, UserEntity>> signInWithGoogle();

  /// Logout current user
  Future<Either<String, void>> logout();

  /// Get currently authenticated user
  /// Returns null if not authenticated
  Future<UserEntity?> getCurrentUser();

  /// Stream of authentication state changes
  /// Emits UserEntity when user logs in, null when logged out
  Stream<UserEntity?> get authStateChanges;

  /// Send password reset email
  Future<Either<String, void>> resetPassword({required String email});

  /// Update user profile
  Future<Either<String, UserEntity>> updateProfile({
    String? displayName,
    String? photoUrl,
  });

  /// Delete user account
  Future<Either<String, void>> deleteAccount();
}