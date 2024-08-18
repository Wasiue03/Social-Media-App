import 'package:flutter/material.dart';
import 'dart:math';

class UniverseScreen extends StatefulWidget {
  final String username;
  final String imagePath;
  final String description;

  UniverseScreen({
    required this.username,
    required this.imagePath,
    required this.description,
  });

  @override
  _UniverseScreenState createState() => _UniverseScreenState();
}

class _UniverseScreenState extends State<UniverseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 60), // Slow down the movement
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildPlanet({
    required String label,
    required double radius,
    required Color color,
    required double distance,
    required void Function() onTap,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        double angle = _animation.value * 2 * pi;
        double offsetX = distance * cos(angle);
        double offsetY = distance * sin(angle);
        return Transform.translate(
          offset: Offset(offsetX, offsetY),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10, // Smaller font size to fit smaller planets
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.username}\'s Universe'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // User's image and name at the center
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(widget.imagePath),
                ),
                SizedBox(height: 10),
                Text(
                  widget.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Planets
          buildPlanet(
            label: 'Earth',
            radius: 20, // Smaller planet size
            color: Colors.blue,
            distance: 110, // Increased distance for spacing
            onTap: () {
              // Navigate to the Music screen
            },
          ),
          buildPlanet(
            label: 'Mars',
            radius: 18, // Smaller planet size
            color: Colors.red,
            distance: 150, // Increased distance for spacing
            onTap: () {
              // Navigate to the Blogs screen
            },
          ),
          buildPlanet(
            label: 'Jupiter',
            radius: 25, // Smaller planet size
            color: Colors.orange,
            distance: 190, // Increased distance for spacing
            onTap: () {
              // Navigate to the Diary screen
            },
          ),
          buildPlanet(
            label: 'Saturn',
            radius: 22, // Smaller planet size
            color: Colors.brown,
            distance: 230, // Increased distance for spacing
            onTap: () {
              // Navigate to the People screen
            },
          ),
          buildPlanet(
            label: 'Uranus',
            radius: 20, // Smaller planet size
            color: Colors.cyan,
            distance: 270, // Increased distance for spacing
            onTap: () {
              // Navigate to the Shopping screen
            },
          ),
          buildPlanet(
            label: 'Neptune',
            radius: 18, // Smaller planet size
            color: Colors.indigo,
            distance: 310, // Increased distance for spacing
            onTap: () {
              // Navigate to the Study screen
            },
          ),
          buildPlanet(
            label: 'Pluto',
            radius: 15, // Smaller planet size
            color: Colors.grey,
            distance: 350, // Increased distance for spacing
            onTap: () {
              // Navigate to the Exercise screen
            },
          ),
        ],
      ),
    );
  }
}
