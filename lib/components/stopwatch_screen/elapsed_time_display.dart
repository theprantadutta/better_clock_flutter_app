import 'package:flutter/material.dart';

class ElapsedTimeDisplay extends StatelessWidget {
  final Duration elapsed;

  const ElapsedTimeDisplay(this.elapsed, {super.key});

  // String _formatDuration(Duration duration) {
  //   String twoDigits(int n) => n.toString().padLeft(2, '0');
  //   final hours = duration.inHours;
  //   final minutes = duration.inMinutes.remainder(60);
  //   final seconds = duration.inSeconds.remainder(60);
  //   final milliseconds = duration.inMilliseconds.remainder(1000) ~/
  //       10; // Using integer division for milliseconds

  //   if (hours > 0) {
  //     return "$hours:${twoDigits(minutes)}:${twoDigits(seconds)}:${twoDigits(milliseconds)}";
  //   } else if (minutes > 0) {
  //     return "${twoDigits(minutes)}:${twoDigits(seconds)}:${twoDigits(milliseconds)}";
  //   } else if (seconds > 0) {
  //     return "${twoDigits(seconds)}:${twoDigits(milliseconds)}";
  //   } else {
  //     return "${twoDigits(milliseconds)}";
  //   }
  // }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds = (duration.inMilliseconds.remainder(1000) / 10)
        .floor()
        .toString()
        .padLeft(2, '0');
    return "$hours:$minutes:$seconds:$milliseconds";
  }

  String _formatHumanReadable(Duration duration) {
    final seconds = duration.inSeconds;

    if (seconds >= 60) {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      if (remainingSeconds > 0) {
        return "${minutes}m ${remainingSeconds}s";
      } else {
        return "${minutes}m";
      }
    } else {
      return "${seconds}s";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          _formatDuration(elapsed),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          _formatHumanReadable(elapsed),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
