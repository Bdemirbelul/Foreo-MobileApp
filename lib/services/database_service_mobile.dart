import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import '../models/mental_health.dart';
import '../models/skin_health.dart';
import 'database_service.dart' as base;

base.DatabaseService createDatabaseService() {
  return DatabaseServiceMobile();
}

class DatabaseServiceMobile extends base.DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final dbPath = path.join(databasesPath, 'wellbeing.db');

    return await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Mental health table
    await db.execute('''
      CREATE TABLE mental_health (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        mood INTEGER NOT NULL,
        stress INTEGER,
        anxiety INTEGER,
        energy INTEGER,
        notes TEXT
      )
    ''');

    // Skin health table
    await db.execute('''
      CREATE TABLE skin_health (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp TEXT NOT NULL,
        condition INTEGER NOT NULL,
        hydration INTEGER,
        moisture INTEGER,
        hasAcne INTEGER,
        notes TEXT,
        photoPath TEXT
      )
    ''');
  }

  @override
  Future<int> insertMentalHealthEntry(MentalHealthEntry entry) async {
    final db = await database;
    return await db.insert('mental_health', entry.toJson());
  }

  @override
  Future<List<MentalHealthEntry>> getMentalHealthEntries({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String? where;
    List<dynamic>? whereArgs;

    if (startDate != null || endDate != null) {
      final conditions = <String>[];
      final args = <dynamic>[];

      if (startDate != null) {
        conditions.add('timestamp >= ?');
        args.add(startDate.toIso8601String());
      }
      if (endDate != null) {
        conditions.add('timestamp <= ?');
        args.add(endDate.toIso8601String());
      }

      where = conditions.join(' AND ');
      whereArgs = args;
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'mental_health',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return MentalHealthEntry.fromJson(maps[i]);
    });
  }

  @override
  Future<MentalHealthEntry?> getLatestMentalHealthEntry() async {
    final entries = await getMentalHealthEntries();
    return entries.isNotEmpty ? entries.first : null;
  }

  @override
  Future<int> insertSkinHealthEntry(SkinHealthEntry entry) async {
    final db = await database;
    return await db.insert('skin_health', entry.toJson());
  }

  @override
  Future<List<SkinHealthEntry>> getSkinHealthEntries({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String? where;
    List<dynamic>? whereArgs;

    if (startDate != null || endDate != null) {
      final conditions = <String>[];
      final args = <dynamic>[];

      if (startDate != null) {
        conditions.add('timestamp >= ?');
        args.add(startDate.toIso8601String());
      }
      if (endDate != null) {
        conditions.add('timestamp <= ?');
        args.add(endDate.toIso8601String());
      }

      where = conditions.join(' AND ');
      whereArgs = args;
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'skin_health',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return SkinHealthEntry.fromJson(maps[i]);
    });
  }

  @override
  Future<SkinHealthEntry?> getLatestSkinHealthEntry() async {
    final entries = await getSkinHealthEntries();
    return entries.isNotEmpty ? entries.first : null;
  }
}
