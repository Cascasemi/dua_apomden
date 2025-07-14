import 'package:flutter/material.dart';
import 'home_dashboard_screen.dart';
import 'scan_screen.dart';
import 'learn_screen.dart';
import 'settings_screen.dart';

class HistoryScreen extends StatefulWidget {
  final int selectedTabIndex;
  
  const HistoryScreen({super.key, required this.selectedTabIndex});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedFilter = 'All';
  
  final List<Map<String, dynamic>> scanHistory = [
    {
      'id': '1',
      'cropName': 'Tomato Leaf',
      'status': 'Healthy',
      'isHealthy': true,
      'date': '2 hours ago',
      'confidence': 95,
      'image': 'assets/images/farmerlady.jpg',
    },
    {
      'id': '2',
      'cropName': 'Maize Stem',
      'status': 'Blight Detected',
      'isHealthy': false,
      'date': '4 hours ago',
      'confidence': 88,
      'image': 'assets/images/farmerlady.jpg',
    },
    {
      'id': '3',
      'cropName': 'Cocoa Pod',
      'status': 'Healthy',
      'isHealthy': true,
      'date': 'Yesterday',
      'confidence': 92,
      'image': 'assets/images/farmerlady.jpg',
    },
    {
      'id': '4',
      'cropName': 'Rice Leaf',
      'status': 'Rust Disease',
      'isHealthy': false,
      'date': '2 days ago',
      'confidence': 85,
      'image': 'assets/images/farmerlady.jpg',
    },
    {
      'id': '5',
      'cropName': 'Cassava Leaf',
      'status': 'Healthy',
      'isHealthy': true,
      'date': '3 days ago',
      'confidence': 97,
      'image': 'assets/images/farmerlady.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredHistory = _getFilteredHistory();
    
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Scan History',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF2E7D32),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () {
              // TODO: Implement search
              print('Search history');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Tabs
            _buildFilterTabs(),
            
            // Statistics Summary
            _buildStatsSummary(),
            
            // History List
            Expanded(
              child: filteredHistory.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredHistory.length,
                      itemBuilder: (context, index) {
                        return _buildHistoryItem(filteredHistory[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Healthy', 'Diseased', 'Today'];
    
    return Container(
      margin: EdgeInsets.all(16),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = selectedFilter == filter;
          
          return Container(
            margin: EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Color(0xFF2E7D32).withOpacity(0.2),
              labelStyle: TextStyle(
                color: isSelected ? Color(0xFF2E7D32) : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? Color(0xFF2E7D32) : Colors.grey[300]!,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSummary() {
    final totalScans = scanHistory.length;
    final healthyScans = scanHistory.where((scan) => scan['isHealthy']).length;
    final diseasedScans = totalScans - healthyScans;
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
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
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem('Total Scans', totalScans.toString(), Color(0xFF2E7D32)),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Expanded(
            child: _buildStatItem('Healthy', healthyScans.toString(), Color(0xFF8BC34A)),
          ),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          Expanded(
            child: _buildStatItem('Diseased', diseasedScans.toString(), Color(0xFFFF8F00)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> scan) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
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
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(scan['image']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          scan['cropName'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  scan['isHealthy'] ? Icons.check_circle : Icons.warning,
                  color: scan['isHealthy'] ? Color(0xFF8BC34A) : Color(0xFFFF8F00),
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  scan['status'],
                  style: TextStyle(
                    color: scan['isHealthy'] ? Color(0xFF8BC34A) : Color(0xFFFF8F00),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Confidence: ${scan['confidence']}%',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              scan['date'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            SizedBox(height: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
        onTap: () {
          _showScanDetails(scan);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No scan history found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start scanning crops to see your history here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredHistory() {
    switch (selectedFilter) {
      case 'Healthy':
        return scanHistory.where((scan) => scan['isHealthy']).toList();
      case 'Diseased':
        return scanHistory.where((scan) => !scan['isHealthy']).toList();
      case 'Today':
        return scanHistory.where((scan) => scan['date'].contains('hour')).toList();
      default:
        return scanHistory;
    }
  }

  void _showScanDetails(Map<String, dynamic> scan) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 24),
            Text(
              scan['cropName'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  scan['isHealthy'] ? Icons.check_circle : Icons.warning,
                  color: scan['isHealthy'] ? Color(0xFF8BC34A) : Color(0xFFFF8F00),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  scan['status'],
                  style: TextStyle(
                    fontSize: 18,
                    color: scan['isHealthy'] ? Color(0xFF8BC34A) : Color(0xFFFF8F00),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Confidence: ${scan['confidence']}%',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: View full report
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('View Report'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Share results
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF2E7D32),
                      side: BorderSide(color: Color(0xFF2E7D32)),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Share'),
                  ),
                ),
              ],
            ),
          ],
        ),
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
        currentIndex: widget.selectedTabIndex,
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
          MaterialPageRoute(builder: (context) => HomeDashboardScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScanScreen(selectedTabIndex: 1)),
        );
        break;
      case 2:
        // Already on HistoryScreen, do nothing
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LearnScreen(selectedTabIndex: 3)),
        );
        break;
      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SettingsScreen(selectedTabIndex: 4)),
        );
        break;
    }
  }
}
