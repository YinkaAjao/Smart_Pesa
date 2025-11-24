import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/expense_entity.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../../../settings/presentation/cubit/currency_cubit.dart';
import '../../../../core/constants/countries.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  String? selectedCategory; 

  // Categories aligned with app logic
  final List<String> categories = [
    'Food', 'Transport', 'Entertainment', 'Travel', 'Bills', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        List<ExpenseEntity> expenses = [];
        if (state is ExpenseLoaded) {
          expenses = state.expenses;
        }

        // Filter logic
        final filtered = selectedCategory == null 
            ? expenses 
            : expenses.where((e) => e.category == selectedCategory).toList();
        
        final total = filtered.fold(0.0, (sum, e) => sum + e.amount);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                
                // Category Filter
                _buildCategoryFilter(expenses, isDark),
                
                const SizedBox(height: 16),

                // Expense List
                Expanded(
                  child: state is ExpenseLoading
                      ? const Center(child: CircularProgressIndicator())
                      : filtered.isEmpty
                          ? _buildEmptyState(isDark)
                          : _buildExpenseList(filtered, total, isDark),
                ),
              ],
            ),
          ),
          // Floating Action Button
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDialog(context, isDark),
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          Text(
            'Expenses',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.bold, 
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(List<ExpenseEntity> allExpenses, bool isDark) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: ChoiceChip(
              label: Text(
                cat,
                style: TextStyle(
                  color: isSelected 
                      ? AppColors.primary 
                      : isDark ? Colors.white : Colors.black,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primary.withAlpha(50),
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              onSelected: (bool selected) {
                setState(() {
                  selectedCategory = selected ? cat : null;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpenseList(List<ExpenseEntity> expenses, double total, bool isDark) {
    final currentCountry = context.watch<CurrencyCubit>().state;
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: expenses.length + 1,
      itemBuilder: (context, index) {
        if (index == expenses.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total", 
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
                Text(
                  '${total.toStringAsFixed(0)} ${currentCountry.currencySymbol}',
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    color: AppColors.primary
                  ),
                ),
              ],
            ),
          );
        }

        final expense = expenses[index];
        return Dismissible(
          key: Key(expense.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) {
            context.read<ExpenseBloc>().add(ExpenseDelete(id: expense.id));
          },
          child: Card(
            elevation: 0,
            color: Theme.of(context).cardColor, 
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getColorForCategory(expense.category).withAlpha(25),
                child: Icon(_getIconForCategory(expense.category), color: _getColorForCategory(expense.category)),
              ),
              title: Text(
                expense.description, 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
              subtitle: Text(
                DateFormat('MMM dd, yyyy').format(expense.date),
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              trailing: Text(
                '${expense.amount.toStringAsFixed(0)} ${currentCountry.currencySymbol}',
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 15,
                  color: Theme.of(context).textTheme.titleLarge?.color,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            "No expenses found", 
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, bool isDark) {
    final descController = TextEditingController();
    final amountController = TextEditingController();
    String cat = categories.first;

    showDialog(
      context: context,
      builder: (ctx) => Theme(
        data: Theme.of(context), 
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            "Add Expense",
            style: TextStyle(color: Theme.of(context).textTheme.titleLarge?.color),
          ),
          content: StatefulBuilder(
            builder: (context, setDialogState) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: descController, 
                  decoration: InputDecoration(
                    labelText: "Description",
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: amountController, 
                  decoration: InputDecoration(
                    labelText: "Amount",
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: cat,
                  items: categories.map((c) => DropdownMenuItem(
                    value: c, 
                    child: Text(
                      c,
                      style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                    ),
                  )).toList(),
                  onChanged: (v) => setDialogState(() => cat = v!),
                  decoration: InputDecoration(
                    labelText: "Category",
                    labelStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                  dropdownColor: Theme.of(context).cardColor,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: Text("Cancel", style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
            ),
            BlocBuilder<CurrencyCubit, Country>(
              builder: (context, country) {
                return ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(amountController.text);
                    if (descController.text.isNotEmpty && amount != null) {
                      final currentCountry = context.read<CurrencyCubit>().state;
                      context.read<ExpenseBloc>().add(ExpenseCreate(
                        category: cat,
                        description: descController.text,
                        amount: amount,
                        currency: currentCountry.currency,
                        currencySymbol: currentCountry.currencySymbol,
                        date: DateTime.now(),
                      ));
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text("Save"),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Color _getColorForCategory(String cat) {
    switch(cat) {
      case 'Food': return Colors.orange;
      case 'Transport': return Colors.blue;
      case 'Entertainment': return Colors.purple;
      case 'Travel': return Colors.indigo;
      case 'Bills': return Colors.red;
      default: return AppColors.primary;
    }
  }

  IconData _getIconForCategory(String cat) {
    switch(cat) {
      case 'Food': return Icons.fastfood;
      case 'Transport': return Icons.directions_bus;
      case 'Entertainment': return Icons.movie;
      case 'Travel': return Icons.flight;
      case 'Bills': return Icons.receipt_long;
      default: return Icons.attach_money;
    }
  }
}