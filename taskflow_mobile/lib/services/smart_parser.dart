class SmartParser {
  static Map<String, dynamic> parse(String input) {
    String title = input;
    int priority = 3;
    int energyReq = 3;
    DateTime? dueDate;

    final lowerInput = input.toLowerCase();

    // Priority detection
    if (lowerInput.contains('urgent') || lowerInput.contains('important') || lowerInput.contains('asap')) {
      priority = 5;
      energyReq = 4;
      title = title.replaceAll(RegExp(r'\b(urgent|important|asap)\b', caseSensitive: false), '').trim();
    } else if (lowerInput.contains('low priority') || lowerInput.contains('maybe')) {
      priority = 1;
      energyReq = 2;
      title = title.replaceAll(RegExp(r'\b(low priority|maybe)\b', caseSensitive: false), '').trim();
    }

    // Date detection
    final now = DateTime.now();
    if (lowerInput.contains('today')) {
      dueDate = now;
      title = title.replaceAll(RegExp(r'\btoday\b', caseSensitive: false), '').trim();
    } else if (lowerInput.contains('tomorrow')) {
      dueDate = now.add(const Duration(days: 1));
      title = title.replaceAll(RegExp(r'\btomorrow\b', caseSensitive: false), '').trim();
    } else if (lowerInput.contains('next week')) {
      dueDate = now.add(const Duration(days: 7));
      title = title.replaceAll(RegExp(r'\bnext week\b', caseSensitive: false), '').trim();
    }

    return {
      'title': title.trim(),
      'priority': priority,
      'energy_req': energyReq,
      'due_date': dueDate,
    };
  }
}
