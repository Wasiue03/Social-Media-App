import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:gram/Blogs/blog_list_screen.dart';
import 'package:gram/User/user_account.dart';
import 'package:gram/feed/add_posts.dart';
import 'package:gram/feed/post_feed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _posts = [];

  void _addPost(Map<String, dynamic> post) {
    setState(() {
      _posts.add(post);
    });
  }

  void _navigateToPostUpload() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostUploadScreen(
          onPostUploaded: _addPost,
        ),
      ),
    );
  }

  void _navigateToUserAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserAccountScreen(),
      ),
    );
  }

  void _navigateToBlogList() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlogListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: _navigateToUserAccount,
            child: CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/profiles/profile2.jpeg'),
            ),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stories Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildStoryItem('Add your story',
                              'assets/images/add_story.png', true),
                          _buildStoryItem('Sophia Larson',
                              'assets/images/story1.png', false),
                          _buildStoryItem('Georgia Rian',
                              'assets/images/story2.png', false),
                          // Add more stories as needed
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Following and Discover Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggleButton('Following', true),
                    _buildToggleButton('Discover', false),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Post Feed
              PostFeed(
                posts: _posts,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.black,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            padding: EdgeInsets.all(16),
            gap: 8,
            onTabChange: (index) {
              if (index == 2) {
                _navigateToPostUpload();
              }
            },
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.add,
                text: 'Add',
              ),
              GButton(
                icon: Icons.favorite,
                text: 'Favorites',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
                onPressed: _navigateToUserAccount,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryItem(String title, String imagePath, bool isAddStory) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
                isAddStory ? Colors.grey.shade800 : Colors.transparent,
            backgroundImage: AssetImage(imagePath),
            child: isAddStory
                ? Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  )
                : null,
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: isSelected ? Colors.yellow : Colors.grey.shade800,
            onPrimary: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () {},
          child: Text(
            text,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
