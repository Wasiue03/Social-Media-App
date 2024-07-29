import 'package:flutter/material.dart';

class UserAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Center(
            child: const Text('User Account',
                style: TextStyle(color: Colors.white))),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/images/profiles/profile2.jpeg'),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Username',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bio goes here...',
                    style: TextStyle(color: Colors.white60),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white54),
            GridView.builder(
              padding: EdgeInsets.all(16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: 9, // Replace with actual post count
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey.shade800,
                  // child: Image.asset(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
