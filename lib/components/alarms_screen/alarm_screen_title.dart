import 'package:flutter/material.dart';

class AlarmScreenTitle extends StatelessWidget {
  const AlarmScreenTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Alarms',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            'Next Alarm in 22 Hours 2 minutes',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
