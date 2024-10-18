import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screen_arguments/ring_screen_arguments.dart';
import '../screens/alarms_screen.dart';
import '../screens/ring_screen.dart';
import '../screens/stopwatch_screen.dart';
import '../screens/timer_screen.dart';
import '../screens/world_clock_screen.dart';
import 'bottom_navgation_layout.dart';

class AppNavigation {
  AppNavigation._();

  static String initial = AlarmsScreen.kRouteName;
  // static String initial = RingScreen.kRouteName;

  // Private navigators
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorAlarms =
      GlobalKey<NavigatorState>(debugLabel: 'shellAlarms');
  static final _shellNavigatorWorldClock =
      GlobalKey<NavigatorState>(debugLabel: 'shellWorldClock');
  static final _shellNavigatorStopwatch =
      GlobalKey<NavigatorState>(debugLabel: 'shellStopwatch');
  static final _shellNavigatorTimer =
      GlobalKey<NavigatorState>(debugLabel: 'shellTimer');

  // GoRouter configuration
  static final GoRouter router = GoRouter(
    initialLocation: initial,
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      /// MainWrapper
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return const BottomNavigationLayout();
        },
        branches: <StatefulShellBranch>[
          /// Branch Alarms
          StatefulShellBranch(
            navigatorKey: _shellNavigatorAlarms,
            routes: <RouteBase>[
              GoRoute(
                path: AlarmsScreen.kRouteName,
                name: "Alarms",
                pageBuilder: (context, state) => reusableTransitionPage(
                  state: state,
                  child: const AlarmsScreen(),
                ),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _shellNavigatorWorldClock,
            routes: <RouteBase>[
              GoRoute(
                path: WorldClockScreen.kRouteName,
                name: "WorldClock",
                pageBuilder: (context, state) => reusableTransitionPage(
                  state: state,
                  child: const WorldClockScreen(),
                ),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _shellNavigatorStopwatch,
            routes: <RouteBase>[
              GoRoute(
                path: StopwatchScreen.kRouteName,
                name: "Stopwatch",
                pageBuilder: (context, state) => reusableTransitionPage(
                  state: state,
                  child: const StopwatchScreen(),
                ),
              ),
            ],
          ),

          StatefulShellBranch(
            navigatorKey: _shellNavigatorTimer,
            routes: <RouteBase>[
              GoRoute(
                path: TimerScreen.kRouteName,
                name: "Services",
                pageBuilder: (context, state) => reusableTransitionPage(
                  state: state,
                  child: const TimerScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      /// Ring Screen
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: RingScreen.kRouteName,
        name: "Ring",
        builder: (context, state) {
          RingScreenArguments args;
          if (state.extra == null) {
            args = RingScreenArguments(
              alarmSettings: AlarmSettings(
                id: 1,
                dateTime: DateTime.now(),
                assetAudioPath: 'assets/Animal_BGM.mp3',
                notificationSettings: NotificationSettings(
                  title: 'Test Notification',
                  body: 'Test Notification Body',
                  stopButton: 'Stop',
                ),
              ),
            );
          } else {
            args = state.extra as RingScreenArguments;
          }
          return RingScreen(alarmSettings: args.alarmSettings);
        },
      ),
    ],
    extraCodec: const MyExtraCodec(),
  );

  static CustomTransitionPage<void> reusableTransitionPage({
    required state,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      restorationId: state.pageKey.value,
      transitionDuration: const Duration(milliseconds: 500),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
