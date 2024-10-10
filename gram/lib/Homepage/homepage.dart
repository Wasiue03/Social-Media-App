import 'package:flutter/material.dart';
import 'package:gram/Universes/universes_screen.dart';
import 'package:gram/feed/post_feed.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
  void _navigateToUserAccount() {
    
  }

  
  Widget _buildToggleButton(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
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

  // Method to build a universe card widget
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
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    universeDescription,
                    style: TextStyle(color: Colors.white70, fontSize: 12),
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
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Menu', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(color: Colors.black),
            ),
            ListTile(
              title: Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            ListTile(
              title: Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {},
            ),
            // Add more drawer items here
          ],
        ),
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
                    Container(
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
                          // Add more universe cards as needed
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
              PostFeed(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: [
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
          // Handle navigation based on the tapped index
        },
      ),
    );
  }
}
