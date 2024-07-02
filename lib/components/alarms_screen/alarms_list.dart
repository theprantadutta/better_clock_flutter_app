import 'package:better_clock_flutter_app/services/isar_service.dart';
import 'package:flutter/material.dart';

import '../../components/common/cached_future_handler.dart';
import '../common/floating_add_button.dart';
import 'create_or_update_alarm.dart';
import 'single_alarm_row.dart';

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
