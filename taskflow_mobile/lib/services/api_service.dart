import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../models/project.dart';
import '../models/log.dart';

// CHANGE THIS IP TO MATCH YOUR SETUP
const String baseUrl = 'http://10.0.2.2:8000/api/v1';

class ApiService {
  // --- TASKS ---
  Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks/'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Task.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
  
  Future<void> createTask(Map<String, dynamic> taskData) async {
    await http.post(
      Uri.parse('$baseUrl/tasks/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(taskData),
    );
  }
  
  // Returns list of unlocked badges
  Future<List<String>> completeTask(int id) async {
    final response = await http.put(Uri.parse('$baseUrl/tasks/$id/complete'));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body['badges_unlocked'] != null) {
        return List<String>.from(body['badges_unlocked']);
      }
    }
    return [];
  }
  
  // --- PROJECTS ---
  Future<List<Project>> getProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/projects/'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Project.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
  
  Future<void> createProject(String name) async {
    await http.post(
      Uri.parse('$baseUrl/projects/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"name": name}),
    );
  }
  
  // --- ANALYTICS ---
  Future<void> logState(UserLog log) async {
    await http.post(
      Uri.parse('$baseUrl/analytics/log-state'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(log.toJson()),
    );
  }
  
  Future<String> getBurnoutRisk() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/analytics/burnout-risk'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['risk_level'];
      }
      return "Unknown";
    } catch (e) {
      return "Offline";
    }
  }
}
