import '../models/mental_health.dart';
import '../models/skin_health.dart';

// Conditional imports
import 'database_service_stub.dart'
    if (dart.library.io) 'database_service_mobile.dart'
    if (dart.library.html) 'database_service_web.dart';

abstract class DatabaseService {
  static DatabaseService get instance {
    return createDatabaseService();
  }

  Future<int> insertMentalHealthEntry(MentalHealthEntry entry);
  Future<List<MentalHealthEntry>> getMentalHealthEntries({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<MentalHealthEntry?> getLatestMentalHealthEntry();
  Future<int> insertSkinHealthEntry(SkinHealthEntry entry);
  Future<List<SkinHealthEntry>> getSkinHealthEntries({
    DateTime? startDate,
    DateTime? endDate,
  });
  Future<SkinHealthEntry?> getLatestSkinHealthEntry();
}
