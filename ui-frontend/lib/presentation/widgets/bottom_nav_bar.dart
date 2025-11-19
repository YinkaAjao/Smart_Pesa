import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_icons.dart';

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
    if (loc.startsWith('/statistics')) return 1;
    if (loc.startsWith('/expenses')) return 2;
    if (loc.startsWith('/premium')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _locationToIndex(currentLocation);

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Theme.of(context).colorScheme.surface,
      notchMargin: 6,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(AppIcons.wallet, color: index == 0 ? AppColors.primary : Colors.grey),
              onPressed: () => onTap(0),
            ),
            IconButton(
              icon: Icon(AppIcons.stats, color: index == 1 ? AppColors.primary : Colors.grey),
              onPressed: () => onTap(1),
            ),
            const SizedBox(width: 48), // space for FAB
            IconButton(
              icon: Icon(AppIcons.expenses, color: index == 2 ? AppColors.primary : Colors.grey),
              onPressed: () => onTap(2),
            ),
            IconButton(
              icon: Icon(AppIcons.premium, color: index == 3 ? AppColors.primary : Colors.grey),
              onPressed: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}
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
    if (loc.startsWith('/statistics')) return 1;
    if (loc.startsWith('/expenses')) return 2;
    if (loc.startsWith('/premium')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _locationToIndex(currentLocation);

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home,
                  color: index == 0 ? AppColors.primary : Colors.grey),
              onPressed: () => onTap(0),
            ),
            IconButton(
              icon: Icon(Icons.bar_chart,
                  color: index == 1 ? AppColors.primary : Colors.grey),
              onPressed: () => onTap(1),
            ),
            const SizedBox(width: 48), // space for FAB
            IconButton(
              icon: Icon(Icons.receipt_long,
                  color: index == 2 ? AppColors.primary : Colors.grey),
              onPressed: () => onTap(2),
            ),
            IconButton(
              icon: Icon(Icons.workspace_premium,
                  color: index == 3 ? AppColors.primary : Colors.grey),
              onPressed: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}
