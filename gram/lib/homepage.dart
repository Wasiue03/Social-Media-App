import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profiles/profile2.jpeg'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with profile images
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Replace with the actual count
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/profiles/profile${index}.jpeg'),
                        radius: 30,
                      ),
                    );
                  },
                ),
              ),
              // Explore Top Trending Templates
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Explore Top Trending Templates🔥',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              // Content
              Container(
                height: 300, // Example height
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5, // Replace with the actual count
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200, // Example width
                        color:
                            Colors.grey, // Replace with actual image or content
                        child: Column(
                          children: [
                            Image.asset(
                                'assets/images/content/cont${index}.jpeg'),
                            Text('Template ${index}',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
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
            icon: Icon(Icons.add, color: Colors.white),
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
      ),
    );
  }
}
