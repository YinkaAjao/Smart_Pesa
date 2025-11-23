import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

/// Base class for all authentication states
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - checking authentication
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when authentication check is in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is authenticated
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when authentication fails
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// State when password reset email is sent
class AuthPasswordResetSent extends AuthState {
  final String email;

  const AuthPasswordResetSent({required this.email});

  @override
  List<Object?> get props => [email];
}

/// State when profile is being updated
class AuthProfileUpdating extends AuthState {
  const AuthProfileUpdating();
}

/// State when profile is successfully updated
class AuthProfileUpdated extends AuthState {
  final UserEntity user;

  const AuthProfileUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

