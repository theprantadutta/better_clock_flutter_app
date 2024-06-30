import 'package:better_clock_flutter_app/services/isar_service.dart';
import 'package:flutter/material.dart';

import 'single_alarm_row.dart';

class AlarmsList extends StatelessWidget {
  const AlarmsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.74,
      child: StreamBuilder(
        stream: IsarService().getAllAlarm(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something Went Wrong'),
            );
          }
          final alarms = snapshot.data!;
          if (alarms.isEmpty) {
            return const Center(
              child: Text('No Alarms Were Created'),
            );
          }
          return ListView.builder(
            itemCount: alarms.length,
            itemBuilder: (context, index) {
              return SingleAlarmRow(
                alarm: alarms[index],
              );
            },
          );
        },
      ),
    );
  }
}
