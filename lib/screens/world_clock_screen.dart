import 'package:flutter/material.dart';

import '../layouts/main_layout.dart';

class WorldClockScreen extends StatelessWidget {
  const WorldClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Center(
        child: Text('World Clock Screen'),
      ),
    );
  }
}
