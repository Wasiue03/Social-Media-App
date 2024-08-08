import 'package:flutter/material.dart';
import 'package:gram/Blogs/blog_details_screen.dart';
import 'package:gram/Blogs/blog_write_screen.dart';

class BlogListScreen extends StatefulWidget {
  @override
  _BlogListScreenState createState() => _BlogListScreenState();
}

class _BlogListScreenState extends State<BlogListScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Map<String, String>> blogs = [
    {
      'title': 'Getting my first UI/UX Design Internship',
      'author': 'Jane Doe',
      'date': 'June 1, 2023',
      'time': '5 min read',
      'image': 'assets/images/blogs/blog1.jpeg',
    },
    {
      'title': 'The Worst Career Mistakes Junior UX Designers Make',
      'author': 'John Smith',
      'date': 'June 3, 2023',
      'time': '4 min read',
      'image': 'assets/images/blogs/blog2.jpeg',
    },
    {
      'title': 'You\'re not Lazy, Bored or Unmotivated',
      'author': 'Anna Johnson',
      'date': 'June 5, 2023',
      'time': '6 min read',
      'image': 'assets/images/blogs/blog3.jpeg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void _addNewBlog(Map<String, String> newBlog) {
    setState(() {
      blogs.add(newBlog);
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
          BlogListTab(blogs: blogs),
          BlogListTab(blogs: blogs),
          BlogListTab(blogs: blogs),
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
  final List<Map<String, String>> blogs;

  BlogListTab({required this.blogs});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blogs.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlogDetailScreen(
                  title: blogs[index]['title']!,
                  author: blogs[index]['author']!,
                  date: blogs[index]['date']!,
                  time: blogs[index]['time']!,
                  content: 'This is the content of the blog post.',
                  imageUrl: blogs[index]['image']!,
                ),
              ),
            );
          },
          child: Card(
            color: Colors.grey.shade900,
            child: ListTile(
              leading: Image.asset(blogs[index]['image']!),
              title: Text(blogs[index]['title']!,
                  style: TextStyle(color: Colors.white)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(blogs[index]['author']!,
                      style: TextStyle(color: Colors.white60)),
                  Text('${blogs[index]['date']} • ${blogs[index]['time']}',
                      style: TextStyle(color: Colors.white60)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
