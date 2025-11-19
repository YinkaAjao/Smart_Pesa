import 'package:equatable/equatable.dart';

class PremiumState extends Equatable {
  final bool isPremium;

  const PremiumState({required this.isPremium});

  @override
  List<Object> get props => [isPremium];
}
