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
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
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
              // Daily Inspiration Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Inspiration 💡',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            5, // Replace with the actual count of inspirations
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 150,
                              color: Colors.grey.shade800,
                              child: Center(
                                child: Text(
                                  'Inspiration ${index + 1}',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Button for viewing blogs
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.tealAccent, // Button color
                      onPrimary: Colors.black, // Text and icon color
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    icon: Icon(Icons.library_books),
                    label: Text(
                      'Explore Blogs',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: _navigateToBlogList,
                  ),
                ),
              ),
              // Trending Blogs Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trending Blogs 📚',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 300, // Adjust height as needed
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5, // Replace with the actual count
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 200, // Adjust width as needed
                              color: Colors.grey.shade800,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.asset(
                                      'assets/images/blogs/blog${index}.jpeg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Blog Title ${index}',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Short description of Blog ${index}...',
                                      style: TextStyle(color: Colors.white60),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
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
}
