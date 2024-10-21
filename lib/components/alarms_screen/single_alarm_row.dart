import 'dart:io';
import 'dart:math';

import 'package:alarm/alarm.dart' as alarm_lib;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../entities/alarm_entity.dart';
import '../../packages/flutter_overlay_loader/flutter_overlay_loader.dart';
import '../../services/isar_service.dart';
import '../../util/functions.dart';
import '../common/confirmation_dialog_box.dart';
import 'create_or_update_alarm.dart';

class SingleAlarmRow extends StatefulWidget {
  final AlarmEntity alarm;
  final int index;
  final Future<void> Function() refetch;

  const SingleAlarmRow({
    super.key,
    required this.alarm,
    required this.refetch,
    required this.index,
  });

  @override
  State<SingleAlarmRow> createState() => _SingleAlarmRowState();
}

class _SingleAlarmRowState extends State<SingleAlarmRow> {
  bool alarmOn = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      alarmOn = widget.alarm.alarmEnabled;
    });
  }

  String formatDurationToTime(int durationMinutes) {
    // Calculate the total hours and minutes
    int hours = durationMinutes ~/ 60;
    int minutes = durationMinutes % 60;

    // Adjust hours for 12-hour format
    hours = hours % 12;
    hours =
        hours == 0 ? 12 : hours; // Convert '0' hours to '12' for AM/PM format

    // Format hours and minutes to two digits
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');

    // Return formatted time string
    return "$hoursStr:$minutesStr";
  }

  String getAmPmPeriod(int durationMinutes) {
    // Calculate the total hours
    int hours = durationMinutes ~/ 60;

    // Determine AM/PM period
    return hours >= 12 ? "PM" : "AM";
  }

  onAlarmEnabledChanged(value) async {
    setState(
      () => alarmOn = value,
    );
    await updateAnAlarmEnabled(widget.alarm, value);
  }

  // Future<void> deleteAlarm() async {
  //   Loader.show(context);
  //   await IsarService().deleteAnAlarm(widget.alarm.id);
  //   await alarm_lib.Alarm.stop(widget.alarm.id);
  //   await widget.refetch();
  //   Future.delayed(Duration.zero, () {
  //     Loader.hide();
  //   });
  //   // Ensure the widget is still mounted before using context
  //   if (!mounted) return;

  //   // Check if the navigator can pop
  //   if (Navigator.canPop(context)) {
  //     Navigator.pop(context);
  //   }
  // }

  Future<void> deleteAlarm() async {
    Loader.show(context);

    // 1. First, delete the alarm from your local database (Isar)
    await IsarService().deleteAnAlarm(widget.alarm.id);

    // 2. If the alarm is a repetitive alarm, delete all its instances
    if (widget.alarm.days != null && widget.alarm.days!.isNotEmpty) {
      // Loop through each weekday instance and stop the associated alarms
      for (String day in widget.alarm.days!) {
        int dayId = widget.alarm.id + getDayOffset(day);
        await alarm_lib.Alarm.stop(dayId);
      }
    } else {
      // 3. If it's a one-time alarm, simply stop it using its id
      await alarm_lib.Alarm.stop(widget.alarm.id);
    }

    // 4. Refresh the UI or data
    await widget.refetch();

    // 5. Hide the loader and navigate back
    Future.delayed(Duration.zero, () {
      Loader.hide();
    });

    // Ensure the widget is still mounted before using context
    if (!mounted) return;

    // Check if the navigator can pop
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<bool> updateAnAlarmEnabled(
      AlarmEntity currentAlarm, bool alarmEnabled) async {
    try {
      final isar = await IsarService().openDB();

      // Stop the alarm if it's currently enabled and needs to be disabled
      if (!alarmEnabled) {
        await alarm_lib.Alarm.stop(currentAlarm.id);
      } else {
        // Create alarm settings when enabling the alarm
        if (currentAlarm.days == null ||
            (currentAlarm.days != null && currentAlarm.days!.isEmpty)) {
          // One-time alarm
          await _setSingleAlarm(currentAlarm);
        } else {
          // Recurring alarms based on selected days
          await _setRecurringAlarms(currentAlarm);
        }
      }

      // Update the alarm in the database
      await isar.writeAsync(
        (isarDb) => isarDb.alarmEntitys.put(
          AlarmEntity(
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

  // Helper to set a one-time alarm
  Future<void> _setSingleAlarm(AlarmEntity alarm) async {
    DateTime now = DateTime.now();

    // Set the alarm time based on the current day and duration
    DateTime selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
    ).add(Duration(minutes: alarm.durationMinutes));

    // If the selected time has already passed today, move it to the next day
    if (selectedDateTime.isBefore(now)) {
      selectedDateTime = selectedDateTime.add(const Duration(days: 1));
    }

    // Create the alarm settings and set the alarm
    final alarmSettings = _createAlarmSettings(alarm, selectedDateTime);
    await alarm_lib.Alarm.set(alarmSettings: alarmSettings);
  }

// Helper to set recurring alarms based on selected days
  Future<void> _setRecurringAlarms(AlarmEntity alarm) async {
    DateTime now = DateTime.now();

    for (String day in alarm.days!) {
      int daysOffset = _getDaysOffset(day);

      if (daysOffset == -1) continue; // Skip if no valid day offset

      // Set the alarm time based on the current week and day offset
      DateTime selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(Duration(minutes: alarm.durationMinutes, days: daysOffset));

      // If the selected time has passed for this day, move it to the next week
      if (selectedDateTime.isBefore(now)) {
        selectedDateTime = selectedDateTime.add(const Duration(days: 7));
      }

      // Create the alarm settings and set the recurring alarm
      final alarmSettings = _createAlarmSettings(alarm, selectedDateTime);
      await alarm_lib.Alarm.set(alarmSettings: alarmSettings);
    }
  }

  // Helper to create alarm settings
  alarm_lib.AlarmSettings _createAlarmSettings(
      AlarmEntity alarm, DateTime selectedDateTime) {
    return alarm_lib.AlarmSettings(
      id: alarm.id,
      dateTime: selectedDateTime,
      assetAudioPath: 'assets/ringtones/${alarm.ringtone}',
      loopAudio: true,
      vibrate: alarm.vibrate,
      volume: 0.8,
      fadeDuration: 3.0,
      warningNotificationOnKill: Platform.isIOS,
      notificationSettings: alarm_lib.NotificationSettings(
        title: alarm.title,
        body: '${alarm.title} is now active.',
        stopButton: 'Stop',
      ),
    );
  }

  int _getDaysOffset(String day) {
    int today = DateTime.now().weekday;
    int targetDay;

    switch (day) {
      case 'SUN':
        targetDay = DateTime.sunday;
        break;
      case 'MON':
        targetDay = DateTime.monday;
        break;
      case 'TUE':
        targetDay = DateTime.tuesday;
        break;
      case 'WED':
        targetDay = DateTime.wednesday;
        break;
      case 'THU':
        targetDay = DateTime.thursday;
        break;
      case 'FRI':
        targetDay = DateTime.friday;
        break;
      case 'SAT':
        targetDay = DateTime.saturday;
        break;
      default:
        return -1;
    }

    if (targetDay >= today) {
      return targetDay - today;
    } else {
      return 7 - (today - targetDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return FadeInUp(
      duration: Duration(milliseconds: min(widget.index + 1, 5) * 100),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return CreateOrUpdateAlarm(
                refetch: widget.refetch,
                alarm: widget.alarm,
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: MediaQuery.sizeOf(context).height * 0.14,
          decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.alarm.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        formatDurationToTime(widget.alarm.durationMinutes),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        getAmPmPeriod(widget.alarm.durationMinutes),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.alarm.ringOnce ? 'Ring Once' : 'Repeat',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: Switch.adaptive(
                      value: alarmOn,
                      onChanged: onAlarmEnabledChanged,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmationDialogBox(
                            onYesPressed: deleteAlarm,
                          );
                        },
                      );
                    },
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.04,
                      width: MediaQuery.sizeOf(context).width * 0.18,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.6),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
