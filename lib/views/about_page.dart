import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    try {
      final canLaunch = await canLaunchUrlString(urlString);
      if (!canLaunch) {
        throw Exception('Could not launch $urlString');
      }
      
      await launchUrlString(
        urlString,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  Widget _buildDeveloperCard(BuildContext context, {
    required String name,
    required String linkedIn,
    required String github,
    required String description,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Developer: $name',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => _launchUrl(linkedIn),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 34,
                    height: 34,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Image.asset(
                      'assets/linkedin.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => _launchUrl(github),
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 34,
                    height: 34,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[800]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Image.asset(
                      'assets/github.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        title: const Text('About Us'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildDeveloperCard(
              context,
              name: 'Sahil Dudhal',
              linkedIn: 'https://linkedin.com/in/sahil-dudhal-1b11b925a',
              github: 'https://github.com/SAHILDUDHAL21',
              description: 'Computer Science Student | Programmer | Linux Enthusiast | Flutter Developer | Follow me on LinkedIn and GitHub',
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(16),
              color: theme.colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'LibrePaperWall',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      ' 2024 All Rights Reserved',
                      style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
