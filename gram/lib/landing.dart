import 'package:flutter/material.dart';

class CreateAndDiscoverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
                'https://example.com/discover.jpg'), // Replace with your image
            SizedBox(height: 20),
            Text(
              'Create & Discover',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Let\'s Go'),
            ),
          ],
        ),
      ),
    );
  }
}
