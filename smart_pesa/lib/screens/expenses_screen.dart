import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Data Models
class ExpenseCategory {
  final String id;
  final String name;
  final Color color;
  final Color bulletColor;
  final IconData icon;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.color,
    required this.bulletColor,
    required this.icon,
  });
}

class ExpenseItem {
  final String id;
  final String categoryId;
  final String label;
  final double amount;
  final DateTime date;

  ExpenseItem({
    required this.id,
    required this.categoryId,
    required this.label,
    required this.amount,
    required this.date,
  });
}

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  // UI State
  String selectedTab = 'Day'; // Day, Month, Year
  int selectedDateIndex = 3; // Index 3 = "Today"
  String? selectedCategoryId; // null = show all categories

  final List<String> tabs = ['Day', 'Month', 'Year'];
  final List<String> dates = ['01.02', '02.02', '03.02', 'Today'];

  // Categories with exact color mapping
  final List<ExpenseCategory> categories = [
    ExpenseCategory(
      id: 'soup',
      name: 'Soup',
      color: const Color(0xFFFFF9E6),
      bulletColor: const Color(0xFFF7C94A),
      icon: Icons.restaurant,
    ),
    ExpenseCategory(
      id: 'tea',
      name: 'Tea',
      color: const Color(0xFFF4E8FF),
      bulletColor: const Color(0xFFA26DF4),
      icon: Icons.local_cafe,
    ),
    ExpenseCategory(
      id: 'bus',
      name: 'Bus ticket',
      color: const Color(0xFFE3F2FD),
      bulletColor: const Color(0xFF64B5F6),
      icon: Icons.directions_bus,
    ),
    ExpenseCategory(
      id: 'exhibition',
      name: 'Exhibition',
      color: const Color(0xFFFCE4EC),
      bulletColor: const Color(0xFFF06292),
      icon: Icons.museum,
    ),
    ExpenseCategory(
      id: 'hotel',
      name: 'Hotel',
      color: const Color(0xFFFFE4CC),
      bulletColor: const Color(0xFFFF9800),
      icon: Icons.hotel,
    ),
    ExpenseCategory(
      id: 'dinner',
      name: 'Dinner',
      color: const Color(0xFFFFEBEE),
      bulletColor: const Color(0xFFE57373),
      icon: Icons.dinner_dining,
    ),
  ];

  // Sample expense data
  List<ExpenseItem> allExpenses = [];

  @override
  void initState() {
    super.initState();
    _initializeExpenses();
  }

  void _initializeExpenses() {
    final today = DateTime(2025, 2, 3);
    allExpenses = [
      ExpenseItem(id: '1', categoryId: 'soup', label: 'Soup', amount: 38559, date: today),
      ExpenseItem(id: '2', categoryId: 'tea', label: 'Tea', amount: 8012, date: today),
      ExpenseItem(id: '3', categoryId: 'bus', label: 'Bus ticket', amount: 3485, date: today),
      ExpenseItem(id: '4', categoryId: 'exhibition', label: 'Exhibition', amount: 72000, date: today),
      ExpenseItem(id: '5', categoryId: 'hotel', label: 'Hotel', amount: 7543500, date: today),
      ExpenseItem(id: '6', categoryId: 'dinner', label: 'Dinner', amount: 71283, date: today),
    ];
  }

  List<ExpenseItem> get filteredExpenses {
    if (selectedCategoryId == null) {
      return allExpenses;
    }
    return allExpenses.where((e) => e.categoryId == selectedCategoryId).toList();
  }

  double get totalAmount {
    return filteredExpenses.fold(0.0, (sum, item) => sum + item.amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            _buildHeader(),

            // TOP NAVIGATION TABS
            _buildTopTabs(),

            const SizedBox(height: 16),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // DATE PICKER ROW
                    _buildDatePicker(),

                    const SizedBox(height: 20),

                    // CATEGORY CARDS
                    _buildCategoryCards(),

                    const SizedBox(height: 20),

                    // LIST OF EXPENSE ITEMS
                    _buildExpenseList(),

                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: _buildBottomNavBar(),
      // FLOATING ADD BUTTON
      floatingActionButton: _buildFloatingAddButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // HEADER - Height: 56px
  Widget _buildHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Hamburger Menu
          IconButton(
            icon: const Icon(Icons.menu, size: 24),
            onPressed: () {},
            color: Colors.black,
          ),

          // Center: Title
          const Text(
            'Expenses',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          // Right: Star + Settings
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.star_outline, size: 22),
                onPressed: () {
                  context.go('/premium');
                },
                color: Colors.black54,
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, size: 22),
                onPressed: () {},
                color: Colors.black54,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TOP NAVIGATION TABS - Height: 45px
  Widget _buildTopTabs() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: tabs.map((tab) {
          final isSelected = tab == selectedTab;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTab = tab;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFA26DF4) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tab,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : Colors.black54,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // DATE PICKER ROW - Horizontal scroll, Button size: 70 × 32px
  Widget _buildDatePicker() {
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedDateIndex;
          final isToday = dates[index] == 'Today';

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDateIndex = index;
              });
            },
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isToday && isSelected
                    ? const Color(0xFFA26DF4)
                    : Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFFA26DF4) : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                dates[index],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isToday && isSelected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // CATEGORY CARDS - Horizontal scroll, Size: 85 × 75px
  Widget _buildCategoryCards() {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategoryId == category.id;
          final amount = _getCategoryTotal(category.id);

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategoryId = isSelected ? null : category.id;
              });
            },
            child: Container(
              width: 85,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF4E8FF) : Colors.white,
                border: Border.all(
                  color: isSelected ? const Color(0xFFA26DF4) : Colors.grey[200]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: category.color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      category.icon,
                      size: 18,
                      color: category.bulletColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Amount
                  Text(
                    _formatAmount(amount),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // LIST OF EXPENSE ITEMS - Row height: ~44px
  Widget _buildExpenseList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ...filteredExpenses.map((expense) {
            final category = categories.firstWhere((c) => c.id == expense.categoryId);
            return _buildExpenseItem(expense, category);
          }),

          // TOTAL AMOUNT FOOTER
          const Divider(height: 32, thickness: 1),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                '${_formatAmount(totalAmount)} Rwf',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(ExpenseItem expense, ExpenseCategory category) {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          // Colored bullet
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: category.bulletColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),

          // Label
          Expanded(
            child: Text(
              expense.label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),

          // Amount (right-aligned)
          Text(
            '${_formatAmount(expense.amount)} Rwf',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // BOTTOM NAVIGATION BAR
  Widget _buildBottomNavBar() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Left: Home
          IconButton(
            icon: const Icon(Icons.home, size: 28),
            onPressed: () {
              context.go('/');
            },
            color: Colors.black54,
          ),

          // Middle: Statistics
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, size: 28),
            onPressed: () {
              context.go('/statistics');
            },
            color: Colors.black54,
          ),

          // Right is handled by FAB
          const SizedBox(width: 56), // Space for FAB
        ],
      ),
    );
  }

  // FLOATING ADD BUTTON - Size: 56 × 56, Color: Purple
  Widget _buildFloatingAddButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFA26DF4),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA26DF4).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Colors.white, size: 32),
        onPressed: () {
          // Stay on expenses screen or show add dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add new expense'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  // Helper methods
  double _getCategoryTotal(String categoryId) {
    return allExpenses
        .where((e) => e.categoryId == categoryId)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  String _formatAmount(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

