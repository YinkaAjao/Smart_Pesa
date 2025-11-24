import 'package:equatable/equatable.dart';

abstract class PremiumState extends Equatable {
  const PremiumState();

  @override
  List<Object> get props => [];
}

class PremiumInitial extends PremiumState {}

class PremiumLoadInProgress extends PremiumState {}

class PremiumLoadSuccess extends PremiumState {
  final bool isSubscribed;

  const PremiumLoadSuccess({required this.isSubscribed});

  @override
  List<Object> get props => [isSubscribed];
}

class PremiumLoadFailure extends PremiumState {
  final String message;

  const PremiumLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}