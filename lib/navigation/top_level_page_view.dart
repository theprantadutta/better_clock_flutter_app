import 'package:flutter/material.dart';

import 'top_level_pages.dart';

class TopLevelPageView extends StatelessWidget {
  final PageController pageController;
  final Function(int) onPageChanged;

  const TopLevelPageView({
    super.key,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        onPageChanged: onPageChanged,
        controller: pageController,
        children: kTopLevelPages,
      ),
    );
  }
}
