import 'package:flutter/material.dart';

class ArticleMoreMenu extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onSave;

  const ArticleMoreMenu({
    super.key,
    required this.onShare,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: theme.iconTheme.color),
      color: theme.colorScheme.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (value) {
        if (value == 'share') onShare();
        if (value == 'save') onSave();
      },
      itemBuilder: (context) => [
        PopupMenuItem<String>(
          value: 'share',
          child: Row(
            children: [
              Icon(Icons.share, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              const Text(
                'Share',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'save',
          child: Row(
            children: [
              Icon(Icons.bookmark_border, color: theme.colorScheme.primary),
              const SizedBox(width: 10),
              const Text('Save', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
