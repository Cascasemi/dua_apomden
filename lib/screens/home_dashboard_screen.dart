import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'learn_screen.dart';
import 'settings_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  String selectedLanguage = '';
  String userName = 'Farmer'; // Default name
  int todayScans = 3;
  int healthyPercentage = 85;
  int diseasesFound = 2;
  int pendingTreatments = 1;
  int currentTabIndex = 0;

  // Navigation to individual screens
  void _navigateToScreen(int tabIndex) async {
    Widget targetScreen;
    
    switch (tabIndex) {
      case 1:
        targetScreen = ScanScreen(selectedTabIndex: tabIndex);
        break;
      case 2:
        targetScreen = HistoryScreen(selectedTabIndex: tabIndex);
        break;
      case 3:
        targetScreen = LearnScreen(selectedTabIndex: tabIndex);
        break;
      case 4:
        targetScreen = SettingsScreen(selectedTabIndex: tabIndex);
        break;
      default:
        return; // Stay on home screen
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );

    // Handle return value to update selected tab
    if (result != null && result is int) {
      setState(() {
        currentTabIndex = result;
      });
    }
  } // Track current tab

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('languageselection') ?? 'English';
      userName = prefs.getString('username') ?? 'Farmer';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9), // Very Light Green background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              SizedBox(height: 20),
              
              // Primary Scan Action Card
              _buildPrimaryScanCard(),
              SizedBox(height: 20),
              
              // Quick Stats Dashboard
              _buildQuickStats(),
              SizedBox(height: 20),
              
              // Recent Activity Feed
              _buildRecentActivity(),
              SizedBox(height: 20),
              
              // Quick Actions Grid
              _buildQuickActionsGrid(),
              SizedBox(height: 20),
              
              // Featured Content
              _buildFeaturedContent(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2E7D32).withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF8BC34A).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  selectedLanguage,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Weather Widget
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF2E7D32).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.wb_sunny,
                  color: Color(0xFF2E7D32),
                  size: 24,
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '28°C • Sunny',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    Text(
                      'Good conditions for farming',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryScanCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E7D32),
            Color(0xFF4CAF50),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2E7D32).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.camera_alt,
            size: 64,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'SCAN CROP FOR DISEASES',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Tap to capture and analyze',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _navigateToScreen(1); // Navigate to scan screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF2E7D32),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Start Scanning',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _navigateToScreen(2), // Navigate to history
                child: _buildStatCard(
                  'Scans',
                  todayScans.toString(),
                  Icons.camera_alt,
                  Color(0xFF4CAF50),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _navigateToScreen(2), // Navigate to history
                child: _buildStatCard(
                  'Healthy',
                  '$healthyPercentage%',
                  Icons.check_circle,
                  Color(0xFF8BC34A),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _navigateToScreen(2), // Navigate to history
                child: _buildStatCard(
                  'Issues',
                  diseasesFound.toString(),
                  Icons.warning,
                  Color(0xFFFF8F00),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _navigateToScreen(3), // Navigate to learn screen
                child: _buildStatCard(
                  'Treatments',
                  pendingTreatments.toString(),
                  Icons.healing,
                  Color(0xFF689F38),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            TextButton(
              onPressed: () {
                _navigateToScreen(2); // Navigate to history screen
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem('Tomato Leaf', 'Healthy', true, '2 hours ago'),
              Divider(height: 1),
              _buildActivityItem('Maize Stem', 'Blight Detected', false, '4 hours ago'),
              Divider(height: 1),
              _buildActivityItem('Cocoa Pod', 'Healthy', true, 'Yesterday'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String cropName, String status, bool isHealthy, String time) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: isHealthy ? Color(0xFF8BC34A).withOpacity(0.2) : Color(0xFFFF8F00).withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isHealthy ? Icons.check_circle : Icons.warning,
          color: isHealthy ? Color(0xFF8BC34A) : Color(0xFFFF8F00),
          size: 24,
        ),
      ),
      title: Text(
        cropName,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1B5E20),
        ),
      ),
      subtitle: Text(
        status,
        style: TextStyle(
          color: isHealthy ? Color(0xFF8BC34A) : Color(0xFFFF8F00),
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Text(
        time,
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
        ),
      ),
      onTap: () {
        _navigateToScreen(2); // Navigate to history for details
      },
    );
  }

  Widget _buildQuickActionsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: _buildActionButton('Scan', Icons.camera_alt, Color(0xFF2E7D32))),
                  SizedBox(width: 12),
                  Expanded(child: _buildActionButton('Stats', Icons.bar_chart, Color(0xFF4CAF50))),
                  SizedBox(width: 12),
                  Expanded(child: _buildActionButton('Guide', Icons.book, Color(0xFF8BC34A))),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildActionButton('Alerts', Icons.notifications, Color(0xFFFF8F00))),
                  SizedBox(width: 12),
                  Expanded(child: _buildActionButton('Track', Icons.trending_up, Color(0xFF689F38))),
                  SizedBox(width: 12),
                  Expanded(child: _buildActionButton('Settings', Icons.settings, Colors.grey[600]!)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        switch (label) {
          case 'Scan':
            _navigateToScreen(1);
            break;
          case 'Stats':
            _navigateToScreen(2); // Navigate to history for stats
            break;
          case 'Guide':
            _navigateToScreen(3); // Navigate to learn screen
            break;
          case 'Settings':
            _navigateToScreen(4);
            break;
          default:
            print('$label tapped');
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Tips',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8BC34A).withOpacity(0.2),
                Color(0xFF4CAF50).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Color(0xFF8BC34A).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Color(0xFF2E7D32),
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Seasonal Tip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Early morning is the best time to check for crop diseases. The cool temperature and good lighting help identify issues clearly.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1B5E20),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to tips page
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF2E7D32),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Learn More →',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey[500],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        currentIndex: currentTabIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // Stay on home screen
            setState(() {
              currentTabIndex = 0;
            });
          } else {
            // Navigate to individual screen
            _navigateToScreen(index);
          }
        },
      ),
    );
  }
}
