import 'package:flutter/material.dart';

class AlarmTypeButton extends StatelessWidget {
  const AlarmTypeButton({
    super.key,
    required this.ringOnce,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final bool ringOnce;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            ringOnce
                ? Theme.of(context).primaryColor
                : Theme.of(context).scaffoldBackgroundColor,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              side: ringOnce
                  ? BorderSide.none
                  : BorderSide(
                      color: kPrimaryColor,
                      width: 1.5,
                    ),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: ringOnce ? Colors.white : kPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
