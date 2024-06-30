import 'package:better_clock_flutter_app/packages/flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:better_clock_flutter_app/services/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../entities/alarm.dart';
import 'alarm_snooze.dart';
import 'alarm_type_button.dart';
import 'day_button.dart';
import 'ringtone_list.dart';
import 'timer_picker.dart';

const kSunDay = 'SUN';
const kMonDay = 'MON';
const kTueDay = 'TUE';
const kWedDay = 'WED';
const kThuDay = 'THU';
const kFriDay = 'FRI';
const kSatDay = 'SAT';

class CreateOrUpdateAlarm extends StatefulWidget {
  const CreateOrUpdateAlarm({
    super.key,
  });

  @override
  State<CreateOrUpdateAlarm> createState() => _CreateOrUpdateAlarmState();
}

class _CreateOrUpdateAlarmState extends State<CreateOrUpdateAlarm> {
  bool ringOnce = true;
  bool shouldVibrate = true;
  Duration alarmTime = const Duration(minutes: 420);
  String alarmTitle = '';
  Duration snoozeDuration = const Duration(minutes: 5);
  int snoozeTimes = 3;
  bool enableSnooze = true;
  List<String> dayList = [];

  void addOrRemoveDays(String value) {
    if (dayList.contains(value)) {
      dayList.remove(value);
    } else {
      dayList.add(value);
    }
    setState(() {});
  }

  Future<void> addAnAlarm() async {
    Loader.show(context);
    final isar = await IsarService().openDB();
    final alarm = Alarm(
      id: isar.alarms.autoIncrement(),
      alarmEnabled: true,
      title: alarmTitle.isEmpty ? 'Alarm' : alarmTitle,
      durationMinutes: alarmTime.inMinutes,
      ringOnce: ringOnce,
      days: dayList,
      ringtone: 'Default',
      vibrate: shouldVibrate,
      enableSnooze: enableSnooze,
      snoozeDurationMinutes: snoozeDuration.inMinutes,
      snoozeTime: snoozeTimes,
    );
    await IsarService().createAlarm(alarm);
    Loader.hide();
    // ignore: use_build_context_synchronously
    return context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final kPrimaryColor = Theme.of(context).primaryColor;
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.92,
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
                  'Add an Alarm',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  onPressed: addAnAlarm,
                  icon: const Icon(Icons.check_outlined),
                ),
              ],
            ),
          ),
          TimerPicker(
            initialDuration: alarmTime,
            addOrUpdateAlarm: (duration) =>
                setState(() => alarmTime = duration),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AlarmTypeButton(
                  ringOnce: ringOnce,
                  title: 'Ring Once',
                  onPressed: () => setState(() => ringOnce = !ringOnce),
                ),
                const SizedBox(width: 10),
                AlarmTypeButton(
                  ringOnce: !ringOnce,
                  title: 'Custom',
                  onPressed: () => setState(() => ringOnce = !ringOnce),
                ),
              ],
            ),
          ),
          if (!ringOnce)
            Container(
              decoration: BoxDecoration(
                // border: Border.all(color: kPrimaryColor),
                color: kPrimaryColor.withOpacity(0.04),
                borderRadius: BorderRadius.circular(15),
              ),
              height: MediaQuery.sizeOf(context).height * 0.16,
              width: MediaQuery.sizeOf(context).width,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Repeat',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      DayButton(
                        title: kSunDay,
                        onPressed: () => addOrRemoveDays(kSunDay),
                        isSelected: dayList.contains(kSunDay),
                      ),
                      DayButton(
                        title: kMonDay,
                        onPressed: () => addOrRemoveDays(kMonDay),
                        isSelected: dayList.contains(kMonDay),
                      ),
                      DayButton(
                        title: kTueDay,
                        onPressed: () => addOrRemoveDays(kTueDay),
                        isSelected: dayList.contains(kTueDay),
                      ),
                      DayButton(
                        title: kWedDay,
                        onPressed: () => addOrRemoveDays(kWedDay),
                        isSelected: dayList.contains(kWedDay),
                      ),
                      DayButton(
                        title: kThuDay,
                        onPressed: () => addOrRemoveDays(kThuDay),
                        isSelected: dayList.contains(kThuDay),
                      ),
                      DayButton(
                        title: kFriDay,
                        onPressed: () => addOrRemoveDays(kFriDay),
                        isSelected: dayList.contains(kFriDay),
                      ),
                      DayButton(
                        title: kSatDay,
                        onPressed: () => addOrRemoveDays(kSatDay),
                        isSelected: dayList.contains(kSatDay),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Container(
            // padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.04),
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            // height: MediaQuery.sizeOf(context).height * 0.25,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) => alarmTitle = value,
                  onTapOutside: (event) {
                    // print('onTapOutside');
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: 'Alarm Name',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    // Remove border when the TextField is enabled but not focused
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Remove border when the TextField is focused
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kPrimaryColor.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Border when there is an error
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red.withOpacity(0.3), // Error color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Border when the TextField is focused and there is an error
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red.withOpacity(0.3), // Error color
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return const RingtoneList();
                      },
                    );
                  },
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.08,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ringtone',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Default (I Don\'t Know)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.06,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vibrate',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch.adaptive(
                          value: shouldVibrate,
                          onChanged: (value) => setState(
                            () => shouldVibrate = !shouldVibrate,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return AlarmSnooze(
                        snoozeDuration: snoozeDuration,
                        changeSnoozeDuration: (duration) {
                          if (duration == null) return;
                          setState(() => snoozeDuration = duration);
                        },
                        snoozeTimes: snoozeTimes,
                        changeSnoozeTime: (time) {
                          if (time == null) return;
                          setState(() => snoozeTimes = time);
                        },
                        enableSnooze: enableSnooze,
                        changeEnableSnooze: (snooze) =>
                            setState(() => enableSnooze = snooze),
                      );
                    },
                  ),
                  child: Container(
                    height: MediaQuery.sizeOf(context).height * 0.08,
                    margin: const EdgeInsets.only(top: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Snooze',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '5 Minutes, 3 Times',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
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
