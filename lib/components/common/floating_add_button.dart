import 'package:flutter/material.dart';

class FloatingAddButton extends StatelessWidget {
  final IconData iconData;
  final void Function() onPressed;

  const FloatingAddButton({
    super.key,
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height -
            kBottomNavigationBarHeight -
            MediaQuery.sizeOf(context).height * 0.08,
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: onPressed,
            // shape: const CircleBorder(),
            child: Icon(
              iconData,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
