import 'package:isar/isar.dart';

part '../generated/entities/alarm.g.dart';

@collection
class Alarm {
  final int id;
  final String title;
  final int durationMinutes;
  final AlarmType alarmType;
  final List<String>? days;
  final String ringtone;
  final bool vibrate;
  final int snoozeDurationMinutes;
  final int snoozeTime;

  Alarm({
    required this.id,
    required this.title,
    required this.alarmType,
    required this.durationMinutes,
    required this.days,
    required this.ringtone,
    required this.vibrate,
    required this.snoozeDurationMinutes,
    required this.snoozeTime,
  });
}

enum AlarmType {
  ringOnce,
  custom,
}
