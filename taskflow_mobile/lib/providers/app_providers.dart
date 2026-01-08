import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_api_service.dart';
import '../services/repository.dart';
import '../models/task.dart';
import '../models/project.dart';

// Use LOCAL API (no server needed)
final apiServiceProvider = Provider((ref) => LocalApiService());
final repositoryProvider = Provider((ref) => TaskRepository());

final userEnergyProvider = StateProvider<int>((ref) => 5);

final taskListProvider = FutureProvider<List<Task>>((ref) async {
  final repo = ref.watch(repositoryProvider);
  final energy = ref.watch(userEnergyProvider);
  return repo.getTasks(energy);
});

final projectListProvider = FutureProvider<List<Project>>((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.getProjects();
});

final burnoutRiskProvider = FutureProvider<String>((ref) async {
  return "Low (Offline)";
});

final achievementsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.watch(repositoryProvider);
  return repo.getBadges();
});
