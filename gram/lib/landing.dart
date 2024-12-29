import 'package:flutter/material.dart';

class CreateAndDiscoverPage extends StatelessWidget {
  const CreateAndDiscoverPage({super.key});

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
            const SizedBox(height: 20),
            const Text(
              'Create & Discover',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Let\'s Go'),
            ),
          ],
        ),
      ),
    );
  }
}
