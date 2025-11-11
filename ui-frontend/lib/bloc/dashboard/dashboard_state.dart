import 'package:equatable/equatable.dart';

class DashboardState extends Equatable {
  final double balance;
  final double expenses;
  final double savings;
  final double investments;

  const DashboardState({
    required this.balance,
    required this.expenses,
    required this.savings,
    required this.investments,
  });

  @override
  List<Object> get props => [balance, expenses, savings, investments];

  DashboardState copyWith({
    double? balance,
    double? expenses,
    double? savings,
    double? investments,
  }) {
    return DashboardState(
      balance: balance ?? this.balance,
      expenses: expenses ?? this.expenses,
      savings: savings ?? this.savings,
      investments: investments ?? this.investments,
    );
  }
}
