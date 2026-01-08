class UserLog {
  final int energyLevel;
  final String mood;

  UserLog({required this.energyLevel, required this.mood});

  Map<String, dynamic> toJson() {
    return {
      'energy_level': energyLevel,
      'mood': mood,
    };
  }
}
