import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

class AnalogClockWidget extends StatelessWidget {
  const AnalogClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.3,
      width: MediaQuery.sizeOf(context).width * 0.7,
      child: isDarkTheme
          ? const DarkAnalogClockWidget()
          : const LightAnalogClockWidget(),
    );
  }
}

class LightAnalogClockWidget extends StatelessWidget {
  const LightAnalogClockWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnalogClock(
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      showAllNumbers: true,
      showDigitalClock: false,
      key: const GlobalObjectKey(1),
    );
  }
}

class DarkAnalogClockWidget extends StatelessWidget {
  const DarkAnalogClockWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const AnalogClock.dark(
      key: GlobalObjectKey(2),
      showAllNumbers: true,
      showDigitalClock: false,
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}
