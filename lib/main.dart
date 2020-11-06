import 'package:flutter/material.dart';
import 'package:space_reload_flutter/demo.dart';
import 'package:space_reload_flutter/refresh_demo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RefreshControlDemo(demos['space']),
      debugShowCheckedModeBanner: false,
    );
  }
}

final Map<String, Demo> demos = {
  'space': Demo(
    riveFile: 'space_reload',
    alignment: Alignment.center,
    navTitle: 'StarTrack',
    navColor: Color(0xFF342472),
    backgroundColor: Color(0xFF342472),
    tileColor: Color(0xFF4A3F8A)
  ),
  'rocket': Demo(
    riveFile: 'rocket_reload',
    alignment: Alignment.bottomCenter,
    navTitle: 'LyftOff',
    navColor: Color(0xFF282828),
    backgroundColor: Color(0xFF333333),
    tileColor: Color(0xFF282828)
  ),
  'tape': Demo(
    riveFile: 'tape_reload',
    alignment: Alignment.center,
    navTitle: 'DubTapes',
    navColor: Color(0xFF040404),
    backgroundColor: Color(0xFF040404),
    tileColor: Color(0xFF201F22)
  ),
  'zombie': Demo(
    riveFile: 'zombie',
    alignment: Alignment.center,
    navTitle: 'ZombieRun',
    navColor: Color(0xFF342472),
    backgroundColor: Color(0xFF342472),
    tileColor: Color(0xFF4A3F8A)
  ),
};