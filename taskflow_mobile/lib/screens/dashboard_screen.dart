import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import 'add_task_screen.dart';
import 'projects_screen.dart';
import 'profile_screen.dart';
import 'focus_screen.dart';
import 'log_state_sheet.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeView(),
      const ProjectsScreen(),
      const FocusScreen(),
      const ProfileScreen(),
    ];
    
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Today'),
          NavigationDestination(icon: Icon(Icons.folder_open), label: 'Projects'),
          NavigationDestination(icon: Icon(Icons.timer), label: 'Focus'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeView extends ConsumerWidget {
  const _HomeView();
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(taskListProvider);
    final energy = ref.watch(userEnergyProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.battery_charging_full),
            onPressed: () => showModalBottomSheet(
              context: context,
              builder: (_) => const LogStateSheet(),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          ).then((_) => ref.refresh(taskListProvider));
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.bolt, color: Colors.amber),
                Text(
                  " Energy: $energy/10 (AI Sorting Active)",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                final activeTasks = tasks.where((t) => !t.isCompleted).toList();
                if (activeTasks.isEmpty) {
                  return const Center(
                    child: Text("No tasks! Relax or add one."),
                  );
                }

                return ListView.builder(
                  itemCount: activeTasks.length,
                  itemBuilder: (context, index) {
                    final task = activeTasks[index];
                    return Dismissible(
                      key: Key(task.id.toString()),
                      background: Container(
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                      onDismissed: (_) async {
                        final badges = await ref.read(repositoryProvider).completeTask(task);
                        ref.refresh(taskListProvider);
                        if (badges.isNotEmpty && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("🏆 Unlocked: ${badges.join(', ')}"),
                              backgroundColor: Colors.amber,
                            ),
                          );
                        }
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(task.priority.toString()),
                          ),
                          title: Text(task.title),
                          subtitle: Text(
                            task.dueDate != null
                                ? "Due: ${task.dueDate.toString().split(' ')[0]}"
                                : "No deadline",
                          ),
                          trailing: task.priority >= 4
                              ? const Icon(Icons.priority_high, color: Colors.red)
                              : null,
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
            ),
          ),
        ],
      ),
    );
  }
}
