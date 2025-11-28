class MentalHealthEntry {
  final DateTime timestamp;
  final int mood; // 1-5 scale
  final int? stress; // 1-10 scale
  final int? anxiety; // 1-10 scale
  final int? energy; // 1-10 scale
  final String? notes;

  MentalHealthEntry({
    required this.timestamp,
    required this.mood,
    this.stress,
    this.anxiety,
    this.energy,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'mood': mood,
    'stress': stress,
    'anxiety': anxiety,
    'energy': energy,
    'notes': notes,
  };

  factory MentalHealthEntry.fromJson(Map<String, dynamic> json) =>
      MentalHealthEntry(
        timestamp: DateTime.parse(json['timestamp']),
        mood: json['mood'],
        stress: json['stress'],
        anxiety: json['anxiety'],
        energy: json['energy'],
        notes: json['notes'],
      );
}

