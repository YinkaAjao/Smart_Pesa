import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle headline(BuildContext context) => Theme.of(context).textTheme.headlineSmall ?? const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static TextStyle title(BuildContext context) => Theme.of(context).textTheme.titleMedium ?? const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static TextStyle body(BuildContext context) => Theme.of(context).textTheme.bodyMedium ?? const TextStyle(fontSize: 14);
  static TextStyle caption(BuildContext context) => Theme.of(context).textTheme.bodySmall ?? const TextStyle(fontSize: 12, color: Colors.grey);
}