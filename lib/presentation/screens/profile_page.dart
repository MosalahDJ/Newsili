import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
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
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            // Avatar placeholder
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Icon(
                Icons.person,
                size: 60,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            // Display name placeholder
            Text(
              'Your Name',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 4),
            // Email placeholder
            Text(
              'your.email@example.com',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimaryContainer.withValues(alpha:0.85),
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
    return SliverList(
      delegate: SliverChildListDelegate([
        Card(
          margin: const EdgeInsets.all(16),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _ActionButtonsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          return FilledButton.tonal(
            onPressed: () {
            },
            child: Text(actions[index]),
          );
        }, childCount: 4),
      ),
    );
  }
}
