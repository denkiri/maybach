import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;

  const TopNavBar({
    super.key,
    this.onLoginPressed,
    this.onRegisterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4B0082),
            Color(0xFF6A0DAD),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Login Button
          OutlinedButton(
            onPressed: onLoginPressed ?? () {}, // Use provided function or do nothing
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white70, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text("Login"),
          ),

          const SizedBox(width: 12),

          // Register Button
          ElevatedButton(
            onPressed: onRegisterPressed ?? () {}, // Use provided function or do nothing
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overlayColor: MaterialStateColor.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.green;
                }
                return Colors.orange.withOpacity(0.1);
              }),
            ),
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }
}
