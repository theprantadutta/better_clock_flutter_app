import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final void Function() onPressed;

  const FloatingAddButton({
    super.key,
    required this.title,
    required this.onPressed,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: (MediaQuery.sizeOf(context).width -
              MediaQuery.sizeOf(context).width * 0.4) /
          2,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.only(
            left: 5,
            right: 12,
          ),
          height: MediaQuery.sizeOf(context).height * 0.055,
          width: MediaQuery.sizeOf(context).width * 0.4,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                iconData,
                size: 30,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
