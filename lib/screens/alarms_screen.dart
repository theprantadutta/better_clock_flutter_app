import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../components/alarms_screen/alarm_screen_title.dart';
import '../components/alarms_screen/alarms_list.dart';
import '../layouts/main_layout.dart';
import '../screen_arguments/ring_screen_arguments.dart';
import 'ring_screen.dart';

class AlarmsScreen extends StatefulWidget {
  static const kRouteName = '/alarms';
  const AlarmsScreen({super.key});

  @override
  State<AlarmsScreen> createState() => _AlarmsScreenState();
}

class _AlarmsScreenState extends State<AlarmsScreen> {
  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
      checkAndroidScheduleExactAlarmPermission();
      initAutoStart();
    }
    subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    debugPrint('Navigating to the Ring Screen');
    context.go(
      RingScreen.kRouteName,
      extra: RingScreenArguments(
        alarmSettings: alarmSettings,
      ),
    );
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    alarmPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      alarmPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      alarmPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  //initializing the autoStart with the first build.
  Future<void> initAutoStart() async {
    if (!mounted) return;
    try {
      //check auto-start availability.
      var test = await (isAutoStartAvailable);
      if (kDebugMode) {
        print('is Auto Start Available $test');
      }
      //if available then navigate to auto-start setting page.
      if (test == true) await getAutoStartPermission();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              const AlarmScreenTitle(),
              const AlarmsList(),
            ],
          ),
        ),
      ),
    );
  }
}
