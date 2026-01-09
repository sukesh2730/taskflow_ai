class Project {
  final int id;
  final String name;
  final String? description;
  
  Project({required this.id, required this.name, this.description});
  
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    int parseInt(dynamic v) => v is int ? v : (v != null ? int.parse(v.toString()) : 0);
    return Project(
      id: map['id'] is int ? map['id'] as int : parseInt(map['id']),
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
