import 'package:flutter/material.dart';

Widget buildSuggestionBanner(BuildContext context) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: isDark
            ? [
                theme.colorScheme.primary.withValues(alpha: 0.8),
                theme.colorScheme.tertiary.withValues(alpha: 0.6),
              ]
            : [
                theme.colorScheme.primary,
                Color(0xFF3730A3), // Deep indigo
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: theme.colorScheme.shadow.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Stay Informed",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Get the latest updates on world events, business, and more, every day.",
          style: TextStyle(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
          ),
        ),
      ],
    ),
  );
}
