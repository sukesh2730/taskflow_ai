import 'package:sqflite/sqflite.dart';
import '../models/task.dart';
import '../models/project.dart';
import '../models/log.dart';
import 'local_database.dart';

class LocalApiService {
  // --- TASKS ---
  Future<List<Task>> getTasks() async {
    final db = await LocalDatabase.instance.database;
    final result = await db.query(
      'tasks',
      where: 'is_completed = ?',
      whereArgs: [0],
      orderBy: 'priority DESC, due_date ASC',
    );

    return result.map((json) => Task.fromJson({
      'id': json['id'],
      'title': json['title'],
      'category': json['category'],
      'priority': json['priority'],
      'energy_req': json['energy_req'],
      'estimated_minutes': json['estimated_minutes'],
      'is_completed': json['is_completed'] == 1,
      'project_id': json['project_id'],
      'due_date': json['due_date'],
    })).toList();
  }

  Future<void> createTask(Map<String, dynamic> taskData) async {
    final db = await LocalDatabase.instance.database;
    await db.insert('tasks', {
      'title': taskData['title'],
      'priority': taskData['priority'] ?? 3,
      'energy_req': taskData['energy_req'] ?? 3,
      'estimated_minutes': taskData['estimated_minutes'] ?? 30,
      'due_date': taskData['due_date'],
      'project_id': taskData['project_id'],
      'category': taskData['category'] ?? 'General',
    });
  }

  Future<List<String>> completeTask(int id) async {
    final db = await LocalDatabase.instance.database;
    
    // Mark task as completed
    await db.update(
      'tasks',
      {
        'is_completed': 1,
        'completed_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );

    // Check for badge unlocks
    return await _checkAchievements(db);
  }

  Future<List<String>> _checkAchievements(Database db) async {
    final completedCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM tasks WHERE is_completed = 1'),
    ) ?? 0;

    List<String> newBadges = [];

    // The Starter (1 task)
    if (completedCount >= 1) {
      final unlocked = await _unlockBadge(db, 'The Starter');
      if (unlocked) newBadges.add('The Starter');
    }

    // Productivity Master (10 tasks)
    if (completedCount >= 10) {
      final unlocked = await _unlockBadge(db, 'Productivity Master');
      if (unlocked) newBadges.add('Productivity Master');
    }

    return newBadges;
  }

  Future<bool> _unlockBadge(Database db, String name) async {
    final result = await db.query(
      'achievements',
      where: 'name = ? AND unlocked_at IS NOT NULL',
      whereArgs: [name],
    );

    if (result.isEmpty) {
      await db.update(
        'achievements',
        {'unlocked_at': DateTime.now().toIso8601String()},
        where: 'name = ?',
        whereArgs: [name],
      );
      return true;
    }
    return false;
  }

  // --- PROJECTS ---
  Future<List<Project>> getProjects() async {
    final db = await LocalDatabase.instance.database;
    final result = await db.query('projects', orderBy: 'created_at DESC');

    return result.map((json) => Project.fromJson({
      'id': json['id'],
      'name': json['name'],
      'description': json['description'],
    })).toList();
  }

  Future<void> createProject(String name) async {
    final db = await LocalDatabase.instance.database;
    await db.insert('projects', {'name': name});
  }

  // --- ANALYTICS ---
  Future<void> logState(UserLog log) async {
    final db = await LocalDatabase.instance.database;
    await db.insert('user_logs', {
      'energy_level': log.energyLevel,
      'mood': log.mood,
    });
  }

  Future<String> getBurnoutRisk() async {
    final db = await LocalDatabase.instance.database;
    
    // Get recent logs (last 7 days)
    final result = await db.rawQuery('''
      SELECT AVG(energy_level) as avg_energy, COUNT(*) as log_count
      FROM user_logs
      WHERE logged_at >= datetime('now', '-7 days')
    ''');

    if (result.isEmpty || result.first['log_count'] == 0) {
      return "No Data";
    }

    final avgEnergy = result.first['avg_energy'] as double?;
    
    if (avgEnergy == null) return "No Data";
    if (avgEnergy < 4) return "High Risk";
    if (avgEnergy < 6) return "Moderate";
    return "Low Risk";
  }

  // --- ACHIEVEMENTS ---
  Future<List<Map<String, dynamic>>> getAchievements() async {
    final db = await LocalDatabase.instance.database;
    return await db.query('achievements', orderBy: 'id ASC');
  }
}
