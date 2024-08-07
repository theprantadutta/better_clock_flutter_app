import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../components/alarms_screen/alarms_list.dart';
import '../components/world_clock_screen/clock_lists.dart';
import '../entities/alarm.dart';
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
      schemas: [AlarmSchema, WorldClockSchema],
      directory: dir.path,
    );
  }

  Future<bool> createAlarm(Alarm alarm) async {
    try {
      final isar = await openDB();
      await isar.writeAsync((isarDb) {
        isarDb.alarms.put(alarm);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Alarm>> getAllAlarm() async {
    final isar = await openDB();
    final allAlarms = await isar.alarms.where().findAllAsync();
    if (allAlarms.isEmpty) {
      await isar.writeAsync((isarDb) => isarDb.alarms.putAll(initialAlarms));
      return initialAlarms;
    }
    return allAlarms;
  }

  Stream<void> watchAlarmChange() async* {
    final isar = await openDB();
    yield isar.alarms.watchLazy(fireImmediately: true);
  }

  Future<Alarm?> getAlarmById(int alarmId) async {
    final isar = await openDB();
    return await isar.alarms.where().idEqualTo(alarmId).findFirstAsync();
  }

  Future<bool> updateAnAlarmEnabled(
    Alarm currentAlarm,
    bool alarmEnabled,
  ) async {
    try {
      final isar = await IsarService().openDB();
      await isar.writeAsync(
        (isarDb) => isarDb.alarms.put(
          Alarm(
            id: currentAlarm.id,
            alarmEnabled: alarmEnabled,
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
      await isar.writeAsync((isarDb) => isarDb.alarms.delete(id));
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
