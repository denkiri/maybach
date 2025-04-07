import 'package:flutter/material.dart';
class BackgroundWithGradient extends StatelessWidget {
  final String imagePath;
  final double opacity;

  const BackgroundWithGradient({
    super.key,
    required this.imagePath,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A001A).withOpacity(opacity),
                  Color(0xFF333333).withOpacity(opacity),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}