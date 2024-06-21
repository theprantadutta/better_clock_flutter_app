import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/common/floating_change_theme_button.dart';
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
    final bottomBarHeight = MediaQuery.sizeOf(context).height * 0.08;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: bottomBarHeight + 15),
          child: PageView(
            onPageChanged: onPageChanged,
            controller: pageController,
            children: kTopLevelPages,
          ),
        ),
        // Todo: Undo this if felt necessary
        // const BackgroundDecoration(),
        if (!kReleaseMode)
          const Positioned(
            right: 10,
            bottom: 10,
            child: FloatingChangeThemeButton(),
          ),
      ],
    );
  }
}
