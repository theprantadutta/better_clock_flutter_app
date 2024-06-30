import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RingtoneList extends StatefulWidget {
  const RingtoneList({super.key});

  @override
  State<RingtoneList> createState() => _RingtoneListState();
}

class _RingtoneListState extends State<RingtoneList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.92,
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.close_outlined),
                ),
                const Text(
                  'Ringtone Selection',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.check_outlined),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: 120,
                ),
                Text(
                  'Sorry, I couldn\'t implement ringtones',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'So, the ringtone is default',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Maybe, I will do it a future version',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'But, I am not sure if I will',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
