import 'package:flutter/material.dart';
import 'dart:math';

class UniverseScreen extends StatelessWidget {
  final String username;
  final String imagePath;
  final String description;

  const UniverseScreen({
    super.key,
    required this.username,
    required this.imagePath,
    required this.description,
  });

  // Function to calculate planet position based on angle and distance
  Offset calculatePosition(double angle, double distance, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double offsetX = centerX + distance * cos(angle);
    double offsetY = centerY + distance * sin(angle);
    return Offset(offsetX, offsetY);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double universeWidth = screenSize.width * 3;
    final double universeHeight = screenSize.height * 3;

    return Scaffold(
      appBar: AppBar(
        title: Text('$username\'s Universe'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            width: universeWidth,
            height: universeHeight,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(imagePath),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomPaint(
                  size: Size(universeWidth, universeHeight),
                  painter: OrbitPainter(
                    screenSize: Size(universeWidth, universeHeight),
                    numOrbits: 9, // Adjusted for 9 planets
                  ),
                ),
                Positioned(
                  left: calculatePosition(0, 100, screenSize).dx - 20,
                  top: calculatePosition(0, 100, screenSize).dy - 20,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Music screen
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Center(
                        child: Text(
                          'Earth',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: calculatePosition(pi / 6, 200, screenSize).dx - 18,
                  top: calculatePosition(pi / 6, 200, screenSize).dy - 18,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Blogs screen
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Center(
                        child: Text(
                          'Mars',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: calculatePosition(pi / 3, 300, screenSize).dx - 25,
                  top: calculatePosition(pi / 3, 300, screenSize).dy - 25,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Diary screen
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orange,
                      ),
                      child: const Center(
                        child: Text(
                          'Jupiter',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: calculatePosition(pi / 2, 400, screenSize).dx - 22,
                  top: calculatePosition(pi / 2, 400, screenSize).dy - 22,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the People screen
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.brown,
                      ),
                      child: const Center(
                        child: Text(
                          'Saturn',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: calculatePosition(2 * pi / 3, 500, screenSize).dx - 20,
                  top: calculatePosition(2 * pi / 3, 500, screenSize).dy - 20,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Shopping screen
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.cyan,
                      ),
                      child: const Center(
                        child: Text(
                          'Uranus',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: calculatePosition(5 * pi / 6, 600, screenSize).dx - 18,
                  top: calculatePosition(5 * pi / 6, 600, screenSize).dy - 18,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Study screen
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigo,
                      ),
                      child: const Center(
                        child: Text(
                          'Neptune',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: calculatePosition(pi, 700, screenSize).dx - 15,
                  top: calculatePosition(pi, 700, screenSize).dy - 15,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Exercise screen
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey,
                      ),
                      child: const Center(
                        child: Text(
                          'Pluto',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: calculatePosition(7 * pi / 6, 800, screenSize).dx - 24,
                  top: calculatePosition(7 * pi / 6, 800, screenSize).dy - 24,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Asteroids screen
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.orangeAccent,
                      ),
                      child: const Center(
                        child: Text(
                          'Eris',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrbitPainter extends CustomPainter {
  final Size screenSize;
  final int numOrbits;

  OrbitPainter({
    required this.screenSize,
    required this.numOrbits,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint orbitPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    for (int i = 1; i <= numOrbits; i++) {
      double radius = i * 100; // Distance between orbits
      canvas.drawCircle(Offset(centerX, centerY), radius, orbitPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
