import 'package:flutter/material.dart';
import 'get_started_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to GetStartedScreen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GetStartedScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9), // Very Light Green background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.park,
                  size: 100,
                  color: Color(0xFF2E7D32), // Forest Green - represents healthy crops
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Icon(
                    Icons.health_and_safety,
                    size: 35,
                    color: Color(0xFF8BC34A), // Light Green for positive indicators
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Dua Apomden',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20), // Dark Green text
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E7D32)), // Forest Green
            ),
          ],
        ),
      ),
    );
  }
}