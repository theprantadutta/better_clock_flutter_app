import 'package:flutter/material.dart';

import '../layouts/main_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
