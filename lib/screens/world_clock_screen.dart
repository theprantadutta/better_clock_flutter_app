import 'package:better_clock_flutter_app/components/world_clock_screen/clock_lists.dart';
import 'package:flutter/material.dart';

import '../components/world_clock_screen/analog_clock_widget.dart';

class WorldClockScreen extends StatelessWidget {
  static const kRouteName = '/world-clock';
  const WorldClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
          const AnalogClockWidget(),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
          Text(
            'Bangladesh Standard Time | Thu, Jun 22',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.color
                  ?.withOpacity(0.5),
            ),
          ),
          SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
          const ClockLists(),
        ],
      ),
    );
  }
}
