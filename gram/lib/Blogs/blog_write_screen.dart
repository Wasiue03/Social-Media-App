import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BlogWriteScreen extends StatefulWidget {
  @override
  _BlogWriteScreenState createState() => _BlogWriteScreenState();
}

class _BlogWriteScreenState extends State<BlogWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _submitBlog() async {
    final title = _titleController.text;
    final content = _contentController.text;
    if (title.isNotEmpty && content.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('blogs').add({
          'title': title,
          'content': content,
          'timestamp': Timestamp.now(),
        });
        print('Blog submitted: $title - $content');
        Navigator.pop(context, {'title': title, 'content': content});
      } catch (e) {
        print('Error saving blog: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Write a Blog',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.grey[900]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kToolbarHeight + 20),
                _buildInputField(
                  controller: _titleController,
                  hintText: 'Title',
                ),
                SizedBox(height: 20),
                Expanded(
                  child: _buildInputField(
                    controller: _contentController,
                    hintText: 'Start writing...',
                    maxLines: null,
                    expands: true,
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitBlog,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.tealAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Submit Blog'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    int? maxLines,
    bool expands = false,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: TextField(
          controller: controller,
          style: TextStyle(color: Colors.white, fontSize: 18),
          maxLines: maxLines,
          expands: expands,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
