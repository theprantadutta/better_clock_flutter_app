import 'package:flutter/material.dart';

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
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Alarms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: 'World Clock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.query_builder),
            label: 'Stopwatch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hourglass_empty),
            label: 'Timer',
          ),
        ],
        currentIndex: widget.selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
        type: BottomNavigationBarType.fixed,
        onTap: widget.updateCurrentPageIndex,
      ),
    );
  }
}
