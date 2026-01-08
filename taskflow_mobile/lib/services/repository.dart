import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';
import '../models/project.dart';
import 'local_database.dart';

class TaskRepository {
  final LocalDatabase _localDb = LocalDatabase.instance;

  Future<List<Task>> getTasks(int userEnergy) async {
    final db = await _localDb.database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    
    List<Task> tasks = maps.map((map) => Task.fromMap(map)).toList();
    
    // Sort by AI score
    tasks.sort((a, b) {
      double scoreA = _calculateScore(a, userEnergy);
      double scoreB = _calculateScore(b, userEnergy);
      return scoreB.compareTo(scoreA);
    });
    
    return tasks;
  }

  double _calculateScore(Task task, int userEnergy) {
    double score = 0;
    int energyDelta = (userEnergy - (task.energyReq * 2)).abs();
    score += (10 - energyDelta) * 3;
    score += task.priority * 2;
    
    // Boost score for tasks due soon
    if (task.dueDate != null) {
      final daysUntilDue = task.dueDate!.difference(DateTime.now()).inDays;
      if (daysUntilDue <= 1) score += 10;
      else if (daysUntilDue <= 3) score += 5;
    }
    
    return score;
  }

  Future<void> addTask(Task task) async {
    final db = await _localDb.database;
    await db.insert('tasks', task.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<String>> completeTask(Task task) async {
    final db = await _localDb.database;
    
    await db.update(
      'tasks',
      {'is_completed': 1, 'completed_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [task.id],
    );

    List<String> unlocked = [];
    
    // Check for achievements
    final completedCount = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM tasks WHERE is_completed = 1'),
    ) ?? 0;

    if (completedCount == 1) {
      await _unlockAchievement(db, 'The Starter');
      unlocked.add('The Starter');
    } else if (completedCount == 10) {
      await _unlockAchievement(db, 'Productivity Master');
      unlocked.add('Productivity Master');
    }

    return unlocked;
  }

  Future<void> _unlockAchievement(Database db, String name) async {
    await db.update(
      'achievements',
      {'unlocked_at': DateTime.now().toIso8601String()},
      where: 'name = ? AND unlocked_at IS NULL',
      whereArgs: [name],
    );
  }

  Future<List<Project>> getProjects() async {
    final db = await _localDb.database;
    final List<Map<String, dynamic>> maps = await db.query('projects');
    return maps.map((map) => Project.fromMap(map)).toList();
  }

  Future<void> addProject(String name) async {
    final db = await _localDb.database;
    await db.insert('projects', {'name': name});
  }

  Future<List<Map<String, dynamic>>> getBadges() async {
    final db = await _localDb.database;
    return await db.query('achievements');
  }

  // --- NEW: EXPORT DATA ---
  Future<void> exportData() async {
    final db = await _localDb.database;
    
    final tasks = await db.query('tasks');
    final projects = await db.query('projects');
    final achievements = await db.query('achievements');

    final data = {
      "timestamp": DateTime.now().toIso8601String(),
      "version": "1.1.0",
      "tasks": tasks,
      "projects": projects,
      "achievements": achievements,
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/taskflow_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonString);

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'TaskFlow Backup - ${DateTime.now().toString().split('.')[0]}',
    );
  }
}
