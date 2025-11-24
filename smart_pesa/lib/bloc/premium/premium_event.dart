import 'package:equatable/equatable.dart';

abstract class PremiumEvent extends Equatable {
  const PremiumEvent();

  @override
  List<Object> get props => [];
}

class LoadSubscription extends PremiumEvent {}

class UpgradeSubscription extends PremiumEvent {}