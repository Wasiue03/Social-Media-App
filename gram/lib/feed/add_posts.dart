import 'dart:io'; // Import for File
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _uploadPost() async {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        backgroundColor: Colors.grey[900],
        elevation: 0,
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
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter your post content...',
                hintStyle: TextStyle(color: Colors.white54),
              ),
              maxLines: 4,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10),
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
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Upload Image'),
              style: ElevatedButton.styleFrom(
                primary: Colors.blueGrey[700],
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadPost,
              child: Text('Post'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
