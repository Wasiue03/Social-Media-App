import 'package:flutter/material.dart';

class BlogDetailScreen extends StatelessWidget {
  final String title;
  final String author;
  final String date;
  final String time;
  final String content;
  final String imageUrl;

  BlogDetailScreen({
    required this.title,
    required this.author,
    required this.date,
    required this.time,
    required this.content,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Read Blog', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imageUrl, fit: BoxFit.cover),
              SizedBox(height: 16),
              Text(title, style: TextStyle(color: Colors.white, fontSize: 24)),
              SizedBox(height: 8),
              Text('$author • $date • $time', style: TextStyle(color: Colors.white60, fontSize: 14)),
              SizedBox(height: 16),
              Text(content, style: TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
