import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'navigation/app_navigation.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // ignore: library_private_types_in_public_api
  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  final FlexScheme _flexScheme = FlexScheme.pinkM3;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppNavigation.router,
      title: 'Better Clock',
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: _flexScheme,
        useMaterial3: true,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: _flexScheme,
        useMaterial3: true,
      ),
      themeMode: _themeMode,
    );
  }
}
