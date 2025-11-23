import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_pesa/application/blocs/expense/expense_bloc.dart';
import 'package:smart_pesa/application/blocs/expense/expense_event.dart';
import 'package:smart_pesa/application/blocs/expense/expense_state.dart';
import 'package:smart_pesa/domain/entities/expense_entity.dart';
import 'package:smart_pesa/domain/repositories/expense_repository.dart';

/// Mock ExpenseRepository for testing
class MockExpenseRepository extends Mock implements ExpenseRepository {}

void main() {
  late ExpenseBloc expenseBloc;
  late MockExpenseRepository mockExpenseRepository;

  // Sample test data
  final testExpense1 = ExpenseEntity(
    id: '1',
    userId: 'user123',
    category: 'Food',
    description: 'Lunch',
    amount: 15.50,
    currency: 'Rwf',
    date: DateTime(2025, 11, 23),
    createdAt: DateTime(2025, 11, 23),
  );

  final testExpense2 = ExpenseEntity(
    id: '2',
    userId: 'user123',
    category: 'Transport',
    description: 'Bus ticket',
    amount: 5.00,
    currency: 'Rwf',
    date: DateTime(2025, 11, 23),
    createdAt: DateTime(2025, 11, 23),
  );

  final testExpenses = [testExpense1, testExpense2];

  setUp(() {
    mockExpenseRepository = MockExpenseRepository();
    expenseBloc = ExpenseBloc(expenseRepository: mockExpenseRepository);
  });

  tearDown(() {
    expenseBloc.close();
  });

  group('ExpenseBloc', () {
    test('initial state is ExpenseInitial', () {
      expect(expenseBloc.state, equals(const ExpenseInitial()));
    });

    group('ExpenseLoadAll', () {
      blocTest<ExpenseBloc, ExpenseState>(
        'emits [ExpenseLoading, ExpenseLoaded] when getAllExpenses succeeds',
        build: () {
          when(() => mockExpenseRepository.getAllExpenses())
              .thenAnswer((_) async => Right(testExpenses));
          return expenseBloc;
        },
        act: (bloc) => bloc.add(const ExpenseLoadAll()),
        expect: () => [
          const ExpenseLoading(),
          ExpenseLoaded(
            expenses: testExpenses,
            totalAmount: 20.50,
          ),
        ],
        verify: (_) {
          verify(() => mockExpenseRepository.getAllExpenses()).called(1);
        },
      );

      blocTest<ExpenseBloc, ExpenseState>(
        'emits [ExpenseLoading, ExpenseError] when getAllExpenses fails',
        build: () {
          when(() => mockExpenseRepository.getAllExpenses())
              .thenAnswer((_) async => const Left('Failed to load expenses'));
          return expenseBloc;
        },
        act: (bloc) => bloc.add(const ExpenseLoadAll()),
        expect: () => [
          const ExpenseLoading(),
          const ExpenseError(message: 'Failed to load expenses'),
        ],
      );
    });

    group('ExpenseLoadToday', () {
      blocTest<ExpenseBloc, ExpenseState>(
        'emits [ExpenseLoading, ExpenseLoaded] when getTodayExpenses succeeds',
        build: () {
          when(() => mockExpenseRepository.getTodayExpenses())
              .thenAnswer((_) async => Right(testExpenses));
          return expenseBloc;
        },
        act: (bloc) => bloc.add(const ExpenseLoadToday()),
        expect: () => [
          const ExpenseLoading(),
          ExpenseLoaded(
            expenses: testExpenses,
            totalAmount: 20.50,
          ),
        ],
      );
    });

    group('ExpenseCreate', () {
      blocTest<ExpenseBloc, ExpenseState>(
        'emits [ExpenseCreating, ExpenseCreated, ExpenseLoading, ExpenseLoaded] when createExpense succeeds',
        build: () {
          when(() => mockExpenseRepository.createExpense(
                category: any(named: 'category'),
                description: any(named: 'description'),
                amount: any(named: 'amount'),
                currency: any(named: 'currency'),
                date: any(named: 'date'),
              )).thenAnswer((_) async => Right(testExpense1));
          when(() => mockExpenseRepository.getAllExpenses())
              .thenAnswer((_) async => Right(testExpenses));
          return expenseBloc;
        },
        act: (bloc) => bloc.add(ExpenseCreate(
          category: 'Food',
          description: 'Lunch',
          amount: 15.50,
          currency: 'Rwf',
          date: DateTime(2025, 11, 23),
        )),
        expect: () => [
          const ExpenseCreating(),
          ExpenseCreated(expense: testExpense1),
          const ExpenseLoading(),
          ExpenseLoaded(
            expenses: testExpenses,
            totalAmount: 20.50,
          ),
        ],
      );

      blocTest<ExpenseBloc, ExpenseState>(
        'emits [ExpenseCreating, ExpenseError] when createExpense fails',
        build: () {
          when(() => mockExpenseRepository.createExpense(
                category: any(named: 'category'),
                description: any(named: 'description'),
                amount: any(named: 'amount'),
                currency: any(named: 'currency'),
                date: any(named: 'date'),
              )).thenAnswer((_) async => const Left('Failed to create'));
          return expenseBloc;
        },
        act: (bloc) => bloc.add(ExpenseCreate(
          category: 'Food',
          description: 'Lunch',
          amount: 15.50,
          currency: 'Rwf',
          date: DateTime(2025, 11, 23),
        )),
        expect: () => [
          const ExpenseCreating(),
          const ExpenseError(message: 'Failed to create'),
        ],
      );
    });

    group('ExpenseUpdate', () {
      blocTest<ExpenseBloc, ExpenseState>(
        'emits [ExpenseUpdating, ExpenseUpdated, ExpenseLoading, ExpenseLoaded] when updateExpense succeeds',
        build: () {
          when(() => mockExpenseRepository.updateExpense(
                id: any(named: 'id'),
                category: any(named: 'category'),
                description: any(named: 'description'),
                amount: any(named: 'amount'),
                currency: any(named: 'currency'),
                date: any(named: 'date'),
              )).thenAnswer((_) async => Right(testExpense1));
          when(() => mockExpenseRepository.getAllExpenses())
              .thenAnswer((_) async => Right(testExpenses));
          return expenseBloc;
        },
        act: (bloc) => bloc.add(const ExpenseUpdate(
          id: '1',
          description: 'Updated lunch',
        )),
        expect: () => [
          const ExpenseUpdating(),
          ExpenseUpdated(expense: testExpense1),
          const ExpenseLoading(),
          ExpenseLoaded(
            expenses: testExpenses,
            totalAmount: 20.50,
          ),
        ],
      );
    });

    group('ExpenseDelete', () {
      blocTest<ExpenseBloc, ExpenseState>(
        'emits [ExpenseDeleting, ExpenseDeleted, ExpenseLoading, ExpenseLoaded] when deleteExpense succeeds',
        build: () {
          when(() => mockExpenseRepository.deleteExpense(any()))
              .thenAnswer((_) async => const Right(null));
          when(() => mockExpenseRepository.getAllExpenses())
              .thenAnswer((_) async => Right([testExpense2]));
          return expenseBloc;
        },
        act: (bloc) => bloc.add(const ExpenseDelete(id: '1')),
        expect: () => [
          const ExpenseDeleting(),
          const ExpenseDeleted(id: '1'),
          const ExpenseLoading(),
          ExpenseLoaded(
            expenses: [testExpense2],
            totalAmount: 5.00,
          ),
        ],
      );
    });

    group('ExpenseLoadCategoryTotals', () {
      blocTest<ExpenseBloc, ExpenseState>(
        'emits [ExpenseLoading, ExpenseCategoryTotalsLoaded] when getCategoryTotals succeeds',
        build: () {
          final categoryTotals = {
            'Food': 15.50,
            'Transport': 5.00,
          };
          when(() => mockExpenseRepository.getCategoryTotals(
                startDate: any(named: 'startDate'),
                endDate: any(named: 'endDate'),
              )).thenAnswer((_) async => Right(categoryTotals));
          return expenseBloc;
        },
        act: (bloc) => bloc.add(ExpenseLoadCategoryTotals(
          startDate: DateTime(2025, 11, 1),
          endDate: DateTime(2025, 11, 30),
        )),
        expect: () => [
          const ExpenseLoading(),
          const ExpenseCategoryTotalsLoaded(
            categoryTotals: {
              'Food': 15.50,
              'Transport': 5.00,
            },
            totalAmount: 20.50,
          ),
        ],
      );
    });
  });
}

