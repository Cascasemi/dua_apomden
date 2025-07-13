import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with TickerProviderStateMixin {
  late AudioPlayer audioPlayer;
  int? selectedLanguage;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool isAudioAvailable = false;

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
    _initializeAudio();
    _setupAnimations();
    _playInstructionsAudio();
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

  Future<void> _initializeAudio() async {
    try {
      audioPlayer = AudioPlayer();
      isAudioAvailable = true;
      print("Audio player initialized successfully");
    } catch (e) {
      print("Audio initialization error: $e");
      isAudioAvailable = false;
      _showAudioUnavailableMessage();
    }
  }

  void _showAudioUnavailableMessage() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Audio instructions unavailable. Please use visual selection.'),
          backgroundColor: Color(0xFF2E7D32),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _playInstructionsAudio() async {
    if (!isAudioAvailable) {
      print("Audio not available, showing visual message");
      _showAudioUnavailableMessage();
      return;
    }
    
    try {
      print("Playing audio instructions...");
      await Future.delayed(const Duration(seconds: 1)); // 1 second delay as requested
      
      await audioPlayer.play(AssetSource('audio/language_instructions.mp3'));
      print("Audio played successfully");
    } catch (e) {
      print("Audio play error: $e");
      _showAudioUnavailableMessage();
    }
  }

  void _selectLanguage(int languageNumber) {
    setState(() {
      selectedLanguage = languageNumber;
    });

    // Play selection confirmation sound (optional)
    String languageName = languages[languageNumber - 1]['name'];
    print('Selected language: $languageName');

    // Navigate to next screen after a short delay
    Future.delayed(const Duration(seconds: 2), () {
      // TODO: Navigate to main app or next screen
      print('Selected language: $languageName');
    });
  }

  Widget _buildLanguageCircle(int number, String name, Color color) {
    final isSelected = selectedLanguage == number;
    
    return Column(
      children: [
        GestureDetector(
          onTap: () => _selectLanguage(number),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isSelected ? color : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: isSelected ? 4 : 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: isSelected ? 15 : 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : color,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
      ],
    );
  }

  Widget _buildRepeatCircle() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Repeat the audio instructions
            _playInstructionsAudio();
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Color(0xFF8BC34A), // Light Green
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF8BC34A).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '0',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8BC34A),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Repeat',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B5E20),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
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
                      const SizedBox(height: 12),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Repeat instruction circle (0)
                      _buildRepeatCircle(),
                      const SizedBox(height: 20),
                      // First row with 3 circles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLanguageCircle(1, 'English', languages[0]['color']),
                          _buildLanguageCircle(2, 'Twi', languages[1]['color']),
                          _buildLanguageCircle(3, 'Ga', languages[2]['color']),
                        ],
                      ),
                      // Second row with 2 circles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLanguageCircle(4, 'Ewe', languages[3]['color']),
                          _buildLanguageCircle(5, 'Hausa', languages[4]['color']),
                        ],
                      ),
                    ],
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
