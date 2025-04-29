import 'dart:io';

import 'package:alarm/alarm.dart' as alarm_lib;
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

import '../../constants/selectors.dart';
import '../../entities/alarm_entity.dart';
import '../../packages/flutter_overlay_loader/flutter_overlay_loader.dart';
import '../../services/isar_service.dart';
import 'alarm_snooze.dart';
import 'alarm_type_button.dart';
import 'day_button.dart';
import 'ringtone_list.dart';
import 'timer_picker.dart';

const kSunDay = 'SUN';
const kMonDay = 'MON';
const kTueDay = 'TUE';
const kWedDay = 'WED';
const kThuDay = 'THU';
const kFriDay = 'FRI';
const kSatDay = 'SAT';

class CreateOrUpdateAlarm extends StatefulWidget {
  final Future<void> Function() refetch;
  final AlarmEntity? alarm;

  const CreateOrUpdateAlarm({
    super.key,
    required this.refetch,
    this.alarm,
  });

  @override
  State<CreateOrUpdateAlarm> createState() => _CreateOrUpdateAlarmState();
}

class _CreateOrUpdateAlarmState extends State<CreateOrUpdateAlarm> {
  bool ringOnce = true;
  bool shouldVibrate = true;
  Duration alarmTime = const Duration(minutes: 420);
  String alarmTitle = '';
  String alarmRingtone = kDefaultRingtone;
  Duration snoozeDuration = const Duration(minutes: 5);
  int snoozeTimes = 3;
  bool enableSnooze = true;
  List<String> dayList = [];

  @override
  void initState() {
    setState(() {
      ringOnce = widget.alarm?.ringOnce ?? true;
      shouldVibrate = widget.alarm?.vibrate ?? true;
      alarmTime = Duration(minutes: widget.alarm?.durationMinutes ?? 420);
      alarmTitle = widget.alarm?.title ?? '';
      alarmRingtone = widget.alarm?.ringtone ?? alarmRingtone;
      snoozeDuration =
          Duration(minutes: widget.alarm?.snoozeDurationMinutes ?? 420);
      snoozeTimes = widget.alarm?.snoozeTime ?? 3;
      enableSnooze = widget.alarm?.enableSnooze ?? true;
      dayList = widget.alarm?.days ?? [];
    });
    super.initState();
  }

  void addOrRemoveDays(String value) {
    if (dayList.contains(value)) {
      dayList.remove(value);
    } else {
      dayList.add(value);
    }
    setState(() {});
  }

  // Future<void> addOrUpdateAnAlarm() async {
  //   Loader.show(context);
  //   final isar = await IsarService().openDB();
  //   final alarm = Alarm(
  //     id: widget.alarm == null ? isar.alarms.autoIncrement() : widget.alarm!.id,
  //     alarmEnabled: true,
  //     title: alarmTitle.isEmpty ? 'Alarm' : alarmTitle,
  //     durationMinutes: alarmTime.inMinutes,
  //     ringOnce: ringOnce,
  //     days: dayList,
  //     ringtone: alarmRingtone,
  //     vibrate: shouldVibrate,
  //     enableSnooze: enableSnooze,
  //     snoozeDurationMinutes: snoozeDuration.inMinutes,
  //     snoozeTime: snoozeTimes,
  //   );
  //   await IsarService().createAlarm(alarm);
  //   await widget.refetch();
  //   if (alarm.days == null || (alarm.days != null && alarm.days!.isEmpty)) {
  //     DateTime now = DateTime.now();
  //     var selectedDateTime = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //     ).add(
  //       Duration(
  //         minutes: alarm.durationMinutes,
  //       ),
  //     );
  //     if (selectedDateTime.isBefore(now)) {
  //       selectedDateTime = selectedDateTime.add(const Duration(days: 1));
  //     }
  //     final alarmSettings = alarm_lib.AlarmSettings(
  //       id: alarm.id,
  //       dateTime: selectedDateTime,
  //       assetAudioPath: 'assets/ringtones/${alarm.ringtone}',
  //       loopAudio: true,
  //       vibrate: alarm.vibrate,
  //       volume: 0.8,
  //       fadeDuration: 3.0,
  //       warningNotificationOnKill: Platform.isIOS,
  //       notificationSettings: alarm_lib.NotificationSettings(
  //         title: alarm.title,
  //         body: '${alarm.title} is Now active.',
  //         stopButton: 'Stop Alarm',
  //       ),
  //     );
  //     await alarm_lib.Alarm.set(alarmSettings: alarmSettings);
  //   } else {
  //     for (String day in alarm.days!) {
  //       int daysOffset = _getDaysOffset(day);
  //       if (daysOffset == -1) continue;
  //       DateTime now = DateTime.now();
  //       DateTime selectedDateTime = DateTime(
  //         now.year,
  //         now.month,
  //         now.day,
  //       ).add(
  //         Duration(
  //           minutes: alarm.durationMinutes,
  //           days: daysOffset,
  //         ),
  //       );

  //       if (selectedDateTime.isBefore(now)) {
  //         selectedDateTime = selectedDateTime.add(
  //           const Duration(days: 7),
  //         );
  //       }

  //       final alarmSettings = alarm_lib.AlarmSettings(
  //         id: alarm.id,
  //         dateTime: selectedDateTime,
  //         assetAudioPath: 'assets/ringtones/${alarm.ringtone}',
  //         loopAudio: true,
  //         vibrate: alarm.vibrate,
  //         volume: 0.8,
  //         fadeDuration: 3.0,
  //         warningNotificationOnKill: Platform.isIOS,
  //         notificationSettings: alarm_lib.NotificationSettings(
  //           title: alarm.title,
  //           body: '${alarm.title} is Now active.',
  //           stopButton: 'Stop Alarm',
  //         ),
  //       );

  //       await alarm_lib.Alarm.set(alarmSettings: alarmSettings);
  //     }
  //   }
  //   Future.delayed(Duration.zero, () {
  //     Loader.hide();
  //   });
  //   if (!mounted) return;
  //   if (Navigator.canPop(context)) {
  //     Navigator.pop(context);
  //   }
  // }

  Future<void> addOrUpdateAnAlarm() async {
    Loader.show(context);
    final isar = await IsarService().openDB();
    final alarm = AlarmEntity(
      id: widget.alarm == null
          ? isar.alarmEntitys.autoIncrement()
          : widget.alarm!.id,
      alarmEnabled: true,
      title: alarmTitle.isEmpty ? 'Alarm' : alarmTitle,
      durationMinutes: alarmTime.inMinutes,
      ringOnce: ringOnce,
      days: dayList, // List of selected days
      ringtone: alarmRingtone,
      vibrate: shouldVibrate,
      enableSnooze: enableSnooze,
      snoozeDurationMinutes: snoozeDuration.inMinutes,
      snoozeTime: snoozeTimes,
    );

    await IsarService().createAlarm(alarm);
    await widget.refetch();

    // Check if it's a one-time alarm
    if (alarm.days == null || alarm.days!.isEmpty) {
      DateTime now = DateTime.now();
      var selectedDateTime = DateTime(
        now.year,
        now.month,
        now.day,
      ).add(
        Duration(
          minutes: alarm.durationMinutes,
        ),
      );
      if (selectedDateTime.isBefore(now)) {
        selectedDateTime = selectedDateTime.add(const Duration(days: 1));
      }

      // Set one-time alarm
      final alarmSettings = alarm_lib.AlarmSettings(
        id: alarm.id,
        dateTime: selectedDateTime,
        assetAudioPath: 'assets/ringtones/${alarm.ringtone}',
        loopAudio: true,
        vibrate: alarm.vibrate,
        // volume: 0.8,
        // fadeDuration: 3.0,
        volumeSettings: VolumeSettings.fade(
            fadeDuration: Duration(seconds: 3), volume: 0.8),
        warningNotificationOnKill: Platform.isIOS,
        notificationSettings: alarm_lib.NotificationSettings(
          title: alarm.title,
          body: '${alarm.title} is Now active.',
          stopButton: 'Stop Alarm',
        ),
      );
      await alarm_lib.Alarm.set(alarmSettings: alarmSettings);
    }
    // Handle periodic (recurring) alarms
    else {
      final now = DateTime.now();
      const nbDays = 7; // Number of days in a week
      for (int i = 0; i < nbDays; i++) {
        DateTime potentialDateTime = DateTime(
          now.year,
          now.month,
          now.day,
        ).add(Duration(days: i)).add(alarmTime); // Add `alarmTime` to the day

        // Check if the day of the week matches any of the selected days
        if (alarm.days!.contains(potentialDateTime.weekday.toString())) {
          if (potentialDateTime.isBefore(now)) {
            // Skip past days, set for the next week
            potentialDateTime = potentialDateTime.add(const Duration(days: 7));
          }

          final alarmSettings = alarm_lib.AlarmSettings(
            id: alarm.id + potentialDateTime.weekday, // Unique ID for each day
            dateTime: potentialDateTime,
            assetAudioPath: 'assets/ringtones/${alarm.ringtone}',
            loopAudio: true,
            vibrate: alarm.vibrate,
            volumeSettings: VolumeSettings.fade(
                fadeDuration: Duration(seconds: 3), volume: 0.8),
            warningNotificationOnKill: Platform.isIOS,
            notificationSettings: alarm_lib.NotificationSettings(
              title: alarm.title,
              body:
                  '${alarm.title} is Now active for ${_getDayName(potentialDateTime.weekday)}.',
              stopButton: 'Stop Alarm',
            ),
          );
          await alarm_lib.Alarm.set(alarmSettings: alarmSettings);
        }
      }
    }

    // Hide loader and navigate back
    Future.delayed(Duration.zero, () {
      Loader.hide();
    });
    if (!mounted) return;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

// Helper function to get day names
  String _getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Unknown Day';
    }
  }

  // int _getDaysOffset(String day) {
  //   int today = DateTime.now().weekday;
  //   int targetDay;

  //   switch (day) {
  //     case 'SUN':
  //       targetDay = DateTime.sunday;
  //       break;
  //     case 'MON':
  //       targetDay = DateTime.monday;
  //       break;
  //     case 'TUE':
  //       targetDay = DateTime.tuesday;
  //       break;
  //     case 'WED':
  //       targetDay = DateTime.wednesday;
  //       break;
  //     case 'THU':
  //       targetDay = DateTime.thursday;
  //       break;
  //     case 'FRI':
  //       targetDay = DateTime.friday;
  //       break;
  //     case 'SAT':
  //       targetDay = DateTime.saturday;
  //       break;
  //     default:
  //       return -1;
  //   }

  //   if (targetDay >= today) {
  //     return targetDay - today;
  //   } else {
  //     return 7 - (today - targetDay);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 30),
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Ensure the widget is still mounted before using context
                          if (!mounted) return;

                          // Check if the navigator can pop
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.close_outlined),
                      ),
                      Text(
                        widget.alarm == null ? 'Add an Alarm' : 'Update Alarm',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: addOrUpdateAnAlarm,
                        icon: const Icon(Icons.check_outlined),
                      ),
                    ],
                  ),
                ),
                TimerPicker(
                  initialDuration: alarmTime,
                  addOrUpdateAlarm: (duration) => setState(
                    () => alarmTime = duration,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AlarmTypeButton(
                        ringOnce: ringOnce,
                        title: 'Ring Once',
                        onPressed: () => setState(
                          () => ringOnce = !ringOnce,
                        ),
                      ),
                      const SizedBox(width: 10),
                      AlarmTypeButton(
                        ringOnce: !ringOnce,
                        title: 'Custom',
                        onPressed: () => setState(
                          () => ringOnce = !ringOnce,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!ringOnce)
                  Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: kPrimaryColor),
                      color: kPrimaryColor.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: MediaQuery.sizeOf(context).height * 0.16,
                    width: MediaQuery.sizeOf(context).width,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Repeat',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            DayButton(
                              title: kSunDay,
                              onPressed: () => addOrRemoveDays(kSunDay),
                              isSelected: dayList.contains(kSunDay),
                            ),
                            DayButton(
                              title: kMonDay,
                              onPressed: () => addOrRemoveDays(kMonDay),
                              isSelected: dayList.contains(kMonDay),
                            ),
                            DayButton(
                              title: kTueDay,
                              onPressed: () => addOrRemoveDays(kTueDay),
                              isSelected: dayList.contains(kTueDay),
                            ),
                            DayButton(
                              title: kWedDay,
                              onPressed: () => addOrRemoveDays(kWedDay),
                              isSelected: dayList.contains(kWedDay),
                            ),
                            DayButton(
                              title: kThuDay,
                              onPressed: () => addOrRemoveDays(kThuDay),
                              isSelected: dayList.contains(kThuDay),
                            ),
                            DayButton(
                              title: kFriDay,
                              onPressed: () => addOrRemoveDays(kFriDay),
                              isSelected: dayList.contains(kFriDay),
                            ),
                            DayButton(
                              title: kSatDay,
                              onPressed: () => addOrRemoveDays(kSatDay),
                              isSelected: dayList.contains(kSatDay),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 10,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: alarmTitle,
                        onChanged: (value) => alarmTitle = value,
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        decoration: InputDecoration(
                          hintText: 'Alarm Name',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 20,
                          ),
                          // Remove border when the TextField is enabled but not focused
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kPrimaryColor.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // Remove border when the TextField is focused
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: kPrimaryColor.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // Border when there is an error
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.3), // Error color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          // Border when the TextField is focused and there is an error
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red.withOpacity(0.3), // Error color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          String? poppedRingtone = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return RingtoneList(
                                selectedRingtone: alarmRingtone,
                              );
                            },
                          );
                          debugPrint(
                              'Currently poppedRingtone: $poppedRingtone');
                          if (poppedRingtone != null) {
                            setState(
                              () => alarmRingtone = poppedRingtone,
                            );
                          }
                        },
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: kPrimaryColor.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Ringtone',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    alarmRingtone,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.06,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: kPrimaryColor.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Vibrate',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: Switch.adaptive(
                                value: shouldVibrate,
                                onChanged: (value) => setState(
                                  () => shouldVibrate = !shouldVibrate,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return AlarmSnooze(
                              snoozeDuration: snoozeDuration,
                              changeSnoozeDuration: (duration) {
                                if (duration == null) return;
                                setState(() => snoozeDuration = duration);
                              },
                              snoozeTimes: snoozeTimes,
                              changeSnoozeTime: (time) {
                                if (time == null) return;
                                setState(() => snoozeTimes = time);
                              },
                              enableSnooze: enableSnooze,
                              changeEnableSnooze: (snooze) =>
                                  setState(() => enableSnooze = snooze),
                            );
                          },
                        ),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.08,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: kPrimaryColor.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Snooze',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '5 Minutes, 3 Times',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
