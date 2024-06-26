import 'dart:async';

import 'package:flutter/material.dart';

class SelectTimer extends StatefulWidget {
  final Duration countDownDuration;
  final void Function() cancelTimer;

  const SelectTimer(
      {super.key, required this.countDownDuration, required this.cancelTimer});

  @override
  State<SelectTimer> createState() => _SelectTimerState();
}

class _SelectTimerState extends State<SelectTimer> {
  Duration countdownDuration = const Duration(minutes: 10);
  Duration countdownDuration1 = const Duration(minutes: 10);
  Duration duration = const Duration();
  Duration duration1 = const Duration();
  Timer? timer;
  Timer? timer1;
  bool countDown = true;
  bool countDown1 = true;

  @override
  void initState() {
    int hours;
    int mints;
    int secs;
    hours = int.parse("00");
    mints = int.parse("00");
    secs = int.parse("00");
    countdownDuration = Duration(hours: hours, minutes: mints, seconds: secs);
    // countdownDuration = widget.countDownDuration;
    startTimer();
    reset();
    // var hours1;
    // var mints1;
    // var secs1;
    // hours1 = int.parse("10");
    // mints1 = int.parse("00");
    // secs1 = int.parse("00");
    // countdownDuration1 =
    //     Duration(hours: hours1, minutes: mints1, seconds: secs1);
    countdownDuration1 = widget.countDownDuration;
    startTimer1();
    reset1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // color: Colors.black12,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Timer",
            style: TextStyle(fontSize: 25),
          ),
          Container(
              margin: const EdgeInsets.only(top: 30, bottom: 30), child: buildTime()),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Count down timer",
            style: TextStyle(fontSize: 25),
          ),
          Container(
              margin: const EdgeInsets.only(top: 30, bottom: 30),
              child: buildTime1()),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: _cancelTheTimer,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor,
              radius: 40,
              child: const Icon(
                Icons.stop_outlined,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _cancelTheTimer() async {
    final isRunning = timer == null ? false : timer!.isActive;
    if (isRunning) {
      timer!.cancel();
    }
    // Navigator.of(context, rootNavigator: true).pop(context);
    // return true;
    reset();
    reset1();
    widget.cancelTimer();
  }

  void reset() {
    if (countDown) {
      if (mounted) setState(() => duration = countdownDuration);
    } else {
      if (mounted) setState(() => duration = const Duration());
    }
  }

  void reset1() {
    if (countDown) {
      if (mounted) setState(() => duration1 = countdownDuration1);
    } else {
      if (mounted) setState(() => duration1 = const Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void startTimer1() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime1());
  }

  void addTime() {
    const addSeconds = 1;
    if (mounted) {
      setState(() {
        final seconds = duration.inSeconds + addSeconds;
        if (seconds < 0) {
          timer?.cancel();
        } else {
          duration = Duration(seconds: seconds);
        }
      });
    }
  }

  void addTime1() {
    const addSeconds = 1;
    if (mounted) {
      setState(() {
        final seconds = duration1.inSeconds - addSeconds;
        if (seconds < 0) {
          timer1?.cancel();
        } else {
          duration1 = Duration(seconds: seconds);
        }
      });
    }
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'HOURS'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: minutes, header: 'MINUTES'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: seconds, header: 'SECONDS'),
    ]);
  }

  Widget buildTime1() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration1.inHours);
    final minutes = twoDigits(duration1.inMinutes.remainder(60));
    final seconds = twoDigits(duration1.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'HOURS'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: minutes, header: 'MINUTES'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: seconds, header: 'SECONDS'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20)),
            child: Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(header, style: const TextStyle()),
        ],
      );
}
