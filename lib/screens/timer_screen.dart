import 'package:flutter/material.dart';

import '../layouts/main_layout.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Center(
        child: Text('Timer Screen'),
      ),
    );
  }
}
