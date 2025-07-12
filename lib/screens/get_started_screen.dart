import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this for SystemChrome

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  bool _isOverlayVisible = true;

  @override
  void initState() {
    super.initState();

    // Set navigation bar color to white
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // Set navigation bar color
      systemNavigationBarIconBrightness: Brightness.dark, // Icon color
    ));

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start just off the bottom of the screen
      end: Offset.zero,           // End at normal position
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward(); // Ensure it starts in the visible position
  }

  void _toggleContainerPosition() {
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse(); // Slide container down
      setState(() {
        _isOverlayVisible = false; // Remove vintage effect while sliding down
      });

      // Bring the container back up after a 1-second delay
      Future.delayed(const Duration(seconds: 1), () {
        _animationController.forward();
        setState(() {
          _isOverlayVisible = true; // Restore vintage effect
        });
      });
    }
  }

  @override
  void dispose() {
    // Reset navigation bar color to default
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // Restore default color
      systemNavigationBarIconBrightness: Brightness.light, // Restore icon brightness
    ));
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/images/backlogo.jpg', // Update to your background image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Vintage Overlay Effect
          if (_isOverlayVisible)
            Container(
              color: Colors.black.withOpacity(0.4), // Adjust opacity for vintage effect
            ),
          // Tap Gesture Detector for outside taps
          GestureDetector(
            onTap: _toggleContainerPosition,
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Sliding Container with Login/Register Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                width: double.infinity, // Full width
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    // Get Started Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Get Started - Navigate to next screen
                          // TODO: Navigate to main app or next onboarding screen
                          print('Get Started pressed');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2E7D32), // Forest Green from UI guidelines
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Terms and Privacy Policy
                    Text(
                      'By continuing, you agree to Dua Apomden Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
