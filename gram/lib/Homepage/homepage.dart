import 'package:flutter/material.dart';
import 'package:gram/Blogs/blog_list_screen.dart';
import 'package:gram/Drawer/Drawer.dart';
import 'package:gram/Profile/user_profile.dart';
import 'package:gram/Universes/universes_screen.dart';
import 'package:gram/feed/post_feed.dart';
import 'package:gram/feed/add_posts.dart';

import 'package:firebase_auth/firebase_auth.dart'; // Import for Firebase Authentication

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  User? _currentUser; // Firebase User

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser; // Get the current user
  }

  final List<Widget> _screens = [
    const PostFeed(), // Home Screen
    PostUploadScreen(onPostUploaded: (post) {}), // Add Post Screen
  ];

  void _onDrawerMenuSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 1) {
      // Handle settings navigation, if needed
      print('Navigate to Settings');
    }
  }

  void _navigateToUserAccount() {}

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey.shade800,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUniverseCard(
      String username, String imagePath, String universeDescription) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UniverseScreen(
              username: username,
              imagePath: imagePath,
              description: universeDescription,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.grey.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imagePath),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    universeDescription,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: _navigateToUserAccount,
            child: const CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/profiles/profile2.jpeg'),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: CustomDrawer(
        onMenuItemSelected: _onDrawerMenuSelected,
        onLogout: () {
          Navigator.pushReplacementNamed(context, '/signin');
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Universe Cards Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildUniverseCard(
                              'Sophia Larson',
                              'assets/images/profiles/profile1.jpeg',
                              'Loves traveling and photography.'),
                          _buildUniverseCard(
                              'Georgia Rian',
                              'assets/images/profiles/profile2.jpeg',
                              'Tech enthusiast and bookworm.'),
                          _buildUniverseCard(
                              'Alex Johnson',
                              'assets/images/profiles/profile3.jpeg',
                              'Music lover and foodie.'),
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
                    _buildToggleButton('Following', true, () {
                      // Handle Following button action
                    }),
                    _buildToggleButton('Discover', false, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const BlogListScreen(), // Navigate to BlogsScreen
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Post Feed
              const PostFeed(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.white),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update current screen index
          });

          // Navigate to the Add Post screen
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PostUploadScreen(onPostUploaded: (post) {})),
            );
          }

          // Navigate to Profile screen
          if (index == 4) {
            if (_currentUser != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileScreen(userId: _currentUser!.uid),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("No user logged in."),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
