import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'clock_painter.dart';
import 'elapsed_time_display.dart';
import 'lap_list.dart';
import 'stopwatch_button.dart';

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

  List<Duration> _laps = [];

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
      _laps = [];
    });
  }

  void _takeALap() {
    if (_elapsed == Duration.zero) return;
    setState(() {
      _laps.add(_elapsed);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.25,
            width: MediaQuery.sizeOf(context).width * 0.5,
            child: CustomPaint(
              painter: ClockPainter(
                _elapsed,
                isDarkTheme,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElapsedTimeDisplay(_elapsed),
        // const SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.43,
          child: LapList(laps: _laps),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StopwatchButton(
                onPressed: _startStopwatch,
                title: 'Start',
              ),
              const SizedBox(width: 10),
              StopwatchButton(
                onPressed: _stopStopwatch,
                title: 'Stop',
              ),
              const SizedBox(width: 10),
              StopwatchButton(
                onPressed: _takeALap,
                title: 'Lap',
              ),
              const SizedBox(width: 10),
              StopwatchButton(
                onPressed: _resetStopwatch,
                title: 'Reset',
              ),
            ],
          ),
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
