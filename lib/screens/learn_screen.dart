import 'package:flutter/material.dart';
import 'home_dashboard_screen.dart';
import 'scan_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class LearnScreen extends StatefulWidget {
  final int selectedTabIndex;
  
  const LearnScreen({super.key, required this.selectedTabIndex});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final List<Map<String, dynamic>> learningContent = [
    {
      'title': 'Common Crop Diseases',
      'subtitle': 'Identify diseases in your crops',
      'icon': Icons.local_hospital,
      'color': Color(0xFFFF8F00),
      'articles': 12,
    },
    {
      'title': 'Prevention Tips',
      'subtitle': 'Keep your crops healthy',
      'icon': Icons.shield,
      'color': Color(0xFF8BC34A),
      'articles': 8,
    },
    {
      'title': 'Treatment Methods',
      'subtitle': 'Effective disease treatments',
      'icon': Icons.healing,
      'color': Color(0xFF2E7D32),
      'articles': 15,
    },
    {
      'title': 'Seasonal Guide',
      'subtitle': 'Farming by season',
      'icon': Icons.calendar_today,
      'color': Color(0xFF4CAF50),
      'articles': 6,
    },
  ];

  final List<Map<String, dynamic>> recentArticles = [
    {
      'title': 'Early Detection of Tomato Blight',
      'category': 'Disease Prevention',
      'readTime': '5 min read',
      'image': 'assets/images/farmerlady.jpg',
      'isBookmarked': true,
    },
    {
      'title': 'Organic Pesticides for Maize',
      'category': 'Treatment',
      'readTime': '7 min read',
      'image': 'assets/images/farmerlady.jpg',
      'isBookmarked': false,
    },
    {
      'title': 'Best Practices for Rice Farming',
      'category': 'General',
      'readTime': '4 min read',
      'image': 'assets/images/farmerlady.jpg',
      'isBookmarked': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F8E9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Learn & Grow',
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
              Icons.bookmark,
              color: Color(0xFF2E7D32),
            ),
            onPressed: () {
              // TODO: Show bookmarked articles
              print('Show bookmarks');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              _buildSearchBar(),
              SizedBox(height: 24),
              
              // Learning Categories
              _buildLearningCategories(),
              SizedBox(height: 24),
              
              // Featured Article
              _buildFeaturedArticle(),
              SizedBox(height: 24),
              
              // Recent Articles
              _buildRecentArticles(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search articles, diseases, treatments...',
          prefixIcon: Icon(
            Icons.search,
            color: Color(0xFF2E7D32),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: TextStyle(color: Colors.grey[500]),
        ),
        onSubmitted: (value) {
          // TODO: Implement search
          print('Search: $value');
        },
      ),
    );
  }

  Widget _buildLearningCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: learningContent.length,
          itemBuilder: (context, index) {
            final category = learningContent[index];
            return _buildCategoryCard(category);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to category articles
        print('Navigate to ${category['title']}');
      },
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: category['color'].withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: category['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                category['icon'],
                color: category['color'],
                size: 24,
              ),
            ),
            SizedBox(height: 12),
            Text(
              category['title'],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            SizedBox(height: 4),
            Text(
              category['subtitle'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${category['articles']} articles',
              style: TextStyle(
                fontSize: 11,
                color: category['color'],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedArticle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Article',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        SizedBox(height: 16),
        Container(
          width: double.infinity,
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
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/images/farmerlady.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF2E7D32),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'FEATURED',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Understanding Crop Disease Patterns in Ghana',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learn about the most common crop diseases affecting farmers in Ghana and how to identify them early for better crop management.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '10 min read',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Open featured article
                            print('Open featured article');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Read Now',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentArticles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Articles',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: View all articles
                print('View all articles');
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
        SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: recentArticles.length,
          itemBuilder: (context, index) {
            return _buildArticleItem(recentArticles[index]);
          },
        ),
      ],
    );
  }

  Widget _buildArticleItem(Map<String, dynamic> article) {
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
              image: AssetImage(article['image']),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          article['title'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              article['category'],
              style: TextStyle(
                color: Color(0xFF2E7D32),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              article['readTime'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            article['isBookmarked'] ? Icons.bookmark : Icons.bookmark_border,
            color: article['isBookmarked'] ? Color(0xFF2E7D32) : Colors.grey[400],
          ),
          onPressed: () {
            setState(() {
              article['isBookmarked'] = !article['isBookmarked'];
            });
          },
        ),
        onTap: () {
          // TODO: Open article
          print('Open article: ${article['title']}');
        },
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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HistoryScreen(selectedTabIndex: 2)),
        );
        break;
      case 3:
        // Already on LearnScreen, do nothing
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
