// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class SnoozeDurationModel {
//   final String snoozeTitle;
//   final Duration snoozeDuration;

//   SnoozeDurationModel({
//     required this.snoozeTitle,
//     required this.snoozeDuration,
//   });
// }

// final List<SnoozeDurationModel> snoozeDurations = [
//   SnoozeDurationModel(
//       snoozeTitle: '5 Minutes', snoozeDuration: Duration(minutes: 5)),
//   SnoozeDurationModel(
//       snoozeTitle: '10 Minutes', snoozeDuration: Duration(minutes: 10)),
//   SnoozeDurationModel(
//       snoozeTitle: '15 Minutes', snoozeDuration: Duration(minutes: 15)),
//   SnoozeDurationModel(
//       snoozeTitle: '20 Minutes', snoozeDuration: Duration(minutes: 20)),
//   SnoozeDurationModel(
//       snoozeTitle: '25 Minutes', snoozeDuration: Duration(minutes: 25)),
// ];

// final List<int> snoozeTimeList = [2, 3, 5, 10];

// class AlarmSnooze extends StatelessWidget {
//   final bool enableSnooze;
//   final void Function(bool snooze) changeEnableSnooze;
//   final Duration snoozeDuration;
//   final void Function(Duration? duration) changeSnoozeDuration;
//   final void Function(int? time) changeSnoozeTime;
//   final int snoozeTimes;

//   const AlarmSnooze({
//     super.key,
//     required this.snoozeDuration,
//     required this.snoozeTimes,
//     required this.changeSnoozeDuration,
//     required this.changeSnoozeTime,
//     required this.enableSnooze,
//     required this.changeEnableSnooze,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // final singleSnoozeDurationHeight = MediaQuery.sizeOf(context).height * 0.05;
//     final kPrimaryColor = Theme.of(context).primaryColor;
//     return Container(
//       height: MediaQuery.sizeOf(context).height * 0.9,
//       margin: const EdgeInsets.symmetric(
//         horizontal: 20,
//         vertical: 5,
//       ),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 2.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () => context.pop(),
//                     icon: const Icon(Icons.close_outlined),
//                   ),
//                   const Text(
//                     'Alarm Snooze',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => context.pop(),
//                     icon: const Icon(Icons.check_outlined),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 10),
//             Container(
//               height: MediaQuery.sizeOf(context).height * 0.07,
//               margin: const EdgeInsets.symmetric(vertical: 10),
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 // border: Border.all(
//                 //   color: kPrimaryColor,
//                 // ),
//                 color: kPrimaryColor.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Enable Snooze',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   Transform.scale(
//                     scale: 0.7,
//                     child: Switch.adaptive(
//                       value: enableSnooze,
//                       onChanged: changeEnableSnooze,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: MediaQuery.sizeOf(context).height * 0.06,
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: kPrimaryColor.withOpacity(0.2),
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Snooze Duration'),
//                   DropdownButton<Duration>(
//                     value: snoozeDuration,
//                     icon: const Icon(Icons.arrow_downward),
//                     elevation: 16,
//                     style: TextStyle(color: kPrimaryColor),
//                     underline: Container(
//                       height: 2,
//                       color: kPrimaryColor,
//                     ),
//                     onChanged: changeSnoozeDuration,
//                     items: snoozeDurations.map<DropdownMenuItem<Duration>>(
//                       (SnoozeDurationModel value) {
//                         return DropdownMenuItem<Duration>(
//                           value: value.snoozeDuration,
//                           child: Text(value.snoozeTitle),
//                         );
//                       },
//                     ).toList(),
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               height: MediaQuery.sizeOf(context).height * 0.06,
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               margin: const EdgeInsets.symmetric(vertical: 5),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                   color: kPrimaryColor.withOpacity(0.2),
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Snooze Times'),
//                   DropdownButton<int>(
//                     value: 3,
//                     icon: const Icon(Icons.arrow_downward),
//                     elevation: 16,
//                     style: TextStyle(color: kPrimaryColor),
//                     underline: Container(
//                       height: 2,
//                       color: kPrimaryColor,
//                     ),
//                     onChanged: changeSnoozeTime,
//                     items: snoozeTimeList.map<DropdownMenuItem<int>>(
//                       (int value) {
//                         return DropdownMenuItem<int>(
//                           value: value,
//                           child: Text(value.toString()),
//                         );
//                       },
//                     ).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SnoozeDurationModel {
  final String snoozeTitle;
  final Duration snoozeDuration;

  SnoozeDurationModel({
    required this.snoozeTitle,
    required this.snoozeDuration,
  });
}

final List<SnoozeDurationModel> snoozeDurations = [
  SnoozeDurationModel(
      snoozeTitle: '5 Minutes', snoozeDuration: const Duration(minutes: 5)),
  SnoozeDurationModel(
      snoozeTitle: '10 Minutes', snoozeDuration: const Duration(minutes: 10)),
  SnoozeDurationModel(
      snoozeTitle: '15 Minutes', snoozeDuration: const Duration(minutes: 15)),
  SnoozeDurationModel(
      snoozeTitle: '20 Minutes', snoozeDuration: const Duration(minutes: 20)),
  SnoozeDurationModel(
      snoozeTitle: '25 Minutes', snoozeDuration: const Duration(minutes: 25)),
];

final List<int> snoozeTimeList = [2, 3, 5, 10];

class AlarmSnooze extends StatefulWidget {
  final bool enableSnooze;
  final void Function(bool snooze) changeEnableSnooze;
  final Duration snoozeDuration;
  final void Function(Duration? duration) changeSnoozeDuration;
  final void Function(int? time) changeSnoozeTime;
  final int snoozeTimes;

  const AlarmSnooze({
    super.key,
    required this.snoozeDuration,
    required this.snoozeTimes,
    required this.changeSnoozeDuration,
    required this.changeSnoozeTime,
    required this.enableSnooze,
    required this.changeEnableSnooze,
  });

  @override
  _AlarmSnoozeState createState() => _AlarmSnoozeState();
}

class _AlarmSnoozeState extends State<AlarmSnooze> {
  late bool enableSnooze;
  late Duration snoozeDuration;
  late int snoozeTimes;

  @override
  void initState() {
    super.initState();
    enableSnooze = widget.enableSnooze;
    snoozeDuration = widget.snoozeDuration;
    snoozeTimes = widget.snoozeTimes;
  }

  void handleEnableSnoozeChange(bool value) {
    setState(() {
      enableSnooze = value;
    });
    widget.changeEnableSnooze(value);
  }

  void handleSnoozeDurationChange(Duration? value) {
    setState(() {
      snoozeDuration = value!;
    });
    widget.changeSnoozeDuration(value);
  }

  void handleSnoozeTimesChange(int? value) {
    setState(() {
      snoozeTimes = value!;
    });
    widget.changeSnoozeTime(value);
  }

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.9,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      child: SingleChildScrollView(
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
                    'Alarm Snooze',
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
            const SizedBox(height: 10),
            Container(
              height: MediaQuery.sizeOf(context).height * 0.07,
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enable Snooze',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch.adaptive(
                      value: enableSnooze,
                      onChanged: handleEnableSnoozeChange,
                    ),
                  ),
                ],
              ),
            ),
            IgnorePointer(
              ignoring: !enableSnooze,
              child: Opacity(
                opacity: enableSnooze ? 1 : 0.4,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.06,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Snooze Duration'),
                          DropdownButton<Duration>(
                            value: snoozeDuration,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: TextStyle(color: kPrimaryColor),
                            underline: Container(
                              height: 2,
                              color: kPrimaryColor,
                            ),
                            onChanged: handleSnoozeDurationChange,
                            items:
                                snoozeDurations.map<DropdownMenuItem<Duration>>(
                              (SnoozeDurationModel value) {
                                return DropdownMenuItem<Duration>(
                                  value: value.snoozeDuration,
                                  child: Text(value.snoozeTitle),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.sizeOf(context).height * 0.06,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kPrimaryColor.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Snooze Times'),
                          DropdownButton<int>(
                            value: snoozeTimes,
                            icon: const Icon(Icons.arrow_downward),
                            elevation: 16,
                            style: TextStyle(color: kPrimaryColor),
                            underline: Container(
                              height: 2,
                              color: kPrimaryColor,
                            ),
                            onChanged: handleSnoozeTimesChange,
                            items: snoozeTimeList.map<DropdownMenuItem<int>>(
                              (int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(value.toString()),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
