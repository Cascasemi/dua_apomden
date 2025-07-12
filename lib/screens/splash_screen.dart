import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
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
                  color: Colors.green[300],
                ),
                Positioned(
                  top: 15,
                  right: 15,
                  child: Icon(
                    Icons.health_and_safety,
                    size: 35,
                    color: Colors.white,
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
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}