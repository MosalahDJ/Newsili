import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  final theme = Theme.of(context);

  return await showDialog<bool>(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        builder: (context) => Dialog(
          backgroundColor: theme.colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 24,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    color: theme.colorScheme.primary,
                    size: 36,
                  ),
                ),

                const SizedBox(height: 24),

                // Title
                Text(
                  'Exit Newsily?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  'Are you sure you want to exit the app?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 32),

                // Buttons Row
                Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(
                            color: theme.colorScheme.outline.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          'Stay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Exit Button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              SystemNavigator.pop(animated: true);
                            }),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.errorContainer,
                          foregroundColor: theme.colorScheme.onErrorContainer,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.exit_to_app_rounded, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Exit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ) ??
      false;
}
