import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

/// Base class for all authentication events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check initial authentication state
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event when user attempts to login
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Event when user attempts to register
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String? displayName;

  const AuthRegisterRequested({
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

/// Event when user logs out
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event when user requests password reset
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Event when user updates profile
class AuthProfileUpdateRequested extends AuthEvent {
  final String? displayName;
  final String? photoUrl;

  const AuthProfileUpdateRequested({
    this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [displayName, photoUrl];
}

/// Event when user deletes account
class AuthDeleteAccountRequested extends AuthEvent {
  const AuthDeleteAccountRequested();
}

/// Internal event when auth state changes from Firebase
class AuthStateChanged extends AuthEvent {
  final UserEntity? user;

  const AuthStateChanged({required this.user});

  @override
  List<Object?> get props => [user];
}

