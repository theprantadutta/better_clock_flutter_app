import 'package:flutter/material.dart';

import '../components/stopwatch_screen/analog_stopwatch.dart';

class StopwatchScreen extends StatelessWidget {
  static const kRouteName = '/stopwatch';
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnalogStopwatch(),
        ],
      ),
    );
  }
}
