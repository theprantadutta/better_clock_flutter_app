import 'package:flutter/material.dart';

import 'single_alarm_row.dart';

class AlarmsList extends StatelessWidget {
  const AlarmsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.74,
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return const SingleAlarmRow();
        },
      ),
    );
  }
}
