import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<PackageInfo> _getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About'), centerTitle: false),
      body: FutureBuilder<PackageInfo>(
        future: _getPackageInfo(),
        builder: (context, snapshot) {
          final packageInfo = snapshot.data;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                SizedBox(
                  width: 100,
                  height: 100,

                  child: Image.asset(
                    'lib/assets/images/newsily_logo/newsily_logo_png.png',
                    fit: BoxFit.contain,
                  ),
                ),

                // App Name
                Text(
                  'Newsily',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Tagline
                Text(
                  'Your gateway to the world\'s news',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Version Info
                if (packageInfo != null)
                  _buildInfoCard(
                    context,
                    title: 'Version Information',
                    children: [
                      _buildInfoRow(context, 'Version', packageInfo.version),
                      _buildInfoRow(context, 'Build', packageInfo.buildNumber),
                      _buildInfoRow(
                        context,
                        'Package',
                        packageInfo.packageName,
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // Developer Info
                _buildInfoCard(
                  context,
                  title: 'Developer',
                  children: [
                    _buildInfoRow(
                      context,
                      'Developed by',
                      'Djehel Mohamed Salah',
                    ),
                    _buildInfoRow(
                      context,
                      'Email',
                      'djehelmohamedsalah@gmail.com',
                    ),
                    _buildInfoRow(context, 'Instagram', 'moh.medsalah'),
                    _buildInfoRow(context, 'Facebook', 'Mohamed Salah Djehel'),
                  ],
                ),

                const SizedBox(height: 20),

                // Data Sources
                _buildInfoCard(
                  context,
                  title: 'Data Sources',
                  children: [
                    Text(
                      'News articles are sourced from reliable news APIs.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'All content copyright belongs to their respective publishers.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Links Section
                _buildInfoCard(
                  context,
                  title: 'Links',
                  children: [
                    _buildLinkButton(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      onTap: () => _launchUrl('https://yourdomain.com/privacy'),
                    ),
                    _buildLinkButton(
                      context,
                      icon: Icons.description_outlined,
                      label: 'Terms of Service',
                      onTap: () => _launchUrl('https://yourdomain.com/terms'),
                    ),
                    _buildLinkButton(
                      context,
                      icon: Icons.code_outlined,
                      label: 'GitHub Repository',
                      onTap: () =>
                          _launchUrl('https://github.com/yourusername/newsily'),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Footer
                Text(
                  'Made with ❤️ for news readers worldwide',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '© ${DateTime.now().year} Newsily',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 12),
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              const Spacer(),
              Icon(
                Icons.arrow_outward,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
