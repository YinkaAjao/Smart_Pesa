import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool primary;

  const CustomButton.primary({super.key, required this.label, required this.onPressed}) : primary = true;
  const CustomButton.secondary({super.key, required this.label, required this.onPressed}) : primary = false;

  @override
  Widget build(BuildContext context) {
    final background = primary ? AppColors.primary : Colors.grey.shade200;
    final foreground = primary ? Colors.white : Colors.black;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}