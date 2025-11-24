// lib/bloc/profile/profile_state.dart
import 'package:equatable/equatable.dart';
import '../../models/user.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoadInProgress extends ProfileState {}

class ProfileLoadSuccess extends ProfileState {
  final User user;

  const ProfileLoadSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfileLoadFailure extends ProfileState {
  final String message;

  const ProfileLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}