import 'package:flutter/material.dart';

class Medication {
  final String id;
  final String name;
  final String dosage;
  final List<int> daysOfWeek; // 0=Sunday, 1=Monday, etc.
  final List<TimeOfDay> times; // Times to take medication
  final DateTime startDate;
  final DateTime? endDate;
  final String? notes;
  final bool isActive;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.daysOfWeek,
    required this.times,
    required this.startDate,
    this.endDate,
    this.notes,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dosage': dosage,
    'daysOfWeek': daysOfWeek,
    'times': times
        .map(
          (t) =>
              '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}',
        )
        .toList(),
    'startDate': startDate.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'notes': notes,
    'isActive': isActive,
  };

  factory Medication.fromJson(Map<String, dynamic> json) {
    final timesList = (json['times'] as List? ?? []);
    final times = timesList
        .map((t) {
          if (t is String) {
            final parts = t.split(':');
            return TimeOfDay(
              hour: int.parse(parts[0]),
              minute: int.parse(parts[1]),
            );
          }
          return null;
        })
        .whereType<TimeOfDay>()
        .toList();

    return Medication(
      id: json['id'],
      name: json['name'],
      dosage: json['dosage'],
      daysOfWeek: List<int>.from(json['daysOfWeek']),
      times: times,
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
    );
  }
}
