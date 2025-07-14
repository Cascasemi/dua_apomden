// Quick test to verify all screens load properly
import 'package:flutter/material.dart';
import 'lib/screens/home_dashboard_screen.dart';
import 'lib/screens/scan_screen.dart';
import 'lib/screens/history_screen.dart';
import 'lib/screens/learn_screen.dart';
import 'lib/screens/settings_screen.dart';

void main() {
  runApp(TestApp());
}

class TestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TestNavigation(),
    );
  }
}

class TestNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HomeDashboardScreen())),
              child: Text('Home Dashboard'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScanScreen(selectedTabIndex: 1))),
              child: Text('Scan Screen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryScreen(selectedTabIndex: 2))),
              child: Text('History Screen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LearnScreen(selectedTabIndex: 3))),
              child: Text('Learn Screen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(selectedTabIndex: 4))),
              child: Text('Settings Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
