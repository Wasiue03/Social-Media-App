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
    final url =
        Uri.parse('http://192.168.100.9:5000/get_blogs'); // Flask server
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        // Parse the response body as a list of maps
        List<dynamic> data = json.decode(response.body);

        // Safely map each item as a Map<String, dynamic>
        return data.map((item) {
          if (item is Map<String, dynamic>) {
            return item; // It's already a Map, so return it
          } else {
            // If the item is not a Map, handle this case
            throw FormatException('Item is not a Map');
          }
        }).toList();
      } catch (e) {
        // Handle any issues that occur during decoding
        throw Exception('Failed to parse blogs: $e');
      }
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
            String? imageUrl = blog['image_url']; // Assuming image_url field

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
                      imageUrl: imageUrl ?? 'assets/images/content/cont0.png',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Thumbnail image
                          imageUrl != null && imageUrl.startsWith('http')
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                )
                              : imageUrl != null
                                  ? Image.memory(
                                      base64Decode(imageUrl),
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                    )
                                  : Image.asset(
                                      'assets/images/default.png',
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                    ),
                          SizedBox(width: 16),
                          // Blog text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                blog['title'] ?? 'No Title',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                blog['author'] ?? 'No Author',
                                style: TextStyle(color: Colors.white70),
                              ),
                              SizedBox(height: 4),
                              Text(
                                '${blog['date'] ?? 'No Date'} • ${blog['time'] ?? 'No Time'}',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
