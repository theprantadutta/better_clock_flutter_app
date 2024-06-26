import 'package:flutter/material.dart';

import '../../packages/advanced_salomon_bottom_bar/advanced_salomon_bottom_bar.dart';

class SimpleBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final void Function(int) updateCurrentPageIndex;

  const SimpleBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.updateCurrentPageIndex,
  });

  @override
  State<SimpleBottomNavigationBar> createState() =>
      _SimpleBottomNavigationBarState();
}

class _SimpleBottomNavigationBarState extends State<SimpleBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return AdvancedSalomonBottomBar(
      currentIndex: widget.selectedIndex,
      onTap: widget.updateCurrentPageIndex,
      items: [
        AdvancedSalomonBottomBarItem(
          icon: const Icon(Icons.alarm),
          title: const Text('Alarms'),
        ),
        AdvancedSalomonBottomBarItem(
          icon: const Icon(Icons.language),
          title: const Text('World Clock'),
        ),
        AdvancedSalomonBottomBarItem(
          icon: const Icon(Icons.query_builder),
          title: const Text('Stopwatch'),
        ),
        AdvancedSalomonBottomBarItem(
          icon: const Icon(Icons.hourglass_empty),
          title: const Text('Timer'),
        ),
      ],
    );
  }
}
