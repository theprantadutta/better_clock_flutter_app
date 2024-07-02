import 'package:better_clock_flutter_app/packages/flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../entities/alarm.dart';
import '../../services/isar_service.dart';

class SingleAlarmRow extends StatefulWidget {
  final Alarm alarm;
  final Future<void> Function() refetch;

  const SingleAlarmRow({
    super.key,
    required this.alarm,
    required this.refetch,
  });

  @override
  State<SingleAlarmRow> createState() => _SingleAlarmRowState();
}

class _SingleAlarmRowState extends State<SingleAlarmRow> {
  bool alarmOn = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      alarmOn = widget.alarm.alarmEnabled;
    });
  }

  String formatDurationToTime(int durationMinutes) {
    // Calculate the total hours and minutes
    int hours = durationMinutes ~/ 60;
    int minutes = durationMinutes % 60;

    // Adjust hours for 12-hour format
    hours = hours % 12;
    hours =
        hours == 0 ? 12 : hours; // Convert '0' hours to '12' for AM/PM format

    // Format hours and minutes to two digits
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');

    // Return formatted time string
    return "$hoursStr:$minutesStr";
  }

  String getAmPmPeriod(int durationMinutes) {
    // Calculate the total hours
    int hours = durationMinutes ~/ 60;

    // Determine AM/PM period
    return hours >= 12 ? "PM" : "AM";
  }

  onAlarmEnabledChanged(value) async {
    setState(
      () => alarmOn = value,
    );
    await IsarService().updateAnAlarmEnabled(widget.alarm, value);
  }

  Future<void> deleteAlarm() async {
    Loader.show(context);
    await IsarService().deleteAnAlarm(widget.alarm.id);
    await widget.refetch();
    Future.delayed(Duration.zero, () {
      Loader.hide();
    });
    // ignore: use_build_context_synchronously
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: MediaQuery.sizeOf(context).height * 0.14,
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.alarm.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    formatDurationToTime(widget.alarm.durationMinutes),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    getAmPmPeriod(widget.alarm.durationMinutes),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Text(
                widget.alarm.ringOnce ? 'Ring Once' : 'Repeat',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Transform.scale(
                scale: 0.8,
                child: Switch.adaptive(
                  value: alarmOn,
                  onChanged: onAlarmEnabledChanged,
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.15,
                          width: MediaQuery.sizeOf(context).width * 0.9,
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Are you sure?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: deleteAlarm,
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: kPrimaryColor,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => context.pop(),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: kPrimaryColor,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'No',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.04,
                  width: MediaQuery.sizeOf(context).width * 0.18,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor.withOpacity(0.6),
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
