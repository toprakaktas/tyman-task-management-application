import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String message) {
  final theme = Theme.of(context);
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: theme.shadowColor,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Row(
        spacing: 10,
        children: [
          Icon(Icons.info_rounded,
              color: theme.colorScheme.secondary, size: 24),
          Text(
            message,
            maxLines: 2,
            style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: theme.colorScheme.secondary),
          )
        ],
      ),
      duration: const Duration(seconds: 3),
    ));
  }
}
