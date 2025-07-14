import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_dashboard_screen.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'learn_screen.dart';

class SettingsScreen extends StatefulWidget {
  final int selectedTabIndex;
  
  const SettingsScreen({super.key, required this.selectedTabIndex});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = '';
  String userName = '';
  bool notificationsEnabled = true;
  bool soundEnabled = true;
  bool autoSaveResults = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('languageselection') ?? 'English';
      userName = prefs.getString('username') ?? 'Farmer';
      notificationsEnabled = prefs.getBool('notifications') ?? true;
      soundEnabled = prefs.getBool('sound') ?? true;
      autoSaveResults = prefs.getBool('autosave') ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', userName);
    await prefs.setBool('notifications', notificationsEnabled);
    await prefs.setBool('sound', soundEnabled);
    await prefs.setBool('autosave', autoSaveResults);
    await prefs.setString('languageselection', selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2E7D32),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Section
                      _buildProfileSection(),
                      const SizedBox(height: 24),
                      // App Settings
                      _buildAppSettings(),
                      const SizedBox(height: 24),
                      // Preferences
                      _buildPreferences(),
                      const SizedBox(height: 24),
                      // About & Support
                      _buildAboutSupport(),
                      const SizedBox(height: 24),
                      // Danger Zone
                      _buildDangerZone(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFF2E7D32).withOpacity(0.1),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF8BC34A).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              selectedLanguage,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E7D32),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettings() {
    return _buildSection(
      'App Settings',
      [
        _buildSettingItem(
          'Language',
          selectedLanguage,
          Icons.language,
          onTap: _changeLanguage,
        ),
        _buildSwitchItem(
          'Notifications',
          'Receive alerts and updates',
          Icons.notifications,
          notificationsEnabled,
          (value) {
            setState(() {
              notificationsEnabled = value;
            });
            _saveSettings();
          },
        ),
        _buildSwitchItem(
          'Sound Effects',
          'Audio feedback and alerts',
          Icons.volume_up,
          soundEnabled,
          (value) {
            setState(() {
              soundEnabled = value;
            });
            _saveSettings();
          },
        ),
      ],
    );
  }

  Widget _buildPreferences() {
    return _buildSection(
      'Preferences',
      [
        _buildSwitchItem(
          'Auto-save Results',
          'Automatically save scan results',
          Icons.save,
          autoSaveResults,
          (value) {
            setState(() {
              autoSaveResults = value;
            });
            _saveSettings();
          },
        ),
        _buildSettingItem(
          'Camera Quality',
          'High',
          Icons.camera_alt,
          onTap: () {
            // TODO: Camera quality settings
            print('Camera quality settings');
          },
        ),
        _buildSettingItem(
          'Storage',
          'Manage app data',
          Icons.storage,
          onTap: () {
            // TODO: Storage management
            print('Storage management');
          },
        ),
      ],
    );
  }

  Widget _buildAboutSupport() {
    return _buildSection(
      'About & Support',
      [
        _buildSettingItem(
          'Help & Support',
          'Get help and contact support',
          Icons.help,
          onTap: () {
            // TODO: Help & support
            print('Help & support');
          },
        ),
        _buildSettingItem(
          'Privacy Policy',
          'Read our privacy policy',
          Icons.privacy_tip,
          onTap: () {
            // TODO: Privacy policy
            print('Privacy policy');
          },
        ),
        _buildSettingItem(
          'Terms of Service',
          'View terms and conditions',
          Icons.description,
          onTap: () {
            // TODO: Terms of service
            print('Terms of service');
          },
        ),
        _buildSettingItem(
          'App Version',
          '1.0.0',
          Icons.info,
          onTap: () {
            // TODO: Version info
            print('Version info');
          },
        ),
      ],
    );
  }

  Widget _buildDangerZone() {
    return _buildSection(
      'Danger Zone',
      [
        _buildSettingItem(
          'Clear All Data',
          'Remove all scan history',
          Icons.delete,
          color: const Color(0xFFFF5722),
          onTap: _clearAllData,
        ),
        _buildSettingItem(
          'Reset App',
          'Reset to factory settings',
          Icons.refresh,
          color: const Color(0xFFFF5722),
          onTap: _resetApp,
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: children.map((child) {
              final index = children.indexOf(child);
              return Column(
                children: [
                  child,
                  if (index < children.length - 1)
                    Divider(height: 1, color: Colors.grey[200]),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? const Color(0xFF2E7D32)).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: color ?? const Color(0xFF2E7D32),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: color ?? const Color(0xFF1B5E20),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF2E7D32).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF2E7D32),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Color(0xFF1B5E20),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF2E7D32),
      ),
    );
  }

  void _editProfile() {
    TextEditingController nameController = TextEditingController(text: userName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userName = nameController.text;
              });
              _saveSettings();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _changeLanguage() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Language',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('English'),
              trailing: selectedLanguage == 'English' 
                  ? const Icon(Icons.check, color: Color(0xFF2E7D32)) 
                  : null,
              onTap: () {
                setState(() {
                  selectedLanguage = 'English';
                });
                _saveSettings();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Ewe'),
              trailing: selectedLanguage == 'Ewe' 
                  ? const Icon(Icons.check, color: Color(0xFF2E7D32)) 
                  : null,
              onTap: () {
                setState(() {
                  selectedLanguage = 'Ewe';
                });
                _saveSettings();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Twi'),
              trailing: selectedLanguage == 'Twi' 
                  ? const Icon(Icons.check, color: Color(0xFF2E7D32)) 
                  : null,
              onTap: () {
                setState(() {
                  selectedLanguage = 'Twi';
                });
                _saveSettings();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('This will permanently delete all your scan history. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Clear all data
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5722)),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _resetApp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset App'),
        content: const Text('This will reset the app to its initial state. All settings and data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Reset app
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App will be reset')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5722)),
            child: const Text('Reset'),
          ),
        ],
      ),
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
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2E7D32),
        unselectedItemColor: Colors.grey[500],
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        currentIndex: widget.selectedTabIndex,
        items: const [
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
          _handleNavigation(index);
        },
      ),
    );
  }

  void _handleNavigation(int index) {
    if (index == widget.selectedTabIndex) return; // Already on this screen

    // Direct navigation to the selected screen
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeDashboardScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScanScreen(selectedTabIndex: 1)),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryScreen(selectedTabIndex: 2)),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LearnScreen(selectedTabIndex: 3)),
        );
        break;
      case 4:
        // Already on SettingsScreen, do nothing
        break;
    }
  }
}