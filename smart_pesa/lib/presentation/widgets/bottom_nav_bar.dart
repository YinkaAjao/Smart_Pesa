import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  final void Function(int) onTap;
  final void Function() onFabTap;
  final String currentLocation;

  const BottomNavBar({
    super.key,
    required this.onTap,
    required this.onFabTap,
    required this.currentLocation,
  });

  int _locationToIndex(String loc) {
    if (loc.startsWith('/statistics')) return 0;
    if (loc.startsWith('/expenses')) return 2;
    return 1; // home/dashboard
  }

  @override
  Widget build(BuildContext context) {
    final index = _locationToIndex(currentLocation);

    return Container(
      height: 80,
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
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.bar_chart_rounded, 0, index),
              _buildNavItem(Icons.home_rounded, 1, index),
              _buildNavItem(Icons.add_circle_rounded, 2, index),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int itemIndex, int currentIndex) {
    final isSelected = itemIndex == currentIndex;

    return GestureDetector(
      onTap: () => onTap(itemIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : AppColors.textMuted,
          size: 28,
        ),
      ),
    );
  }
}