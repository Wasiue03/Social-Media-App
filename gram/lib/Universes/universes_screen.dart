import 'package:flutter/material.dart';

class UniverseScreen extends StatelessWidget {
  final String username;
  final String imagePath;
  final String description;

  UniverseScreen({
    required this.username,
    required this.imagePath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$username\'s Universe'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(imagePath),
                ),
                SizedBox(width: 16),
                Text(
                  username,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Universe Details:',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            // Add more details about the user's universe here
          ],
        ),
      ),
    );
  }
}
