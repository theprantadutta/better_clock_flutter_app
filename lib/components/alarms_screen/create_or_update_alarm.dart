import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'alarm_type_button.dart';
import 'day_button.dart';
import 'timer_picker.dart';

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
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.check_outlined),
                ),
              ],
            ),
          ),
          const TimerPicker(initialDuration: Duration(hours: 6, minutes: 20)),
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
                    DayButton(title: 'SUN', onPressed: () {}, isSelected: true),
                    DayButton(
                        title: 'MON', onPressed: () {}, isSelected: false),
                    DayButton(title: 'TUE', onPressed: () {}, isSelected: true),
                    DayButton(
                        title: 'WED', onPressed: () {}, isSelected: false),
                    DayButton(
                        title: 'THU', onPressed: () {}, isSelected: false),
                    DayButton(title: 'FRI', onPressed: () {}, isSelected: true),
                    DayButton(title: 'SAT', onPressed: () {}, isSelected: true),
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
                  onTapOutside: (event) {
                    print('onTapOutside');
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
                Container(
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
                            'Fair Views',
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
                          onChanged: (value) =>
                              setState(() => shouldVibrate = shouldVibrate),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
