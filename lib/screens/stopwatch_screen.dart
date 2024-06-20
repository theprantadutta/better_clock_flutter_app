import 'package:better_clock_flutter_app/layouts/main_layout.dart';
import 'package:flutter/material.dart';

class StopwatchScreen extends StatelessWidget {
  const StopwatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Center(
        child: Text('Stop Watch Screen'),
      ),
    );
  }
}
