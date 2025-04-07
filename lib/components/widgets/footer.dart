import 'package:flutter/material.dart';

import 'app_colors.dart';

class Footer extends StatelessWidget {
  final String text;
  const Footer({
    super.key,
    this.text = "© Copyright 2025 Maybach Motors | All rights reserved",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: AppGradients.bluePurpleGradient,
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
