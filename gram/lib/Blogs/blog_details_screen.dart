import 'package:flutter/material.dart';

class BlogDetailScreen extends StatelessWidget {
  final String title;
  final String author;
  final String date;
  final String time;
  final String content;
  final String imageUrl;

  const BlogDetailScreen({
    super.key,
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Read Blog', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imageUrl, fit: BoxFit.cover),
              const SizedBox(height: 16),
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 24)),
              const SizedBox(height: 8),
              Text('$author • $date • $time',
                  style: const TextStyle(color: Colors.white60, fontSize: 14)),
              const SizedBox(height: 16),
              Text(content,
                  style: const TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
