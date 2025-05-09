import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import '../components/world_clock_screen/analog_clock_widget.dart';
import '../components/world_clock_screen/clock_lists.dart';
import '../layouts/main_layout.dart';

class WorldClockScreen extends StatelessWidget {
  static const kRouteName = '/world-clock';
  const WorldClockScreen({super.key});

  String getFormattedDateTime() {
    // Define the time zone for Bangladesh Standard Time (BST)
    final location = tz.getLocation('Asia/Dhaka');

    // Get the current date and time in Bangladesh Standard Time
    final now = tz.TZDateTime.now(location);

    // Get the time zone abbreviation and name
    // final timeZoneOffset = now.timeZoneOffset;
    final timeZoneName = now.timeZoneName;

    // Map of common time zone abbreviations to their full names
    final timeZoneFullName = {
      'BDT': 'Bangladesh Standard Time',
    };

    // Format the date part
    final dateFormatter = DateFormat('EEE, MMM d');
    final formattedDate = dateFormatter.format(now);

    // Combine the formatted parts with the dynamic time zone name
    final formattedDateTime =
        '${timeZoneFullName[timeZoneName] ?? timeZoneName} | $formattedDate';

    return formattedDateTime;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
            const AnalogClockWidget(),
            SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
            Text(
              'Bangladesh Standard Time | Thu, Jun 22',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(0.5),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.04,
            ),
            const ClockLists(),
          ],
        ),
      ),
    );
  }
}
