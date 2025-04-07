import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../../components/widgets/app_colors.dart';
import '../../models/signup_model.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../../routes.dart';
import '../../components/widgets/backgroud_image.dart';
import '../../components/widgets/footer.dart';

class Signup extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  // List of East African countries for the dropdown
  final List<String> _eastAfricanCountries = [
    'KENYA',
    'UGANDA',
    'TANZANIA'
  ];

  String? _selectedCountry;

  @override
  void initState() {
    super.initState();
    // First load saved promo code, then check if we need default referral code
    _loadSavedPromoCode().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkAndFetchReferralCode();
      });
    });
  }

  Future<void> _loadSavedPromoCode() async {
    try {
      final savedPromoCode = await _secureStorage.read(key: 'promo_code');
      if (savedPromoCode != null && savedPromoCode.isNotEmpty) {
        if (mounted) {
          setState(() {
            _referralController.text = savedPromoCode;
          });
        }
        return; // Exit if we have a saved promo code
      }
    } catch (e) {
      debugPrint('Error loading promo code: $e');
    }
  }

  Future<void> _checkAndFetchReferralCode() async {
    // Only proceed if the referral field is still empty (no saved promo code was found)
    if (_referralController.text.isEmpty) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      await authViewModel.fetchDefaultReferralCode();

      if (authViewModel.defaultReferralCode != null && mounted) {
        setState(() {
          _referralController.text = authViewModel.defaultReferralCode!;
        });
      }
    }
  }

  // Top Navigation Bar with Purple Gradient
  Widget _buildTopNavBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        gradient: AppGradients.bluePurpleGradient,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Login Button
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
          // Register Button
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

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    bool obscureText = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText && !_isPasswordVisible,
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(icon, color: Colors.white, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        suffixIcon: obscureText
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        )
            : null,
      ),
      style: const TextStyle(color: Colors.white, fontSize: 14),
    );
  }

  Widget _buildCountryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCountry,
      dropdownColor: Colors.black.withOpacity(0.9),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Icon(Icons.location_on, color: Colors.white, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      hint: Text(
        'Select Country',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      style: TextStyle(color: Colors.white, fontSize: 14),
      icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
      items: _eastAfricanCountries.map((String country) {
        return DropdownMenuItem<String>(
          value: country,
          child: Text(
            country,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedCountry = newValue;
          _countryController.text = newValue ?? '';
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a country';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Gradient Overlay
          const BackgroundWithGradient(imagePath: "assets/images/maybach.png"),

          Column(
            children: [
              // Top Navigation Bar
              _buildTopNavBar(context),

              // Centered Signup Card
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      width: MediaQuery.of(context).size.width > 600 ? 600 : double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Branding Logo & Name
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

                            // Form Fields in Grid Layout
                            GridView.count(
                              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: 8,
                              mainAxisSpacing: MediaQuery.of(context).size.width > 600 ? 8 : 4,
                              childAspectRatio: MediaQuery.of(context).size.width > 600 ? 3.0 : 4.0,
                              children: [
                                _buildTextField(
                                  icon: Icons.person,
                                  hint: "First Name",
                                  controller: _firstNameController,
                                ),
                                _buildTextField(
                                  icon: Icons.person,
                                  hint: "Last Name",
                                  controller: _lastNameController,
                                ),
                                _buildTextField(
                                  icon: Icons.account_circle,
                                  hint: "Username",
                                  controller: _usernameController,
                                ),
                                _buildTextField(
                                  icon: Icons.email,
                                  hint: "Email Address",
                                  controller: _emailController,
                                ),
                                _buildTextField(
                                  icon: Icons.phone,
                                  hint: "Phone Number",
                                  controller: _phoneController,
                                ),
                                _buildCountryDropdown(),
                                _buildTextField(
                                  icon: Icons.lock,
                                  hint: "Password",
                                  obscureText: true,
                                  controller: _passwordController,
                                ),
                                _buildTextField(
                                  icon: Icons.lock,
                                  hint: "Confirm Password",
                                  obscureText: true,
                                  controller: _confirmPasswordController,
                                ),
                                if (MediaQuery.of(context).size.width > 600)
                                  const SizedBox.shrink(),
                                _buildTextField(
                                  icon: Icons.code,
                                  hint: "Referral Code",
                                  controller: _referralController,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Error Message
                            if (authViewModel.errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Text(
                                  authViewModel.errorMessage!,
                                  style: const TextStyle(color: Colors.red, fontSize: 14),
                                ),
                              ),

                            // Signup Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                onPressed: authViewModel.isLoading
                                    ? null
                                    : () async {
                                  if (_formKey.currentState!.validate()) {
                                    bool success = await authViewModel.register(
                                      SignupModel(
                                        username: _usernameController.text,
                                        firstName: _firstNameController.text,
                                        lastName: _lastNameController.text,
                                        email: _emailController.text,
                                        phoneNumber: _phoneController.text,
                                        country: _countryController.text,
                                        password: _passwordController.text,
                                        confirmPassword: _confirmPasswordController.text,
                                        referralCode: _referralController.text,
                                      ),
                                    );

                                    if (success) {
                                      Navigator.pushReplacementNamed(context, Routes.login);
                                    }
                                  }
                                },
                                child: authViewModel.isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                  "Create Account",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Login Link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Already have an account?",
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pushReplacementNamed(context, Routes.login),
                                  child: const Text(
                                    "Login →",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Footer
              const Footer(),
            ],
          ),
        ],
      ),
    );
  }
}