import 'package:flutter/material.dart';

import '../../components/common/cached_future_handler.dart';
import '../../entities/alarm.dart';
import '../../services/isar_service.dart';
import '../common/floating_add_button.dart';
import 'create_or_update_alarm.dart';
import 'single_alarm_row.dart';

List<Alarm> initialAlarms = [
  Alarm(
      id: 1,
      alarmEnabled: false,
      title: 'Morning',
      ringOnce: true,
      durationMinutes: 420,
      days: [],
      ringtone: 'default',
      vibrate: true,
      enableSnooze: true,
      snoozeDurationMinutes: 5,
      snoozeTime: 2),
  Alarm(
      id: 2,
      alarmEnabled: false,
      title: 'Morning 2',
      ringOnce: true,
      durationMinutes: 420,
      days: [],
      ringtone: 'default',
      vibrate: true,
      enableSnooze: true,
      snoozeDurationMinutes: 5,
      snoozeTime: 2),
  Alarm(
      id: 3,
      alarmEnabled: false,
      title: 'Reading',
      ringOnce: true,
      durationMinutes: 420,
      days: [],
      ringtone: 'default',
      vibrate: true,
      enableSnooze: true,
      snoozeDurationMinutes: 5,
      snoozeTime: 2)
];

class AlarmsList extends StatefulWidget {
  const AlarmsList({super.key});

  @override
  State<AlarmsList> createState() => _AlarmsListState();
}

class _AlarmsListState extends State<AlarmsList> {
  @override
  Widget build(BuildContext context) {
    final defaultHeight = MediaQuery.sizeOf(context).height * 0.74;
    return CachedFutureHandler(
      defaultHeight: defaultHeight,
      id: 'all-alarms',
      future: IsarService().getAllAlarm,
      builder: (context, alarms, refetch) {
        if (alarms.isEmpty) {
          return const Center(
            child: Text('No Alarms Were Created'),
          );
        }
        return SizedBox(
          height: defaultHeight,
          child: Stack(
            children: [
              ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  return SingleAlarmRow(
                    alarm: alarms[index],
                    refetch: refetch,
                    index: index,
                  );
                },
              ),
              FloatingAddButton(
                iconData: Icons.add_outlined,
                title: 'Add Alarm',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return CreateOrUpdateAlarm(
                        refetch: refetch,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
