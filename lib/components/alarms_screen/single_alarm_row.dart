import 'package:flutter/material.dart';

class SingleAlarmRow extends StatefulWidget {
  const SingleAlarmRow({
    super.key,
  });

  @override
  State<SingleAlarmRow> createState() => _SingleAlarmRowState();
}

class _SingleAlarmRowState extends State<SingleAlarmRow> {
  bool alarmOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: MediaQuery.sizeOf(context).height * 0.14,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alarm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '7:20',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'AM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                'Ring Once',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch.adaptive(
              value: alarmOn,
              onChanged: (value) => setState(
                () => alarmOn = value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
