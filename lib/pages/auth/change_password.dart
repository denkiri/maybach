import 'package:flutter/material.dart';

import '../../components/widgets/app_colors.dart';
import '../../components/widgets/backgroud_image.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePassword> {
  bool _isPasswordVisible = false;

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText && !_isPasswordVisible,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(icon, color: Colors.white),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: obscureText
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
      ),
      style: const TextStyle(color: Colors.white),
    );
  }


  Widget _buildTopNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        gradient: AppGradients.bluePurpleGradient,
      ), // Solid color instead of gradient
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Login Button
          OutlinedButton(
            onPressed: () {},
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Solid orange color
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
              // Add hover/focus effects
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


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            const BackgroundWithGradient(imagePath: "assets/images/maybach.png"),


            // Page Content
            Column(
              children: [

                _buildTopNavBar(context),

                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      width: MediaQuery.of(context).size.width > 600 ? 400 : double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Image.asset(
                                "assets/images/maybach_logo.png",
                                height: 50,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "MAYBACH MOTORS",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          _buildTextField(
                            icon: Icons.email,
                            hint: "Email address",
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: () {},
                              child: const Text(
                                "Send Reset Code",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                // Footer with Purple Gradient
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: AppGradients.bluePurpleGradient,
                  ),
                  child: const Center(
                    child: Text(
                      "© Copyright 2025 Maybach Motors | All rights reserved",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
