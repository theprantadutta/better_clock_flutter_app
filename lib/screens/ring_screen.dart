import 'package:alarm/alarm.dart';
import 'package:better_clock_flutter_app/entities/alarm_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:alarm/alarm.dart' as alarm_lib;

import '../components/common/animated_text.dart';
import '../components/ring_screen/alarm_animation.dart';
import '../services/isar_service.dart';
import '../util/functions.dart';

class RingScreen extends StatelessWidget {
  static const kRouteName = '/ring';
  const RingScreen({super.key, required this.alarmSettings});

  final AlarmSettings alarmSettings;

  Future<void> stopAlarm() async {
    final alarmId = alarmSettings.id;

    // 1. Stop the current alarm instance
    await alarm_lib.Alarm.stop(alarmId);

    // 2. Get the alarm from the Isar database by ID
    final theAlarm = await IsarService().getAlarmById(alarmId);

    // 3. Check if the alarm exists in the database
    if (theAlarm != null) {
      // If it's a recurring alarm, reschedule it for the next occurrence
      if (theAlarm.days != null && theAlarm.days!.isNotEmpty) {
        // 4. Find the next occurrence day and schedule the alarm
        DateTime nextAlarmTime = _getNextRecurringAlarmDate(theAlarm);

        final alarmSettings = alarm_lib.AlarmSettings(
          id: alarmId,
          dateTime: nextAlarmTime,
          assetAudioPath: 'assets/ringtones/${theAlarm.ringtone}',
          loopAudio: true,
          vibrate: theAlarm.vibrate,
          volume: 0.8,
          fadeDuration: 3.0,
          notificationSettings: alarm_lib.NotificationSettings(
            title: theAlarm.title,
            body: '${theAlarm.title} is Now active.',
            stopButton: 'Stop Alarm',
          ),
        );

        await alarm_lib.Alarm.set(alarmSettings: alarmSettings);
      } else {
        // 5. If it's a one-time alarm, disable it
        await IsarService().updateAnAlarmEnabled(
          theAlarm,
          false,
        );
      }
    }

    // 6. Close the app if required
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

// Helper function to get the next alarm date for a recurring alarm
  DateTime _getNextRecurringAlarmDate(AlarmEntity theAlarm) {
    DateTime now = DateTime.now();
    List<String> days =
        theAlarm.days!; // Days of the week (e.g., 'Monday', 'Tuesday')

    // Find the next day in the future for this alarm
    for (String day in days) {
      int daysOffset = getDayOffset(day);
      DateTime potentialDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      ).add(Duration(days: (daysOffset - now.weekday + 7) % 7));

      // Ensure the new alarm is set in the future
      if (potentialDateTime.isAfter(now)) {
        return potentialDateTime;
      }
    }

    // If no future day is found, set it for the same day next week
    return now.add(const Duration(days: 7));
  }

  Future<void> snoozeAlarm() async {
    final now = DateTime.now();
    final theAlarm = await IsarService().getAlarmById(
      alarmSettings.id,
    );
    await Alarm.set(
      alarmSettings: alarmSettings.copyWith(
        dateTime: DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
        ).add(
          Duration(minutes: theAlarm?.snoozeTime ?? 1),
        ),
      ),
    );
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    final kSecondaryColor = Theme.of(context).colorScheme.secondary;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AnimatedText(
                  text: alarmSettings.notificationSettings.title,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 40,
                    color: Color(0xFF666870),
                    height: 1,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
            AlarmAnimation(),
            Column(
              children: [
                RingScreenSwipeButton(
                  color: kSecondaryColor,
                  title: "Swipe to Snooze...",
                  onPressed: () => snoozeAlarm(),
                ),
                const SizedBox(height: 10),
                RingScreenSwipeButton(
                  color: kPrimaryColor,
                  title: "Swipe to Stop...",
                  onPressed: () => stopAlarm(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RingScreenSwipeButton extends StatelessWidget {
  final Color color;
  final String title;
  final VoidCallback onPressed;

  const RingScreenSwipeButton({
    super.key,
    required this.color,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.9,
      child: SwipeButton.expand(
        thumb: const Icon(
          Icons.double_arrow_rounded,
          color: Colors.white,
        ),
        activeThumbColor: color,
        activeTrackColor: color.withOpacity(0.2),
        onSwipe: onPressed,
        child: AnimatedText(
          text: title,
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF666870),
            height: 1,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }
}
