import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mental_health.dart';
import '../models/skin_health.dart';
import 'database_service.dart' as base;

base.DatabaseService createDatabaseService() {
  return DatabaseServiceWeb();
}

class DatabaseServiceWeb extends base.DatabaseService {
  static const String _mentalHealthKey = 'mental_health_entries';
  static const String _skinHealthKey = 'skin_health_entries';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  @override
  Future<int> insertMentalHealthEntry(MentalHealthEntry entry) async {
    final prefs = await _prefs;
    final entries = await getMentalHealthEntries();
    entries.insert(0, entry);
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_mentalHealthKey, jsonEncode(jsonList));
    return entries.length;
  }

  @override
  Future<List<MentalHealthEntry>> getMentalHealthEntries({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_mentalHealthKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    var entries = jsonList
        .map((json) => MentalHealthEntry.fromJson(json as Map<String, dynamic>))
        .toList();

    if (startDate != null) {
      entries = entries
          .where(
            (e) =>
                e.timestamp.isAfter(startDate) ||
                e.timestamp.isAtSameMomentAs(startDate),
          )
          .toList();
    }
    if (endDate != null) {
      entries = entries
          .where(
            (e) =>
                e.timestamp.isBefore(endDate) ||
                e.timestamp.isAtSameMomentAs(endDate),
          )
          .toList();
    }

    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  @override
  Future<MentalHealthEntry?> getLatestMentalHealthEntry() async {
    final entries = await getMentalHealthEntries();
    return entries.isNotEmpty ? entries.first : null;
  }

  @override
  Future<int> insertSkinHealthEntry(SkinHealthEntry entry) async {
    final prefs = await _prefs;
    final entries = await getSkinHealthEntries();
    entries.insert(0, entry);
    final jsonList = entries.map((e) => e.toJson()).toList();
    await prefs.setString(_skinHealthKey, jsonEncode(jsonList));
    return entries.length;
  }

  @override
  Future<List<SkinHealthEntry>> getSkinHealthEntries({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_skinHealthKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    var entries = jsonList
        .map((json) => SkinHealthEntry.fromJson(json as Map<String, dynamic>))
        .toList();

    if (startDate != null) {
      entries = entries
          .where(
            (e) =>
                e.timestamp.isAfter(startDate) ||
                e.timestamp.isAtSameMomentAs(startDate),
          )
          .toList();
    }
    if (endDate != null) {
      entries = entries
          .where(
            (e) =>
                e.timestamp.isBefore(endDate) ||
                e.timestamp.isAtSameMomentAs(endDate),
          )
          .toList();
    }

    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  @override
  Future<SkinHealthEntry?> getLatestSkinHealthEntry() async {
    final entries = await getSkinHealthEntries();
    return entries.isNotEmpty ? entries.first : null;
  }
}
