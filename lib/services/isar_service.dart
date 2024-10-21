import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/alarms_screen/alarms_list.dart';
import '../components/world_clock_screen/clock_lists.dart';
import '../entities/alarm_entity.dart';
import '../entities/world_clock.dart';

class IsarService {
  late Future<Isar> db;

  /// Gets Called when we initiate a new Isar Instance
  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open(
      schemas: [AlarmEntitySchema, WorldClockSchema],
      directory: dir.path,
    );
  }

  Future<bool> createAlarm(AlarmEntity alarm) async {
    try {
      final isar = await openDB();
      await isar.writeAsync((isarDb) {
        isarDb.alarmEntitys.put(alarm);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<AlarmEntity>> getAllAlarm() async {
    final isar = await openDB();

    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();

    // Check if alarms have been initialized before
    final bool hasInitializedAlarms =
        prefs.getBool('hasInitializedAlarms') ?? true;

    // Fetch all alarms from the database
    final allAlarms = await isar.alarmEntitys.where().findAllAsync();

    // If alarms have not been initialized, initialize them
    if (allAlarms.isEmpty && !hasInitializedAlarms) {
      // Insert initial alarms
      await isar.writeAsync((isarDb) => isarDb.alarmEntitys.putAll(initialAlarms));

      // Set initialization flag to true
      await prefs.setBool('hasInitializedAlarms', true);

      return initialAlarms;
    }

    // Return existing alarms if already initialized
    return allAlarms;
  }

  Stream<List<AlarmEntity>> watchAllAlarms() async* {
    final isar = await openDB();

    // Watch for changes in the 'alarms' collection
    yield* isar.alarmEntitys.watchLazy().asyncMap((_) async {
      // Return the updated list of alarms whenever there is a change
      return await isar.alarmEntitys.where().findAllAsync();
    });
  }

  Stream<void> watchAlarmChange() async* {
    final isar = await openDB();
    yield isar.alarmEntitys.watchLazy(fireImmediately: true);
  }

  Future<AlarmEntity?> getAlarmById(int alarmId) async {
    final isar = await openDB();
    return await isar.alarmEntitys.where().idEqualTo(alarmId).findFirstAsync();
  }

  Future<bool> updateAnAlarmEnabled(
    AlarmEntity currentAlarm,
    bool alarmEnabled,
  ) async {
    try {
      final isar = await IsarService().openDB();
      await isar.writeAsync(
        (isarDb) => isarDb.alarmEntitys.put(
          AlarmEntity(
            id: currentAlarm.id,
            alarmEnabled: !currentAlarm.ringOnce || alarmEnabled,
            title: currentAlarm.title,
            ringOnce: currentAlarm.ringOnce,
            durationMinutes: currentAlarm.durationMinutes,
            days: currentAlarm.days,
            ringtone: currentAlarm.ringtone,
            vibrate: currentAlarm.vibrate,
            enableSnooze: currentAlarm.enableSnooze,
            snoozeDurationMinutes: currentAlarm.snoozeDurationMinutes,
            snoozeTime: currentAlarm.snoozeTime,
          ),
        ),
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> deleteAnAlarm(int id) async {
    try {
      final isar = await openDB();
      await isar.writeAsync((isarDb) => isarDb.alarmEntitys.delete(id));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<bool> deleteAClock(int id) async {
    try {
      final isar = await openDB();
      await isar.writeAsync((isarDb) => isarDb.worldClocks.delete(id));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }

  Future<List<WorldClock>> getInitialWorldClock() async {
    final isar = await IsarService().openDB();
    final worldClocks = await isar.worldClocks.where().findAllAsync();
    if (worldClocks.isEmpty) {
      await isar.writeAsync(
        (isarDb) => isarDb.worldClocks.putAll(initialClocks),
      );
      return initialClocks;
    } else {
      return worldClocks;
    }
  }

  Future<bool> createNewClock({
    required String city,
    required String timeZone,
    required bool isCurrentTimeZone,
  }) async {
    try {
      final isar = await openDB();
      final existingCity =
          await isar.worldClocks.where().cityEqualTo(city).findFirstAsync();
      if (existingCity != null) return false;
      isar.write(
        (isarDb) => isarDb.worldClocks.put(
          WorldClock(
            id: isar.worldClocks.autoIncrement(),
            city: city,
            timeZone: timeZone,
            isCurrentTimeZone: isCurrentTimeZone,
          ),
        ),
      );
      return true;
    } catch (e) {
      if (kDebugMode) print(e);
      return false;
    }
  }
}
