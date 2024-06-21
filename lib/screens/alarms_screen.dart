import 'package:flutter/material.dart';

import '../components/alarms_screen/alarms_list.dart';

class AlarmsScreen extends StatelessWidget {
  static const kRouteName = '/alarms';
  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                SizedBox(
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
                ),
                const AlarmsList(),
              ],
            ),
          ),
          Positioned(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height -
                  kBottomNavigationBarHeight -
                  MediaQuery.sizeOf(context).height * 0.08,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  // shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add_outlined,
                    size: 40,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
