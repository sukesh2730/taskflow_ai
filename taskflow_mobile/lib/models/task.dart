class Task {
  final int id;
  final String title;
  final String category;
  final int priority;
  final int energyReq;
  final int estimatedMinutes;
  final bool isCompleted;
  final int? projectId;
  final DateTime? dueDate;
  
  Task({
    required this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.energyReq,
    required this.estimatedMinutes,
    required this.isCompleted,
    this.projectId,
    this.dueDate,
  });
  
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      category: json['category'] ?? 'General',
      priority: json['priority'] ?? 3,
      energyReq: json['energy_req'] ?? 3,
      estimatedMinutes: json['estimated_minutes'] ?? 30,
      isCompleted: json['is_completed'] ?? false,
      projectId: json['project_id'],
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date']) : null,
    );
  }
}
