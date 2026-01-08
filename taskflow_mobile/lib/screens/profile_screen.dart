import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badgesAsync = ref.watch(achievementsProvider);
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Profile & Settings")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(
            radius: 40,
            child: Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 10),
          const Text(
            "Offline User",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            "TaskFlow AI v1.1.0",
            style: TextStyle(color: Colors.grey.shade600),
          ),

          // SETTINGS SECTION
          const Divider(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "⚙️ Settings",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            subtitle: const Text("Toggle dark theme"),
            trailing: Switch(
              value: isDark,
              onChanged: (v) => ref.read(themeProvider.notifier).state = v,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text("Backup Data"),
            subtitle: const Text("Export tasks to JSON file"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              try {
                await ref.read(repositoryProvider).exportData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Backup created! Share menu opened.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
          ),

          // BADGES SECTION
          const Divider(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "🏆 Achievements",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: badgesAsync.when(
              data: (badges) {
                if (badges.isEmpty) {
                  return const Center(child: Text("No achievements yet"));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: badges.length,
                  itemBuilder: (context, index) {
                    final b = badges[index];
                    final isUnlocked = b['unlocked_at'] != null;
                    return Card(
                      color: isUnlocked
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.grey.shade200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              b['icon'] ?? '🏆',
                              style: TextStyle(
                                fontSize: 40,
                                color: isUnlocked ? null : Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              b['name'],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? null : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text("Error loading badges")),
            ),
          )
        ],
      ),
    );
  }
}
