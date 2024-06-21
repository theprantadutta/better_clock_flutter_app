import 'package:flutter/material.dart';

class WorldClockScreen extends StatelessWidget {
  static const kRouteName = '/world-clock';
  const WorldClockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('World Clock Screen'),
    );
  }
}
