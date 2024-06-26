import 'package:flutter/material.dart';

import '../../screens/timer_screen.dart';
import 'gradient_text.dart';

class TimerPickerWidget extends StatelessWidget {
  final List<int> items;
  final int selectedItem;
  final ValueChanged<int> onChanged;

  const TimerPickerWidget({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.25,
      width: MediaQuery.sizeOf(context).width * 0.2,
      child: ListWheelScrollView.useDelegate(
        controller: FixedExtentScrollController(
          initialItem: selectedItem + items.length,
        ),
        itemExtent: MediaQuery.sizeOf(context).height * 0.095,
        onSelectedItemChanged: (index) {
          onChanged(index % items.length);
        },
        physics: const FixedExtentScrollPhysics(),
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            int displayIndex = index % items.length;
            bool isSelected = displayIndex == selectedItem;
            return Center(
              child: isSelected
                  ? Text(
                      items[displayIndex].toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: kTimerClockFontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : GradientText(
                      text: items[displayIndex].toString().padLeft(2, '0'),
                      style: const TextStyle(
                        fontSize: kTimerClockFontSize,
                        fontWeight: FontWeight.w300,
                      ),
                      gradient: const LinearGradient(
                        colors: [Colors.grey, Colors.blueGrey],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
            );
          },
          childCount: items.length * 3,
        ),
      ),
    );
  }
}
