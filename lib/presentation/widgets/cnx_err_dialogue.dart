import 'package:flutter/material.dart';

Object connectionErrorDialogue(BuildContext context) {
  final theme = Theme.of(context);

  return showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (context) => Dialog(
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
                Icons.wifi_off_rounded,
                color: theme.colorScheme.primary,
                size: 36,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'Connectivity Issue: Cannot refresh feed. Check your internet connection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      side: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.0),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      'Dismiss',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16),

                // Exit Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      //todo
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.onSurface,
                      foregroundColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.replay_outlined, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          'RETRY',
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
  );
}


// Check internet connectivity
// final connectivityResult = await Connectivity().checkConnectivity();
//         if (connectivityResult.contains(ConnectivityResult.none)) {}


  
// // function to load offline data
// Future<List<Articles>> loadOfflineData(
//   String? tableName,
//   dynamic database,
// ) async {
//   String query =
//       "SELECT response_data FROM $tableName ORDER BY last_updated DESC LIMIT 1";
//   final rows = await database.readdata(query);

//   if (rows.isEmpty) {
//     // print("rows is empty");
//     return [];
//   }

//   final rawJson = rows.first['response_data'];

//   //store the fetching time
//   final String fetchTime = DateTime.now().toIso8601String();
//   await _set(fetchTime);

//   final Map<String, dynamic> body = jsonDecode(rawJson);

//   return (body['articles'] as List).map((e) => Articles.fromJson(e)).toList();
// }

// Future<void> _set(String prefValue) async {
//   const prefKey = 'fetch_time';
//   final prefs = await SharedPreferences.getInstance();
//   await prefs.setString(prefKey, prefValue);
// }

