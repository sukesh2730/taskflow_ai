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

  factory Task.fromMap(Map<String, dynamic> map) {
    int parseInt(dynamic v) => v is int ? v : (v != null ? int.parse(v.toString()) : 0);
    final isCompletedValue = map['is_completed'] ?? map['isCompleted'] ?? 0;
    return Task(
      id: map['id'] is int ? map['id'] as int : int.parse(map['id'].toString()),
      title: map['title']?.toString() ?? '',
      category: map['category'] ?? 'General',
      priority: map['priority'] != null ? parseInt(map['priority']) : 3,
      energyReq: map['energy_req'] != null ? parseInt(map['energy_req']) : (map['energyReq'] != null ? parseInt(map['energyReq']) : 3),
      estimatedMinutes: map['estimated_minutes'] != null ? parseInt(map['estimated_minutes']) : (map['estimatedMinutes'] != null ? parseInt(map['estimatedMinutes']) : 30),
      isCompleted: isCompletedValue == 1 || isCompletedValue == true,
      projectId: map['project_id'] != null ? (map['project_id'] is int ? map['project_id'] as int : int.parse(map['project_id'].toString())) : (map['projectId'] != null ? (map['projectId'] is int ? map['projectId'] as int : int.parse(map['projectId'].toString())) : null),
      dueDate: map['due_date'] != null ? DateTime.tryParse(map['due_date'].toString()) : (map['dueDate'] != null ? DateTime.tryParse(map['dueDate'].toString()) : null),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
