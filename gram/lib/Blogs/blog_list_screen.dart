import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gram/Blogs/blog_details_screen.dart';
import 'package:gram/Blogs/blog_write_screen.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _addNewBlog(Map<String, String> newBlog) {
    setState(() {
      // Handle adding a new blog
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('Blog App', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profiles/profile2.jpeg'),
          ),
          SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.tealAccent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          tabs: [
            Tab(text: 'Featured'),
            Tab(text: 'Latest'),
            Tab(text: 'Trending'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          BlogListTab(),
          BlogListTab(),
          BlogListTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newBlog = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BlogWriteScreen()),
          );
          if (newBlog != null) {
            _addNewBlog(newBlog);
          }
        },
        backgroundColor: Colors.tealAccent,
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class BlogListTab extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _fetchBlogs() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('blogs').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchBlogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No blogs available'));
        }

        final blogs = snapshot.data!;

        return ListView.builder(
          itemCount: blogs.length,
          itemBuilder: (context, index) {
            final blog = blogs[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlogDetailScreen(
                      title: blog['title'] ?? 'No Title',
                      author: blog['author'] ?? 'No Author',
                      date: blog['date'] ?? 'No Date',
                      time: blog['time'] ?? 'No Time',
                      content: blog['content'] ?? 'No Content',
                      imageUrl: blog['image'] ?? 'assets/images/default.png',
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.grey.shade900,
                child: ListTile(
                  leading: Image.network(
                      blog['image'] ?? 'assets/images/default.png'),
                  title: Text(blog['title'] ?? 'No Title',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(blog['author'] ?? 'No Author',
                          style: TextStyle(color: Colors.white60)),
                      Text(
                          '${blog['date'] ?? 'No Date'} • ${blog['time'] ?? 'No Time'}',
                          style: TextStyle(color: Colors.white60)),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
