import 'package:flutter/material.dart';

class BlogWriteScreen extends StatefulWidget {
  @override
  _BlogWriteScreenState createState() => _BlogWriteScreenState();
}

class _BlogWriteScreenState extends State<BlogWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _publishBlog() {
    // Logic to publish the blog
    String title = _titleController.text;
    String content = _contentController.text;
    if (title.isNotEmpty && content.isNotEmpty) {
      // Publish the blog
      print('Title: $title');
      print('Content: $content');
    } else {
      _showErrorDialog("Title and content cannot be empty.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text("Error", style: TextStyle(color: Colors.redAccent)),
          content: Text(message, style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            TextButton(
              child: Text("OK", style: TextStyle(color: Colors.tealAccent)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Write a Blog'),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _publishBlog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white, fontSize: 24),
              decoration: InputDecoration(
                hintText: 'Enter Title',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
            Divider(color: Colors.white54),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Write your blog here...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.tealAccent,
        child: Icon(Icons.add_a_photo, color: Colors.black),
        onPressed: () {
          // Logic to add images
        },
      ),
    );
  }
}
