class HealthMetric {
  final DateTime timestamp;
  final double? value;
  final String type;
  final String? unit;

  HealthMetric({
    required this.timestamp,
    this.value,
    required this.type,
    this.unit,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'value': value,
    'type': type,
    'unit': unit,
  };

  factory HealthMetric.fromJson(Map<String, dynamic> json) => HealthMetric(
    timestamp: DateTime.parse(json['timestamp']),
    value: json['value']?.toDouble(),
    type: json['type'],
    unit: json['unit'],
  );
}

class HRVData extends HealthMetric {
  HRVData({required super.timestamp, required double value})
    : super(value: value, type: 'hrv', unit: 'ms');
}

class HeartRateData extends HealthMetric {
  HeartRateData({required super.timestamp, required double value})
    : super(value: value, type: 'heart_rate', unit: 'bpm');
}

class StepsData extends HealthMetric {
  StepsData({required super.timestamp, required double value})
    : super(value: value, type: 'steps', unit: 'steps');
}

class SleepData extends HealthMetric {
  SleepData({required super.timestamp, required double value})
    : super(value: value, type: 'sleep', unit: 'hours');
}

