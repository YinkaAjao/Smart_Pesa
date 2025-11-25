import 'package:equatable/equatable.dart';

abstract class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoadInProgress extends StatisticsState {}

class StatisticsLoadSuccess extends StatisticsState {
  final double totalExpenses;
  final double totalIncome;

  const StatisticsLoadSuccess({required this.totalExpenses, required this.totalIncome});

  @override
  List<Object> get props => [totalExpenses, totalIncome];
}

class StatisticsLoadFailure extends StatisticsState {
  final String message;

  const StatisticsLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}