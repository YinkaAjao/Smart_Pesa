import 'package:flutter/material.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/constants/app_colors.dart';

class ExpenseCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;

  const ExpenseCard({super.key, required this.title, required this.amount, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: AppColors.primary.withAlpha(25), child: Icon(icon, color: AppColors.primary)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.title(context)),
              const SizedBox(height: 4),
              Text(amount, style: AppTextStyles.body(context)),
            ],
          )
        ],
      ),
    );
  }
}
