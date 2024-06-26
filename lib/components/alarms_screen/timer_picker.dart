import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerPicker extends StatefulWidget {
  final Duration initialDuration;

  const TimerPicker({super.key, required this.initialDuration});

  @override
  State<TimerPicker> createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  late int _selectedHour;
  late int _selectedMinute;
  late String _selectedPeriod;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialDuration.inHours % 12 == 0
        ? 12
        : widget.initialDuration.inHours % 12;
    _selectedMinute = widget.initialDuration.inMinutes % 60;
    _selectedPeriod = widget.initialDuration.inHours >= 12 ? 'PM' : 'AM';
  }

  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20.0),
      ),
      height: MediaQuery.sizeOf(context).height * 0.22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPicker(
            children: List<Widget>.generate(12, (int index) {
              return Center(
                child: Text(
                  '${index + 1}',
                  style: defaultTextStyle,
                ),
              );
            }),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedHour = index + 1;
              });
            },
            initialItem: _selectedHour - 1,
            looping: true,
          ),
          const SizedBox(width: 10),
          _buildPicker(
            children: List<Widget>.generate(60, (int index) {
              return Center(
                child: Text(
                  '$index',
                  style: defaultTextStyle,
                ),
              );
            }),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedMinute = index;
              });
            },
            initialItem: _selectedMinute,
            looping: true,
          ),
          const SizedBox(width: 10),
          _buildPicker(
            children: ['AM', 'PM'].map<Widget>((String value) {
              return Center(
                child: Text(
                  value,
                  style: defaultTextStyle,
                ),
              );
            }).toList(),
            onSelectedItemChanged: (index) {
              setState(() {
                _selectedPeriod = index == 0 ? 'AM' : 'PM';
              });
            },
            initialItem: _selectedPeriod == 'AM' ? 0 : 1,
            looping: false,
          ),
        ],
      ),
    );
  }

  Widget _buildPicker({
    required List<Widget> children,
    required ValueChanged<int> onSelectedItemChanged,
    required int initialItem,
    required bool looping,
  }) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(initialItem: initialItem),
        itemExtent: 50.0,
        onSelectedItemChanged: onSelectedItemChanged,
        diameterRatio: 2,
        squeeze: 1,
        useMagnifier: true,
        // magnification: 1.2,
        looping: looping,
        selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
          background: Theme.of(context).primaryColor.withOpacity(0.05),
        ),
        children: children,
      ),
    );
  }
}
