import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../entities/alarm.dart';

class IsarService {
  late Future<Isar> db;

  /// Gets Called when we initiate a new Isar Instance
  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      schemas: [AlarmSchema],
      directory: dir.path,
    );
  }

  Future<bool> createAlarm(Alarm alarm) async {
    try {
      final isar = await openDB();
      await isar.writeAsync((isarDb) {
        isarDb.alarms.put(alarm); // insert & update
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
