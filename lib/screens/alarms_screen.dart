import 'package:flutter/material.dart';

import '../components/alarms_screen/alarms_list.dart';
import '../components/common/floating_add_button.dart';

class AlarmsScreen extends StatelessWidget {
  static const kRouteName = '/alarms';
  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.sizeOf(context).width,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Alarms',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Next Alarm in 22 Hours 2 minutes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                const AlarmsList(),
              ],
            ),
          ),
          FloatingAddButton(
            iconData: Icons.add_outlined,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
