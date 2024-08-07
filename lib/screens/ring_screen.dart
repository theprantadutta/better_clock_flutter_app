// ignore_for_file: use_build_context_synchronously
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/isar_service.dart';

class RingScreen extends StatelessWidget {
  static const kRouteName = '/ring';
  const RingScreen({super.key, required this.alarmSettings});

  final AlarmSettings alarmSettings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '${alarmSettings.notificationTitle}...',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${alarmSettings.notificationBody}...',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () async {
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
                  },
                  child: Text(
                    'Snooze',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async {
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
                  },
                  child: Text(
                    'Stop',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
