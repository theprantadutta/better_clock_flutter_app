import 'package:flutter/material.dart';

import '../components/alarms_screen/alarm_screen_title.dart';
import '../components/alarms_screen/alarms_list.dart';
import '../components/alarms_screen/create_or_update_alarm.dart';
import '../components/common/floating_add_button.dart';
import '../layouts/main_layout.dart';

class AlarmsScreen extends StatelessWidget {
  static const kRouteName = '/alarms';
  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  const AlarmScreenTitle(),
                  const AlarmsList(),
                ],
              ),
            ),
            FloatingAddButton(
              iconData: Icons.add_outlined,
              title: 'Add Alarm',
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return const CreateOrUpdateAlarm();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
