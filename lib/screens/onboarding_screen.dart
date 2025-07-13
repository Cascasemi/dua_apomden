import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String selectedLanguage = '';
  PageController _pageController = PageController();
  int currentPage = 0;

  final List<OnboardingPageData> onboardingPages = [
    OnboardingPageData(
      icon: Icons.camera_alt,
      title: 'Capture Crop Images',
      description: 'Take clear photos of your crops to detect diseases using our advanced AI technology.',
      color: Color(0xFF2E7D32),
    ),
    OnboardingPageData(
      icon: Icons.search,
      title: 'AI-Powered Analysis',
      description: 'Our intelligent system analyzes your crop images and provides accurate disease detection results.',
      color: Color(0xFF4CAF50),
    ),
    OnboardingPageData(
      icon: Icons.healing,
      title: 'Get Treatment Solutions',
      description: 'Receive personalized treatment recommendations and expert advice for your crop diseases.',
      color: Color(0xFF8BC34A),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('languageselection') ?? 'English';
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
                setState(() {
                  currentPage = page;
                });
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
              color: Color(0xFF1B5E20).withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingPageData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
