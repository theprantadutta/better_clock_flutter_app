import 'dart:async';

import 'package:better_clock_flutter_app/components/timer_screen/select_timer.dart';
import 'package:flutter/material.dart';

import '../components/timer_screen/timer_picker_widget.dart';
import '../layouts/main_layout.dart';

const double kTimerClockFontSize = 45;

class TimerScreen extends StatefulWidget {
  static const kRouteName = '/timer';
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int selectedHour = 0;
  int selectedMinute = 15;
  int selectedSecond = 0;

  bool isRunning = false;
  Duration remainingTime = const Duration();
  Timer? timer;

  List<int> hours = List.generate(24, (index) => index);
  List<int> minutesAndSeconds = List.generate(60, (index) => index);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: isRunning
          ? SelectTimer(
              countDownDuration: Duration(
                hours: selectedHour,
                minutes: selectedMinute,
                seconds: selectedSecond,
              ),
              cancelTimer: () {
                isRunning = false;
              },
            )
          : Column(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TimerPickerWidget(
                            items: hours,
                            selectedItem: selectedHour,
                            onChanged: (value) => setState(
                              () => selectedHour = value,
                            ),
                          ),
                          const Text(
                            ":",
                            style: TextStyle(fontSize: 30),
                          ),
                          TimerPickerWidget(
                            items: minutesAndSeconds,
                            selectedItem: selectedMinute,
                            onChanged: (value) => setState(
                              () => selectedMinute = value,
                            ),
                          ),
                          const Text(
                            ":",
                            style: TextStyle(fontSize: 30),
                          ),
                          TimerPickerWidget(
                            items: minutesAndSeconds,
                            selectedItem: selectedSecond,
                            onChanged: (value) => setState(
                              () => selectedSecond = value,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: isRunning ? null : startTimer,
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor,
                    radius: 40,
                    child: const Icon(
                      Icons.play_arrow_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                // ElevatedButton(
                //   onPressed: isRunning ? null : startTimer,
                //   child: Icon(Icons.play_arrow, size: 40),
                //   style: ElevatedButton.styleFrom(
                //     shape: CircleBorder(),
                //     padding: EdgeInsets.all(20),
                //     // primary: Colors.blue, // Button color
                //     // onPrimary: Colors.black, // Splash color
                //   ),
                // ),
                // if (isRunning)
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Text(
                //       '${remainingTime.inHours.toString().padLeft(2, '0')}:${(remainingTime.inMinutes % 60).toString().padLeft(2, '0')}:${(remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                //       style: TextStyle(fontSize: 40, color: Colors.white),
                //     ),
                //   ),
              ],
            ),
    );
  }

  void startTimer() {
    setState(() {
      isRunning = true;
      remainingTime = Duration(
        hours: selectedHour,
        minutes: selectedMinute,
        seconds: selectedSecond,
      );
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.inSeconds == 0) {
        timer.cancel();
        setState(() {
          isRunning = false;
        });
      } else {
        setState(() {
          remainingTime = remainingTime - const Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
