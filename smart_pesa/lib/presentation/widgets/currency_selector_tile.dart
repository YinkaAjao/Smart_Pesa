import 'package:flutter/material.dart';
import '../../core/constants/app_text_styles.dart';

class CurrencySelectorTile extends StatelessWidget {
  final String currency;
  final bool selected;
  final VoidCallback onTap;

  const CurrencySelectorTile({super.key, required this.currency, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary.withAlpha(25) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200),
        ),
        child: Text(currency, style: AppTextStyles.body(context)),
      ),
    );
  }
}
