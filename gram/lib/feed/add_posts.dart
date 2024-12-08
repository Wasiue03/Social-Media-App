import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostUploadScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostUploaded;

  PostUploadScreen({required this.onPostUploaded});

  @override
  _PostUploadScreenState createState() => _PostUploadScreenState();
}

class _PostUploadScreenState extends State<PostUploadScreen> {
  final TextEditingController _contentController = TextEditingController();
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _uploadPost() async {
    setState(() {
      _isUploading = true;
    });

    final content = _contentController.text;
    String? imageUrl;

    if (content.isNotEmpty) {
      // Upload image if it exists
      if (_imagePath != null) {
        try {
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('post_images')
              .child(DateTime.now().toString() + '.jpg');

          final uploadTask = storageRef.putFile(File(_imagePath!));
          final snapshot = await uploadTask.whenComplete(() {});
          imageUrl = await snapshot.ref.getDownloadURL();
          print('Image uploaded: $imageUrl');
        } catch (e) {
          print('Error uploading image: $e');
        }
      }

      // Save post data to Firestore
      try {
        final postRef = FirebaseFirestore.instance.collection('posts').doc();
        final post = {
          'user': 'New User', // Replace with actual user information
          'time': Timestamp.now(),
          'content': content,
          'image': imageUrl,
          'postId': postRef.id, // Storing the document ID
        };

        await postRef.set(post);
        widget.onPostUploaded(post);

        print('Post submitted: $content');
        Navigator.pop(context); // Navigate back after upload
      } catch (e) {
        print('Error saving post: $e');
      }
    } else {
      print('Content is empty');
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        actions: [
          // Post button at the top right corner
          TextButton(
            onPressed: _isUploading ? null : _uploadPost,
            child: _isUploading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                : Text(
                    'Post',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What\'s on your mind?',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(height: 10),
            // Content box with image upload button inside
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      hintText: 'Enter your post content...',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    maxLines: 4,
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  // Image upload button inside the content box with "+" icon
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: Colors.blueAccent,
                        size: 30,
                      ),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // If an image is picked, display it
            if (_imagePath != null)
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(_imagePath!),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
