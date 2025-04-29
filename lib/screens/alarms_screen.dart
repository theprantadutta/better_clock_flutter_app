// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_autostart/flutter_autostart.dart';
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
  final _flutterAutostartPlugin = FlutterAutostart();

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
      debugPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      debugPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      debugPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      debugPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    debugPrint('Schedule exact alarm permission: $status.');
    if (status.isDenied) {
      debugPrint('Requesting schedule exact alarm permission...');
      final res = await Permission.scheduleExactAlarm.request();
      debugPrint(
        'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted',
      );
    }
  }

  Future<void> initAutoStart() async {
    if (!mounted) return;

    String autoStartEnabled = await checkIsAutoStartEnabled();
    if (autoStartEnabled == 'Yes') return;
    // Open the settings if needed (this could be based on the auto start availability)
    await openAutoStartPermissionSettings();
  }

  Future<String> checkIsAutoStartEnabled() async {
    String isAutoStartEnabled;
    try {
      isAutoStartEnabled =
          await _flutterAutostartPlugin.checkIsAutoStartEnabled() == true
              ? "Yes"
              : "No";
      if (kDebugMode) {
        print("isAutoStartEnabled: $isAutoStartEnabled");
      }
    } on PlatformException {
      isAutoStartEnabled = 'Failed to check isAutoStartEnabled.';
      if (kDebugMode) {
        print(isAutoStartEnabled);
      }
    }

    return isAutoStartEnabled;
  }

  Future<void> openAutoStartPermissionSettings() async {
    String autoStartPermission;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Auto-start Required"),
        content: const Text(
            "Please enable auto-start for this app in your device settings "
            "to ensure it runs properly in the background."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                autoStartPermission = await _flutterAutostartPlugin
                        .showAutoStartPermissionSettings() ??
                    'Unknown autoStartPermission';
                if (kDebugMode) {
                  print("autoStartPermission: $autoStartPermission");
                }
              } on PlatformException {
                autoStartPermission = 'Failed to show autoStartPermission.';
                if (kDebugMode) {
                  print(autoStartPermission);
                }
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Error"),
                    content: const Text(
                        "Could not check auto-start status. Some features may not work as intended."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            const AlarmScreenTitle(),
            const AlarmsList(),
          ],
        ),
      ),
    );
  }
}
