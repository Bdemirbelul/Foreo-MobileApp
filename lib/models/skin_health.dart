class SkinHealthEntry {
  final DateTime timestamp;
  final int condition; // 1-5 scale
  final int? hydration; // 1-10 scale
  final int? moisture; // 1-10 scale
  final bool? hasAcne;
  final String? notes;
  final String? photoPath;

  SkinHealthEntry({
    required this.timestamp,
    required this.condition,
    this.hydration,
    this.moisture,
    this.hasAcne,
    this.notes,
    this.photoPath,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'condition': condition,
    'hydration': hydration,
    'moisture': moisture,
    'hasAcne': hasAcne == null
        ? null
        : hasAcne!
        ? 1
        : 0,
    'notes': notes,
    'photoPath': photoPath,
  };

  factory SkinHealthEntry.fromJson(Map<String, dynamic> json) =>
      SkinHealthEntry(
        timestamp: DateTime.parse(json['timestamp']),
        condition: json['condition'],
        hydration: json['hydration'],
        moisture: json['moisture'],
        hasAcne: _parseBool(json['hasAcne']),
        notes: json['notes'],
        photoPath: json['photoPath'],
      );

  static bool? _parseBool(dynamic rawValue) {
    if (rawValue == null) return null;
    if (rawValue is bool) return rawValue;
    if (rawValue is num) return rawValue != 0;
    if (rawValue is String) {
      final normalized = rawValue.toLowerCase();
      if (normalized == 'true') return true;
      if (normalized == 'false') return false;
      final numeric = num.tryParse(normalized);
      if (numeric != null) return numeric != 0;
    }
    return null;
  }
}
