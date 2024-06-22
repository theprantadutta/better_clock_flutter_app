import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AnalogStopwatch extends StatefulWidget {
  const AnalogStopwatch({super.key});

  @override
  State<AnalogStopwatch> createState() => _AnalogStopwatchState();
}

class _AnalogStopwatchState extends State<AnalogStopwatch>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;
  bool _isRunning = false;
  late DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick);
  }

  void _onTick(Duration elapsed) {
    setState(() {
      if (_isRunning) {
        _elapsed = DateTime.now().difference(_startTime);
      }
    });
  }

  void _startStopwatch() {
    if (!_isRunning) {
      _startTime = DateTime.now().subtract(_elapsed);
      _ticker.start();
      _isRunning = true;
    }
  }

  void _stopStopwatch() {
    if (_isRunning) {
      _ticker.stop();
      _isRunning = false;
    }
  }

  void _resetStopwatch() {
    _ticker.stop();
    _isRunning = false;
    setState(() {
      _elapsed = Duration.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 200,
          height: 200,
          child: CustomPaint(
            painter: ClockPainter(
              _elapsed,
              isDarkTheme,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElapsedTimeDisplay(_elapsed),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _startStopwatch,
              child: const Text('Start'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _stopStopwatch,
              child: const Text('Stop'),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: _resetStopwatch,
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}

class ClockPainter extends CustomPainter {
  final bool isDarkTheme;

  final Duration elapsed;

  ClockPainter(this.elapsed, this.isDarkTheme);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final tickPaint = Paint()
      ..color = isDarkTheme ? Colors.white : Colors.black
      ..strokeWidth = 2;

    // Draw the ticks and numbers
    for (int i = 0; i < 60; i++) {
      final angle = i * pi / 30;
      final tickLength = i % 5 == 0 ? 10.0 : 5.0;
      final startOffset = Offset(
        center.dx + (radius - tickLength) * cos(angle),
        center.dy + (radius - tickLength) * sin(angle),
      );
      final endOffset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(startOffset, endOffset, tickPaint);

      // Draw the numbers
      if (i % 5 == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i == 0 ? 60 : i}',
            style: TextStyle(
              color: isDarkTheme ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        final numberAngle = i * pi / 30 - pi / 2;
        final numberOffset = Offset(
          center.dx + (radius - 25) * cos(numberAngle) - textPainter.width / 2,
          center.dy + (radius - 25) * sin(numberAngle) - textPainter.height / 2,
        );
        textPainter.paint(canvas, numberOffset);
      }
    }

    final secondsHandLength = radius * 0.8;
    final secondsHandPaint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2;

    final secondsAngle = (elapsed.inMilliseconds % 60000) * 2 * pi / 60000;
    final secondsHandOffset = Offset(
      center.dx + secondsHandLength * cos(secondsAngle - pi / 2),
      center.dy + secondsHandLength * sin(secondsAngle - pi / 2),
    );

    canvas.drawLine(center, secondsHandOffset, secondsHandPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class ElapsedTimeDisplay extends StatelessWidget {
  final Duration elapsed;

  const ElapsedTimeDisplay(this.elapsed, {super.key});

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

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatDuration(elapsed),
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
