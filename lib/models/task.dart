class Task {
  final int? id;
  final String title;
  final String category;
  final int priority;
  final int energyReq;
  final int estimatedMinutes;
  final bool isCompleted;
  final int? projectId;
  final DateTime? dueDate;

  Task({
    this.id,
    required this.title,
    required this.category,
    required this.priority,
    required this.energyReq,
    required this.estimatedMinutes,
    required this.isCompleted,
    this.projectId,
    this.dueDate,
  });

  // Legacy JSON factory left for backward compatibility
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task.fromMap(json);
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    int? parseInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      return int.tryParse(v.toString());
    }

    bool parseBool(dynamic v) {
      if (v == null) return false;
      if (v is bool) return v;
      if (v is int) return v == 1;
      return v.toString().toLowerCase() == 'true';
    }

    return Task(
      id: parseInt(map['id']),
      title: map['title']?.toString() ?? '',
      category: map['category']?.toString() ?? 'General',
      priority: parseInt(map['priority']) ?? 3,
      energyReq: parseInt(map['energy_req'] ?? map['energyReq']) ?? 3,
      estimatedMinutes: parseInt(map['estimated_minutes'] ?? map['estimatedMinutes']) ?? 30,
      isCompleted: parseBool(map['is_completed'] ?? map['isCompleted']),
      projectId: parseInt(map['project_id'] ?? map['projectId']),
      dueDate: map['due_date'] != null ? DateTime.parse(map['due_date'].toString()) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'category': category,
      'priority': priority,
      'energy_req': energyReq,
      'estimated_minutes': estimatedMinutes,
      'is_completed': isCompleted ? 1 : 0,
      'project_id': projectId,
      'due_date': dueDate?.toIso8601String(),
    };
  }
}
