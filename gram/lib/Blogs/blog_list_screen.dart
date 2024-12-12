import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'blog_write_screen.dart';
import 'blog_details_screen.dart';

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

  Future<List<Map<String, dynamic>>> _fetchBlogs() async {
    final url = Uri.parse(
        'http://192.168.100.9:5000/get_blogs'); // Replace with your Flask server IP
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  void _addNewBlog(Map<String, dynamic> newBlog) {
    setState(() {
      // Handle adding a new blog if needed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text('Blogs', style: TextStyle(color: Colors.tealAccent)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.tealAccent,
          labelColor: Colors.tealAccent,
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
          BlogListTab(fetchBlogs: _fetchBlogs),
          BlogListTab(fetchBlogs: _fetchBlogs),
          BlogListTab(fetchBlogs: _fetchBlogs),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
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
        icon: Icon(Icons.add, color: Colors.black),
        label: Text(
          'Write Blog',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class BlogListTab extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> Function() fetchBlogs;

  BlogListTab({required this.fetchBlogs});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchBlogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.redAccent),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No blogs available',
              style: TextStyle(color: Colors.white60),
            ),
          );
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
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey.shade900,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      blog['image'] ?? 'assets/images/default.png',
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  title: Text(
                    blog['title'] ?? 'No Title',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        blog['author'] ?? 'No Author',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${blog['date'] ?? 'No Date'} • ${blog['time'] ?? 'No Time'}',
                        style: TextStyle(color: Colors.white54, fontSize: 10),
                      ),
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
