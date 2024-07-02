import 'package:flutter/material.dart';

import '../components/alarms_screen/alarm_screen_title.dart';
import '../components/alarms_screen/alarms_list.dart';
import '../layouts/main_layout.dart';

class AlarmsScreen extends StatelessWidget {
  static const kRouteName = '/alarms';
  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const AlarmScreenTitle(),
              const AlarmsList(),
            ],
          ),
        ),
      ),
    );
  }
}
