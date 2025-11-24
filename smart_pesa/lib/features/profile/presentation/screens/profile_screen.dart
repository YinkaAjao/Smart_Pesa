import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../data/repositories/profile_repository.dart';
import '../../../../core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../settings/presentation/widgets/country_selection_dialog.dart';
import '../../../settings/presentation/cubit/currency_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _repo = ProfileRepository();
  
  // Controllers
  final _incomeController = TextEditingController();
  final _taxController = TextEditingController();
  final _savingsController = TextEditingController();
  
  bool _isLoading = false;
  bool _isEditing = false;

  // Cached values for View Mode
  double _currentIncome = 0;
  double _currentTax = 0;
  double _currentSavings = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await _repo.loadVitalInfo();
    
    _currentIncome = (data['income'] ?? 0).toDouble();
    _currentTax = (data['tax'] ?? 0).toDouble();
    _currentSavings = (data['savings'] ?? 0).toDouble();

    // Populate controllers for when we hit Edit
    _incomeController.text = _currentIncome.toStringAsFixed(0);
    _taxController.text = _currentTax.toString();
    _savingsController.text = _currentSavings.toStringAsFixed(0);
    
    setState(() => _isLoading = false);
  }

  Future<void> _saveData() async {
    setState(() => _isLoading = true);
    
    final newIncome = double.tryParse(_incomeController.text) ?? 0;
    final newTax = double.tryParse(_taxController.text) ?? 0;
    final newSavings = double.tryParse(_savingsController.text) ?? 0;

    await _repo.updateVitalInfo(
      income: newIncome,
      taxRate: newTax,
      savingsGoal: newSavings,
    );

    // Update local View Mode data
    _currentIncome = newIncome;
    _currentTax = newTax;
    _currentSavings = newSavings;

    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile Updated!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu), 
                    onPressed: () => Scaffold.of(context).openDrawer()
                  ),
                  const SizedBox(width: 10),
                  const Text("Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            if (_isLoading) 
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // User Avatar
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40, 
                              backgroundColor: AppColors.primary, 
                              child: Text(
                                (user?.email ?? "U")[0].toUpperCase(),
                                style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              user?.email ?? "User", 
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Section Title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Smart-Pesa Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          if (!_isEditing)
                            TextButton.icon(
                              onPressed: () => setState(() => _isEditing = true),
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text("Edit"),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      
                      // TOGGLE CONTENT: VIEW vs EDIT
                      if (_isEditing) _buildEditForm() else _buildViewMode(context, isDark),

                      const SizedBox(height: 40),
                      
                      // Logout Button
                      if (!_isEditing) ...[
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text("Log Out", style: TextStyle(color: Colors.red)),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            if (context.mounted) context.go('/auth');
                          },
                        )
                      ]
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // VIEW MODE: Read-only Cards
  Widget _buildViewMode(BuildContext context, bool isDark) {
    final currentCountry = context.watch<CurrencyCubit>().state;
    
    return Column(
      children: [
        _buildCurrencyCard(context, isDark),
        const SizedBox(height: 12),
        _buildInfoCard(
          "Monthly Income", 
          "${_currentIncome.toStringAsFixed(0)} ${currentCountry.currencySymbol}", 
          Icons.attach_money, 
          Colors.green, 
          isDark
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          "Tax Rate", 
          "${(_currentTax * 100).toStringAsFixed(1)}%", 
          Icons.percent, 
          Colors.orange, 
          isDark
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          "Savings Goal", 
          "${_currentSavings.toStringAsFixed(0)} ${currentCountry.currencySymbol}", 
          Icons.savings, 
          Colors.blue, 
          isDark
        ),
      ],
    );
  }

  // EDIT MODE: Input Fields
  Widget _buildEditForm() {
    final currentCountry = context.watch<CurrencyCubit>().state;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Update your values to recalculate Safe-to-Spend.", style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 20),
          _buildTextField("Monthly Income (${currentCountry.currencySymbol})", _incomeController),
          const SizedBox(height: 16),
          _buildTextField("Tax Rate (e.g. 0.18 for 18%)", _taxController),
          const SizedBox(height: 16),
          _buildTextField("Monthly Savings Goal (${currentCountry.currencySymbol})", _savingsController),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _isEditing = false),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(BuildContext context, bool isDark) {
    final currentCountry = context.watch<CurrencyCubit>().state;
  
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const CountrySelectionDialog(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 5)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple.withAlpha(25), 
                borderRadius: BorderRadius.circular(8)
              ),
              child: const Icon(Icons.language, color: Colors.purple),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Currency", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(
                    "${currentCountry.flag} ${currentCountry.currency} (${currentCountry.currencySymbol})",
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.bold, 
                      color: isDark ? Colors.white : Colors.black
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 5)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: isDark ? Colors.grey : Colors.black54),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey[50],
      ),
    );
  }
}