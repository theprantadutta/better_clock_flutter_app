import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:pulsator/pulsator.dart';

import '../components/common/animated_text.dart';
import '../services/isar_service.dart';

class RingScreen extends StatelessWidget {
  static const kRouteName = '/ring';
  const RingScreen({super.key, required this.alarmSettings});

  final AlarmSettings alarmSettings;

  Future<void> stopAlarm() async {
    final alarmId = alarmSettings.id;
    await Alarm.stop(alarmId);
    final theAlarm = await IsarService().getAlarmById(alarmId);
    if (theAlarm != null) {
      await IsarService().updateAnAlarmEnabled(
        theAlarm,
        false,
      );
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
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
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.4,
              child: const Pulsator(
                style: PulseStyle(color: Colors.blue),
                count: 5,
                duration: Duration(seconds: 4),
                repeat: 0,
                startFromScratch: false,
                autoStart: true,
                fit: PulseFit.contain,
                child: Text('🔔', style: TextStyle(fontSize: 50)),
              ),
            ),
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
