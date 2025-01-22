import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostUploadScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostUploaded;

  const PostUploadScreen({super.key, required this.onPostUploaded});

  @override
  _PostUploadScreenState createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<PostUploadScreen> {
  final TextEditingController _contentController = TextEditingController();
  bool _isUploading = false;

  Future<void> _uploadPost() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      _showSnackbar('Post content cannot be empty');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showSnackbar('User not authenticated');
      setState(() {
        _isUploading = false;
      });
      return;
    }

    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc();
      final post = {
        'username': user.displayName ?? 'Unknown User',
        'userUid': user.uid,
        'time': Timestamp.now(),
        'content': content,
        'postId': postRef.id, // Storing the document ID
      };

      await postRef.set(post);
      widget.onPostUploaded(post);

      _showSnackbar('Post uploaded successfully');
      Navigator.pop(context); // Navigate back after upload
    } catch (e) {
      print('Error saving post: $e');
      _showSnackbar('Failed to upload post');
    }

    setState(() {
      _isUploading = false;
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Post button at the top right corner
          TextButton(
            onPressed: _isUploading ? null : _uploadPost,
            child: _isUploading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : const Text(
                    'Post',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s on your mind?',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),
            // Content box
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  hintText: 'Enter your post content...',
                  hintStyle: TextStyle(color: Colors.white54),
                ),
                maxLines: 8,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
