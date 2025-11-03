import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

/// Share article function
  Future<void> shareArticle(
    BuildContext context, {
    required String title,
    required String url,
  }) async {
    try {
      await SharePlus.instance.share(
        ShareParams(text: "$title\n\nRead more: $url", subject: title),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error sharing article: $e"),
          backgroundColor: Colors.redAccent,
        ),
      );
    } 
  }