import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'blog_write_screen.dart';
import 'blog_details_screen.dart';

class BlogListScreen extends StatefulWidget {
  const BlogListScreen({super.key});

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
        Uri.parse('http://192.168.100.6:5000/get_blogs'); // Flask server
    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => Map<String, dynamic>.from(item)).toList();
      } catch (e) {
        throw Exception('Failed to parse blogs: $e');
      }
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Blogs', style: TextStyle(color: Colors.tealAccent)),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.tealAccent,
          labelColor: Colors.tealAccent,
          unselectedLabelColor: Colors.white60,
          tabs: const [
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
            MaterialPageRoute(builder: (context) => const BlogWriteScreen()),
          );
          if (newBlog != null) {
            setState(() {}); // Refresh UI if a new blog is added
          }
        },
        backgroundColor: Colors.tealAccent,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          'Write Blog',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}

class BlogListTab extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> Function() fetchBlogs;

  const BlogListTab({super.key, required this.fetchBlogs});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      // Fetching the blogs
      future: fetchBlogs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
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
            String? imageUrl = blog['image_url'];

            // Construct the full image URL if it's relative
            if (imageUrl != null && !imageUrl.startsWith('http')) {
              imageUrl = 'http://192.168.100.6:5000/uploads/1000503625.jpg';
            }

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
                      imageUrl:
                          imageUrl ?? '', // Pass imageUrl for the detail screen
                    ),
                  ),
                );
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                color: Colors.grey.shade900,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 180,
                              errorBuilder: (context, error, stackTrace) {
                                return const SizedBox
                                    .shrink(); // No image if error occurs
                              },
                            )
                          : const SizedBox
                              .shrink(), // No image if imageUrl is null
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog['title'] ?? 'No Title',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            blog['author'] ?? 'No Author',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${blog['date'] ?? 'No Date'} • ${blog['time'] ?? 'No Time'}',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
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
