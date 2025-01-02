import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<String?> _uploadImage() async {
    if (_imagePath == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('post_images')
          .child('${DateTime.now().toIso8601String()}.jpg');

      final uploadTask = storageRef.putFile(File(_imagePath!));
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _uploadPost() async {
<<<<<<< HEAD
    final content = _contentController.text;

    if (content.isNotEmpty) {
      String? imageUrl;

      
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

      try {
        
        await FirebaseFirestore.instance.collection('posts').add({
          'user': 'New User', 
          'time': Timestamp.now(),
          'content': content,
          'image': imageUrl,
        });
        print('Post submitted: $content'); 

        widget.onPostUploaded({
          'user': 'New User',
          'time': Timestamp.now(),
          'content': content,
          'image': imageUrl,
        });
        Navigator.pop(context); 
      } catch (e) {
        print('Error saving post: $e');
      }
    } else {
      print('Content is empty');
=======
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      _showSnackbar('Post content cannot be empty');
      return;
>>>>>>> f41f13ea250c2a84334c38ed427ab33e4aefb55e
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

    String? imageUrl = await _uploadImage();

    try {
      final postRef = FirebaseFirestore.instance.collection('posts').doc();
      final post = {
        'username': user.displayName ?? 'Unknown User',
        'userUid': user.uid,
        'time': Timestamp.now(),
        'content': content,
        'image': imageUrl,
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
            // Content box with image upload button inside
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.transparent,
                      border: InputBorder.none,
                      hintText: 'Enter your post content...',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  // Image upload button inside the content box with "+" icon
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(
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
            const SizedBox(height: 20),
            // If an image is picked, display it
            if (_imagePath != null)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
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
