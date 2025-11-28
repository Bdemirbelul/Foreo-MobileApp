import 'dart:math';
import '../models/health_metric.dart';
import '../models/mental_health.dart';
import '../models/skin_health.dart';

class MockDataService {
  static final Random _random = Random();

  // Generate fake HRV data
  static List<HRVData> generateHRVData({int days = 7}) {
    final now = DateTime.now();
    final data = <HRVData>[];
    
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      // Generate 3-5 readings per day
      final readings = _random.nextInt(3) + 3;
      
      for (int j = 0; j < readings; j++) {
        final hour = _random.nextInt(24);
        final minute = _random.nextInt(60);
        final timestamp = DateTime(date.year, date.month, date.day, hour, minute);
        
        // HRV typically ranges from 20-100ms, with some variation
        final baseValue = 40 + _random.nextDouble() * 40;
        final variation = (baseValue + (_random.nextDouble() - 0.5) * 20).clamp(20.0, 100.0);
        
        data.add(HRVData(
          timestamp: timestamp,
          value: variation,
        ));
      }
    }
    
    return data..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Generate fake heart rate data
  static List<HeartRateData> generateHeartRateData({int days = 7}) {
    final now = DateTime.now();
    final data = <HeartRateData>[];
    
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final readings = _random.nextInt(5) + 5;
      
      for (int j = 0; j < readings; j++) {
        final hour = _random.nextInt(24);
        final minute = _random.nextInt(60);
        final timestamp = DateTime(date.year, date.month, date.day, hour, minute);
        
        // Heart rate typically 60-100 bpm at rest
        final baseValue = 70 + _random.nextDouble() * 20;
        final variation = (baseValue + (_random.nextDouble() - 0.5) * 15).clamp(60.0, 100.0);
        
        data.add(HeartRateData(
          timestamp: timestamp,
          value: variation,
        ));
      }
    }
    
    return data..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Generate fake steps data
  static List<StepsData> generateStepsData({int days = 7}) {
    final now = DateTime.now();
    final data = <StepsData>[];
    
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final timestamp = DateTime(date.year, date.month, date.day, 23, 59);
      
      // Daily steps typically 5000-15000
      final steps = (5000 + _random.nextDouble() * 10000).round().toDouble();
      
      data.add(StepsData(
        timestamp: timestamp,
        value: steps,
      ));
    }
    
    return data..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Generate fake sleep data
  static List<SleepData> generateSleepData({int days = 7}) {
    final now = DateTime.now();
    final data = <SleepData>[];
    
    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final sleepHour = 22 + _random.nextInt(2); // Sleep between 22-23
      final wakeHour = 6 + _random.nextInt(2); // Wake between 6-7
      
      final sleepTime = DateTime(date.year, date.month, date.day, sleepHour, 0);
      final wakeTime = DateTime(date.year, date.month, date.day + 1, wakeHour, 0);
      
      final duration = wakeTime.difference(sleepTime);
      final hours = duration.inHours + (duration.inMinutes % 60) / 60.0;
      
      data.add(SleepData(
        timestamp: sleepTime,
        value: hours.clamp(6.0, 9.0),
      ));
    }
    
    return data..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  // Generate today's summary
  static Map<String, dynamic> generateTodaySummary() {
    final hrv = generateHRVData(days: 1);
    final hr = generateHeartRateData(days: 1);
    final steps = generateStepsData(days: 1);
    final sleep = generateSleepData(days: 1);
    
    return {
      'hrv': hrv.isNotEmpty ? hrv.map((e) => e.value!).reduce((a, b) => a + b) / hrv.length : null,
      'heartRate': hr.isNotEmpty ? hr.map((e) => e.value!).reduce((a, b) => a + b) / hr.length : null,
      'steps': steps.isNotEmpty ? steps.first.value : null,
      'sleep': sleep.isNotEmpty ? sleep.first.value : null,
    };
  }
}




