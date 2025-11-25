import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  bool isYearlySelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7F3DFF), 
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F), 
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(130), blurRadius: 30, offset: const Offset(0, 20))],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => context.go('/'),
                          child: const Icon(Icons.close, color: Colors.white, size: 24),
                        ),
                      ),
                      _buildHeader(),
                      const SizedBox(height: 32),
                      _buildPlanOption(
                        title: "Yearly",
                        subtitle: "First payment \$54",
                        price: "\$4.5 /m",
                        isSelected: isYearlySelected,
                        onTap: () => setState(() => isYearlySelected = true),
                        isBestValue: true
                      ),
                      const SizedBox(height: 16),
                      _buildPlanOption(
                        title: "Monthly",
                        subtitle: "First payment \$10",
                        price: "\$10 /m",
                        isSelected: !isYearlySelected,
                        onTap: () => setState(() => isYearlySelected = false),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                             context.go('/');
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Welcome to Premium!")));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7F3DFF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text("Start Free Trial", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Pay \$54 after 7 days of trial", 
                        textAlign: TextAlign.center, 
                        style: TextStyle(color: Colors.grey, fontSize: 12)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50, 
          height: 50, 
          decoration: const BoxDecoration(color: Color(0xFFFFCC00), shape: BoxShape.circle), 
          child: const Icon(Icons.star_rounded, color: Colors.black, size: 32)
        ),
        const SizedBox(width: 16),
        const Text("Get Premium!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildPlanOption({
    required String title,
    required String subtitle,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
    bool isBestValue = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(24),
              border: isSelected ? Border.all(color: const Color(0xFF7F3DFF), width: 2) : null,
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off, 
                  color: isSelected ? const Color(0xFF7F3DFF) : Colors.grey
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.black : Colors.white)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ])),
                Text(price, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isSelected ? Colors.black : Colors.white)),
              ],
            ),
          ),
          if (isBestValue)
            Positioned(
              top: -10,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF7F3DFF), borderRadius: BorderRadius.circular(10)),
                child: const Text("Save 50%", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            )
        ],
      ),
    );
  }
}