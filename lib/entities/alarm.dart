import 'package:isar/isar.dart';

part '../generated/entities/alarm.g.dart';

@collection
class Alarm {
  final int id;
  final bool alarmEnabled;
  final String title;
  final int durationMinutes;
  final bool ringOnce;
  final List<String>? days;
  final String ringtone;
  final bool vibrate;
  final bool enableSnooze;
  final int snoozeDurationMinutes;
  final int snoozeTime;

  Alarm({
    required this.id,
    required this.alarmEnabled,
    required this.title,
    required this.ringOnce,
    required this.durationMinutes,
    required this.days,
    required this.ringtone,
    required this.vibrate,
    required this.enableSnooze,
    required this.snoozeDurationMinutes,
    required this.snoozeTime,
  });
}
