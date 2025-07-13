import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String selectedLanguage = '';
  PageController _pageController = PageController();
  int currentPage = 0;
  late FlutterTts flutterTts;
  late AudioPlayer audioPlayer;
  bool isSpeaking = false;

  final List<OnboardingPageData> onboardingPages = [
    OnboardingPageData(
      icon: Icons.agriculture,
      title: 'Dua Apomden',
      description: 'Protect your crops with AI-powered disease detection. Capture, analyze, and get instant treatment recommendations for healthier harvests.',
      color: Color(0xFF2E7D32),
      isWelcomePage: true,
    ),
    OnboardingPageData(
      icon: Icons.search,
      title: 'AI-Powered Analysis',
      description: 'Our intelligent system analyzes your crop images and provides accurate disease detection results.',
      color: Color(0xFF4CAF50),
      isWelcomePage: false,
    ),
    OnboardingPageData(
      icon: Icons.healing,
      title: 'Get Treatment Solutions',
      description: 'Receive personalized treatment recommendations and expert advice for your crop diseases.',
      color: Color(0xFF8BC34A),
      isWelcomePage: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
    _initializeTtsAndAudio();
  }

  @override
  void dispose() {
    _pageController.dispose();
    flutterTts.stop();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initializeTtsAndAudio() async {
    flutterTts = FlutterTts();
    audioPlayer = AudioPlayer();
    
    // Configure TTS
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.3); // Slower speech rate (reduced from 0.5)
    await flutterTts.setVolume(0.8);
    await flutterTts.setPitch(0.7); // Lower pitch (reduced from 1.0)
    
    // Set TTS completion callback
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    
    flutterTts.setErrorHandler((msg) {
      setState(() {
        isSpeaking = false;
      });
      print('TTS Error: $msg');
    });
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('languageselection') ?? 'English';
    });
    
    // Start TTS/audio for the first page after language is loaded
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        _handlePageChange(0);
      }
    });
  }

  void _nextPage() {
    if (currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      onboardingPages.length - 1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finishOnboarding() {
    // TODO: Navigate to main app
    print('Onboarding finished - Navigate to main app');
  }

  Future<void> _speakDescription(String description) async {
    if (selectedLanguage == 'English' && !isSpeaking) {
      setState(() {
        isSpeaking = true;
      });
      await flutterTts.speak(description);
    }
  }

  Future<void> _playEweAudio() async {
    if (selectedLanguage == 'Ewe') {
      try {
        await audioPlayer.play(AssetSource('audio/eweexplain.mp3'));
      } catch (e) {
        print('Error playing Ewe audio: $e');
      }
    }
  }

  Future<void> _playTwiAudio() async {
    if (selectedLanguage == 'Twi') {
      try {
        await audioPlayer.play(AssetSource('audio/outputtwi.mp3'));
      } catch (e) {
        print('Error playing Twi audio: $e');
      }
    }
  }

  Future<void> _stopAllAudio() async {
    if (isSpeaking) {
      await flutterTts.stop();
      setState(() {
        isSpeaking = false;
      });
    }
    await audioPlayer.stop();
  }

  void _handlePageChange(int page) async {
    // Stop any ongoing audio/TTS when changing pages
    await _stopAllAudio();
    
    setState(() {
      currentPage = page;
    });
    
    // Handle audio/TTS for the new page
    final pageData = onboardingPages[page];
    
    if (selectedLanguage == 'English') {
      // Use TTS for English
      _speakDescription(pageData.description);
    } else if (selectedLanguage == 'Ewe') {
      if (page == 0) {
        // Play Ewe audio for first page after 1 second delay
        Future.delayed(Duration(seconds: 1), () {
          _playEweAudio();
        });
      }
      // TODO: Add audio for other pages when files are uploaded
    } else if (selectedLanguage == 'Twi') {
      if (page == 0) {
        // Play Twi audio for first page after 1 second delay
        Future.delayed(Duration(seconds: 1), () {
          _playTwiAudio();
        });
      }
      // TODO: Add audio for other pages when files are uploaded
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9), // Very Light Green background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2E7D32),
            size: 24,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          if (currentPage < onboardingPages.length - 1)
            TextButton(
              onPressed: _skipToEnd,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Language indicator
          if (selectedLanguage.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Color(0xFF8BC34A).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Language: $selectedLanguage',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
          // Page content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                _handlePageChange(page);
              },
              itemCount: onboardingPages.length,
              itemBuilder: (context, index) {
                return _buildOnboardingPage(onboardingPages[index]);
              },
            ),
          ),
          // Page indicators
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                onboardingPages.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == index 
                        ? Color(0xFF2E7D32) 
                        : Color(0xFF2E7D32).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          // Navigation button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  currentPage == onboardingPages.length - 1 ? 'Finish' : 'Next',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPageData pageData) {
    if (pageData.isWelcomePage) {
      // Custom layout for welcome page with water-like shape
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              pageData.color.withOpacity(0.1),
              pageData.color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Image with water-like shape clipping mask
                  Center(
                    child: ClipPath(
                      clipper: WaterShapeClipper(),
                      child: Container(
                        width: 250,
                        height: 200,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: pageData.color.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/farmerlady.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: pageData.color.withOpacity(0.2),
                              child: Icon(
                                pageData.icon,
                                size: 60,
                                color: pageData.color,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pageData.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: pageData.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      pageData.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSpeaking && selectedLanguage == 'English' 
                            ? pageData.color.withOpacity(0.8)
                            : Colors.grey[600],
                        height: 1.5,
                        fontWeight: isSpeaking && selectedLanguage == 'English' 
                            ? FontWeight.w500 
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Original layout for other pages
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: pageData.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                pageData.icon,
                size: 60,
                color: pageData.color,
              ),
            ),
            const SizedBox(height: 40),
            // Title
            Text(
              pageData.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Description
            Text(
              pageData.description,
              style: TextStyle(
                fontSize: 16,
                color: isSpeaking && selectedLanguage == 'English' 
                    ? Color(0xFF1B5E20) 
                    : Color(0xFF1B5E20).withOpacity(0.7),
                height: 1.5,
                fontWeight: isSpeaking && selectedLanguage == 'English' 
                    ? FontWeight.w500 
                    : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }
}

class OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final bool isWelcomePage;

  OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.isWelcomePage,
  });
}

// Custom painter for water-like shape
class WaterShapePainter extends CustomPainter {
  final Color color;

  WaterShapePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create main organic water-like shape
    path.moveTo(width * 0.2, height * 0.3);
    
    // Top left curve
    path.quadraticBezierTo(
      width * 0.1, height * 0.1,  // control point
      width * 0.35, height * 0.15  // end point
    );
    
    // Top right curve
    path.quadraticBezierTo(
      width * 0.7, height * 0.05,  // control point
      width * 0.85, height * 0.25  // end point
    );
    
    // Right side curve
    path.quadraticBezierTo(
      width * 0.95, height * 0.5,  // control point
      width * 0.8, height * 0.75   // end point
    );
    
    // Bottom right curve
    path.quadraticBezierTo(
      width * 0.7, height * 0.95,  // control point
      width * 0.4, height * 0.9    // end point
    );
    
    // Bottom left curve
    path.quadraticBezierTo(
      width * 0.15, height * 0.85, // control point
      width * 0.05, height * 0.6   // end point
    );
    
    // Left side curve back to start
    path.quadraticBezierTo(
      width * 0.05, height * 0.45, // control point
      width * 0.2, height * 0.3    // back to start
    );
    
    path.close();
    
    // Add droplets to match the clipper
    // Droplet 1 - Top right area
    path.addOval(Rect.fromCircle(
      center: Offset(width * 0.88, height * 0.15),
      radius: width * 0.04,
    ));

    // Droplet 2 - Top left area
    path.addOval(Rect.fromCircle(
      center: Offset(width * 0.15, height * 0.08),
      radius: width * 0.025,
    ));

    // Droplet 3 - Right side
    path.addOval(Rect.fromCircle(
      center: Offset(width * 0.92, height * 0.45),
      radius: width * 0.03,
    ));

    // Droplet 5 - Left side
    path.addOval(Rect.fromCircle(
      center: Offset(width * 0.02, height * 0.55),
      radius: width * 0.02,
    ));

    // Droplet 6 - Top center area
    path.addOval(Rect.fromCenter(
      center: Offset(width * 0.45, height * 0.03),
      width: width * 0.06,
      height: width * 0.03,
    ));

    // Small splash effects
    path.addOval(Rect.fromCircle(
      center: Offset(width * 0.83, height * 0.2),
      radius: width * 0.015,
    ));

    path.addOval(Rect.fromCircle(
      center: Offset(width * 0.18, height * 0.12),
      radius: width * 0.012,
    ));

    path.addOval(Rect.fromCircle(
      center: Offset(width * 0.88, height * 0.4),
      radius: width * 0.01,
    ));
    
    // Draw the main shape with droplets
    canvas.drawPath(path, paint);
    
    // Add subtle gradient effect
    final gradientPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.8,
        colors: [
          color.withOpacity(0.3),
          color.withOpacity(0.1),
          color.withOpacity(0.05),
        ],
      ).createShader(Rect.fromLTWH(0, 0, width, height));
    
    canvas.drawPath(path, gradientPaint);
    
    // Add ripple effect circles around the main body
    final ripplePaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final center = Offset(width / 2, height / 2);
    canvas.drawCircle(center, width * 0.3, ripplePaint);
    canvas.drawCircle(center, width * 0.2, ripplePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom clipper for water-like shape
class WaterShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create the main organic water-like shape
    path.moveTo(width * 0.2, height * 0.3);
    
    // Top left curve
    path.quadraticBezierTo(
      width * 0.1, height * 0.1,  // control point
      width * 0.35, height * 0.15  // end point
    );
    
    // Top right curve
    path.quadraticBezierTo(
      width * 0.7, height * 0.05,  // control point
      width * 0.85, height * 0.25  // end point
    );
    
    // Right side curve
    path.quadraticBezierTo(
      width * 0.95, height * 0.5,  // control point
      width * 0.8, height * 0.75   // end point
    );
    
    // Bottom right curve
    path.quadraticBezierTo(
      width * 0.7, height * 0.95,  // control point
      width * 0.4, height * 0.9    // end point
    );
    
    // Bottom left curve
    path.quadraticBezierTo(
      width * 0.15, height * 0.85, // control point
      width * 0.05, height * 0.6   // end point
    );
    
    // Left side curve back to start
    path.quadraticBezierTo(
      width * 0.05, height * 0.45, // control point
      width * 0.2, height * 0.3    // back to start
    );
    
    path.close();

    // Add droplet 1 - Top right area
    final droplet1 = Path();
    droplet1.addOval(Rect.fromCircle(
      center: Offset(width * 0.88, height * 0.15),
      radius: width * 0.04,
    ));
    path.addPath(droplet1, Offset.zero);

    // Add droplet 2 - Top left area (smaller)
    final droplet2 = Path();
    droplet2.addOval(Rect.fromCircle(
      center: Offset(width * 0.15, height * 0.08),
      radius: width * 0.025,
    ));
    path.addPath(droplet2, Offset.zero);

    // Add droplet 3 - Right side (medium)
    final droplet3 = Path();
    droplet3.addOval(Rect.fromCircle(
      center: Offset(width * 0.92, height * 0.45),
      radius: width * 0.03,
    ));
    path.addPath(droplet3, Offset.zero);

    // Add droplet 4 - Bottom area (tear drop shape)
    final droplet4 = Path();
    droplet4.moveTo(width * 0.5, height * 0.95);
    droplet4.quadraticBezierTo(
      width * 0.48, height * 0.98,  // control point
      width * 0.52, height * 0.98   // end point
    );
    droplet4.quadraticBezierTo(
      width * 0.54, height * 0.96,  // control point
      width * 0.5, height * 0.95    // back to start
    );
    droplet4.close();
    path.addPath(droplet4, Offset.zero);

    // Add droplet 5 - Left side (small)
    final droplet5 = Path();
    droplet5.addOval(Rect.fromCircle(
      center: Offset(width * 0.02, height * 0.55),
      radius: width * 0.02,
    ));
    path.addPath(droplet5, Offset.zero);

    // Add droplet 6 - Top center area (elongated)
    final droplet6 = Path();
    droplet6.addOval(Rect.fromCenter(
      center: Offset(width * 0.45, height * 0.03),
      width: width * 0.06,
      height: width * 0.03,
    ));
    path.addPath(droplet6, Offset.zero);

    // Add connecting splash effects - small droplets between main shape and larger droplets
    final splash1 = Path();
    splash1.addOval(Rect.fromCircle(
      center: Offset(width * 0.83, height * 0.2),
      radius: width * 0.015,
    ));
    path.addPath(splash1, Offset.zero);

    final splash2 = Path();
    splash2.addOval(Rect.fromCircle(
      center: Offset(width * 0.18, height * 0.12),
      radius: width * 0.012,
    ));
    path.addPath(splash2, Offset.zero);

    final splash3 = Path();
    splash3.addOval(Rect.fromCircle(
      center: Offset(width * 0.88, height * 0.4),
      radius: width * 0.01,
    ));
    path.addPath(splash3, Offset.zero);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
