import 'package:flutter/material.dart';
import 'dart:math';

import 'package:pulsator/pulsator.dart';

class AlarmAnimation extends StatefulWidget {
  const AlarmAnimation({super.key});

  @override
  State<AlarmAnimation> createState() => _AlarmAnimationState();
}

class _AlarmAnimationState extends State<AlarmAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Create the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..repeat(reverse: true); // Repeat the animation back and forth
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.4,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Use Transform to apply rotation for the alarm effect
          return Transform.rotate(
            angle: sin(_controller.value * 2 * pi) * 0.1, // Small angle to simulate alarm swing
            child: child, // The Pulsator child widget
          );
        },
        child: const Pulsator(
          style: PulseStyle(color: Colors.blue),
          count: 5,
          duration: Duration(seconds: 4),
          repeat: 0,
          startFromScratch: false,
          autoStart: true,
          fit: PulseFit.contain,
          child: Text('🔔', style: TextStyle(fontSize: 50)),
        ),
      ),
    );
  }
}
