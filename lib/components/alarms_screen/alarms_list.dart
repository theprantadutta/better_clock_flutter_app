import 'package:flutter/material.dart';

import '../../components/common/cached_future_handler.dart';
import '../../constants/selectors.dart';
import '../../entities/alarm_entity.dart';
import '../../services/isar_service.dart';
import '../common/floating_add_button.dart';
import 'create_or_update_alarm.dart';
import 'single_alarm_row.dart';

List<AlarmEntity> initialAlarms = [
  AlarmEntity(
    id: 1,
    alarmEnabled: false,
    title: 'Morning',
    ringOnce: true,
    durationMinutes: 420,
    days: [],
    ringtone: kDefaultRingtone,
    vibrate: true,
    enableSnooze: true,
    snoozeDurationMinutes: 5,
    snoozeTime: 2,
  ),
  AlarmEntity(
    id: 2,
    alarmEnabled: false,
    title: 'Morning 2',
    ringOnce: true,
    durationMinutes: 420,
    days: [],
    ringtone: kDefaultRingtone,
    vibrate: true,
    enableSnooze: true,
    snoozeDurationMinutes: 5,
    snoozeTime: 2,
  ),
  AlarmEntity(
    id: 3,
    alarmEnabled: false,
    title: 'Reading',
    ringOnce: true,
    durationMinutes: 420,
    days: [],
    ringtone: kDefaultRingtone,
    vibrate: true,
    enableSnooze: true,
    snoozeDurationMinutes: 5,
    snoozeTime: 2,
  )
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
    final kPrimaryColor = Theme.of(context).primaryColor;
    return CachedFutureHandler(
      defaultHeight: defaultHeight,
      id: 'all-alarms',
      future: IsarService().getAllAlarm,
      builder: (context, alarms, refetch) {
        addAlarm() => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => CreateOrUpdateAlarm(
                refetch: refetch,
              ),
            );
        if (alarms.isEmpty) {
          return SizedBox(
            height: defaultHeight,
            width: MediaQuery.sizeOf(context).width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.hourglass_empty,
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(
                  'No Alarms Were Created',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      width: 1.0,
                      color: kPrimaryColor,
                    ),
                  ),
                  onPressed: addAlarm,
                  child: Text('Add Alarm'),
                ),
              ],
            ),
          );
        }
        return SizedBox(
          height: defaultHeight,
          child: Stack(
            children: [
              ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) => SingleAlarmRow(
                  alarm: alarms[index],
                  refetch: refetch,
                  index: index,
                ),
              ),
              FloatingAddButton(
                iconData: Icons.add_outlined,
                title: 'Add Alarm',
                onPressed: addAlarm,
              ),
            ],
          ),
        );
      },
    );
  }
}
