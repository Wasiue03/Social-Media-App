import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostAdded;

  AddPostScreen({required this.onPostAdded});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  void _submitPost() {
    final String content = _contentController.text;
    if (content.isEmpty) return; // Handle empty content

    final newPost = {
      'user': 'User ${DateTime.now().millisecondsSinceEpoch}', // Example user
      'time': DateTime.now(),
      'content': content,
      'image': _image != null ? _image!.path : null, // Store image path
    };

    widget.onPostAdded(newPost);

    Navigator.pop(context); // Return to the feed screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Post Content',
                filled: true,
                fillColor: Colors.grey.shade800,
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 16.0),
            _image != null
                ? Image.file(File(_image!.path))
                : ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick an Image'),
                  ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Submit Post'),
            ),
          ],
        ),
      ),
    );
  }
}
