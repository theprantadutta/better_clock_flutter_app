import 'package:flutter/foundation.dart';
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

  Future<List<Alarm>> getAllAlarm() async {
    final isar = await openDB();
    return isar.alarms.where().findAllAsync();
  }

  Stream<void> watchAlarmChange() async* {
    final isar = await openDB();
    yield isar.alarms.watchLazy(fireImmediately: true);
  }

  Future<bool> updateAnAlarmEnabled(
      Alarm currentAlarm, bool alarmEnabled) async {
    try {
      final isar = await IsarService().openDB();
      await isar.writeAsync((isarDb) => isarDb.alarms.put(
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
          ));
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
}
