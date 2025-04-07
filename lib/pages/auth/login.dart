import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import '../../components/widgets/app_colors.dart';
import '../../routes.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../../components/widgets/footer.dart';
import '../../components/widgets/backgroud_image.dart';
import 'dart:html' as html;
class Login extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String?promoCode;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForPromoCode();
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }
  void _checkForPromoCode() {
    final fullUrl = html.window.location.href; // Gets full URL including fragment
    final uri = Uri.parse(fullUrl); // Parses everything

    if (uri.hasQuery && uri.queryParameters.containsKey('promo')) {
      setState(() {
        promoCode = uri.queryParameters['promo'];
        if (promoCode != null && promoCode!.isNotEmpty) {
          _secureStorage.write(key: 'promo_code', value: promoCode);
        }

      });
    }
  }

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    bool obscureText = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
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
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, Routes.login),
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
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, Routes.signup),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Register"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundWithGradient(imagePath: "assets/images/maybach.png"),
          Column(
            children: [
              _buildTopNavBar(context),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    width: MediaQuery.of(context).size.width > 600 ? 400 : double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/maybach_logo.png", height: 50),
                        const SizedBox(height: 10),
                        const Text("MAYBACH MOTORS",
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 30),
                        _buildTextField(icon: Icons.email, hint: "Email address", controller: _emailController),
                        const SizedBox(height: 16),
                        _buildTextField(icon: Icons.lock, hint: "Password", obscureText: true, controller: _passwordController),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 14)),
                            onPressed: authViewModel.isLoading
                                ? null
                                : () async {
                              if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
                                _showToast("Email and Password cannot be empty");
                                return;
                              }

                              bool success = await authViewModel.login(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                              );

                              if (success) {
                                // Read the token from secure storage
                                const storage = FlutterSecureStorage();
                                String? jwtToken = await storage.read(key: 'jwt_token');

                                if (jwtToken != null) {
                                  // Decode the token
                                  Map<String, dynamic> decodedToken = JwtDecoder.decode(jwtToken);

                                  // Access roles (assuming it's a List)
                                  List roles = decodedToken['roles'] ?? [];

                                  if (roles.contains("ADMINISTRATOR")) {
                                    Navigator.pushNamed(context, Routes.admin);
                                  } else if (roles.contains("PUBLIC")) {
                                    Navigator.pushNamed(context, Routes.dashboard);
                                  } else {
                                    _showToast("Unknown role. Access denied.");
                                  }
                                } else {
                                  _showToast("Token not found. Please log in again.");
                                }
                              } else {
                                _showToast("Login failed. Please check your credentials and try again.");
                              }
                            },
                            child: authViewModel.isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text("Sign in to account", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, Routes.changePassword),
                          child: const Text("Forgot password?", style: TextStyle(color: Colors.white)),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, Routes.signup),
                              child: const Text("Register →", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Footer(),
            ],
          ),
        ],
      ),
    );
  }
}
