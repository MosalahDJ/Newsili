import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        surfaceTintColor: theme.colorScheme.surface,
      ),
      body: CustomScrollView(
        slivers: [
          _ProfileHeader(),
          _ProfileInfoSection(),
          _ActionButtonsSection(),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Container(
        color: theme.colorScheme.surfaceContainerHighest,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            // Avatar placeholder
            CircleAvatar(
              radius: 60,
              backgroundColor: theme.colorScheme.surface,
              child: Icon(
                Icons.person,
                size: 60,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            // Display name placeholder
            Text(
              'Your Name',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            // Email placeholder
            Text(
              'your.email@example.com',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverList(
      delegate: SliverChildListDelegate([
        Card(
          margin: const EdgeInsets.all(16),
          color: theme.colorScheme.surface,
          surfaceTintColor: theme.colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(
                  context,
                  Icons.location_on_outlined,
                  'San Francisco, CA',
                ),
                _buildInfoRow(context, Icons.work_outline, 'Product Designer'),
                _buildInfoRow(
                  context,
                  Icons.calendar_today_outlined,
                  'Member since Jan 2022',
                ),
                _buildInfoRow(context, Icons.bookmark_border, '12 bookmarks'),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtonsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.4,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final actions = [
            'Edit Profile',
            'Account Settings',
            'Help & Support',
            'Log Out',
          ];

          Color? buttonColor;
          Color? textColor;

          // Different colors for different buttons
          if (index == 0) {
            // Edit Profile
            buttonColor = theme.colorScheme.primary;
            textColor = theme.colorScheme.onPrimary;
          } else if (index == 3) {
            // Log Out
            buttonColor = theme.colorScheme.errorContainer;
            textColor = theme.colorScheme.onErrorContainer;
          } else {
            // Other buttons
            buttonColor = theme.colorScheme.surfaceContainerHighest;
            textColor = theme.colorScheme.onSurfaceVariant;
          }

          return ElevatedButton(
            onPressed: () {
              // Handle button press
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: textColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              actions[index],
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
            ),
          );
        }, childCount: 4),
      ),
    );
  }
}
