import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  FlutterTts flutterTts = FlutterTts();
  int? selectedLanguage;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<Map<String, dynamic>> languages = [
    {
      'number': 1,
      'name': 'English',
      'color': Color(0xFF2E7D32), // Forest Green
      'icon': Icons.language,
    },
    {
      'number': 2,
      'name': 'Twi',
      'color': Color(0xFF8BC34A), // Light Green
      'icon': Icons.translate,
    },
    {
      'number': 3,
      'name': 'Ga',
      'color': Color(0xFF4CAF50), // Medium Green
      'icon': Icons.speaker_notes,
    },
    {
      'number': 4,
      'name': 'Ewe',
      'color': Color(0xFF689F38), // Olive Green
      'icon': Icons.chat_bubble,
    },
    {
      'number': 5,
      'name': 'Hausa',
      'color': Color(0xFF388E3C), // Vibrant Green
      'icon': Icons.record_voice_over,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _setupAnimations();
    _speakInstructions();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _scaleController.forward();
    });
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.8);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _speakInstructions() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await flutterTts.speak(
        "Press 1 for English, Press 2 for Twi, Press 3 for Ga, Press 4 for Ewe and 5 for Hausa");
  }

  void _selectLanguage(int languageNumber) {
    setState(() {
      selectedLanguage = languageNumber;
    });

    // Speak the selected language
    String languageName = languages[languageNumber - 1]['name'];
    flutterTts.speak("You selected $languageName");

    // Navigate to next screen after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      // TODO: Navigate to main app or next screen
      print('Selected language: $languageName');
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9), // Very Light Green background
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Header Section
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF2E7D32).withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.language,
                          size: 50,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Choose Your Language',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B5E20),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Select your preferred language for the app',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF1B5E20).withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // Language Options
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: languages.length,
                    itemBuilder: (context, index) {
                      final language = languages[index];
                      final isSelected = selectedLanguage == language['number'];
                      
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: GestureDetector(
                          onTap: () => _selectLanguage(language['number']),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? language['color'] 
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: language['color'],
                                width: isSelected ? 3 : 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: language['color'].withOpacity(0.3),
                                  blurRadius: isSelected ? 15 : 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Number Circle
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? Colors.white 
                                        : language['color'],
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${language['number']}',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected 
                                            ? language['color'] 
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Language Icon
                                Icon(
                                  language['icon'],
                                  size: 30,
                                  color: isSelected 
                                      ? Colors.white 
                                      : language['color'],
                                ),
                                const SizedBox(height: 8),
                                // Language Name
                                Text(
                                  language['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected 
                                        ? Colors.white 
                                        : language['color'],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Continue Button (only show when language is selected)
                if (selectedLanguage != null) ...[
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    opacity: selectedLanguage != null ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to main app
                          print('Continue with selected language');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2E7D32),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
