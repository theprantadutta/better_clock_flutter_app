import 'package:flutter/material.dart';

class DayButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final bool isSelected;

  const DayButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.04,
        width: MediaQuery.sizeOf(context).width * 0.19,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? kPrimaryColor.withOpacity(0.8)
              : Theme.of(context).scaffoldBackgroundColor,
          border: isSelected
              ? Border.all(width: 0)
              : Border.all(
                  color: kPrimaryColor.withOpacity(0.3),
                ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
      ),
    );
  }
}
