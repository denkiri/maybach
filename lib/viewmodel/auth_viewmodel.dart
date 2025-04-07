import 'package:flutter/material.dart';
import '../models/signup_model.dart';
import '../service/auth_service.dart';
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool isLoading = false;
  String? errorMessage;
  String? defaultReferralCode;

  Future<bool> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final response = await _authService.login(email, password);

    isLoading = false;
    notifyListeners();

    if (response != null) {
      return true; // Login successful
    } else {
      errorMessage = "Invalid email or password";
      notifyListeners();
      return false;
    }
  }
  Future<bool> register(SignupModel signupData) async {
    isLoading = true;
    notifyListeners();

    final response = await _authService.registerUser(signupData);

    isLoading = false;
    notifyListeners();

    if (response == "Successfully registered") {
      return true; // Registration successful
    } else {
      errorMessage = response;
      notifyListeners();
      return false;
    }
  }
  Future<void> fetchDefaultReferralCode() async {
    isLoading = true;
    notifyListeners();

    try {
      final code = await _authService.getDefaultReferralCode();
      if (code != null) {
        defaultReferralCode = code;
      }
    } catch (e) {
      errorMessage = "Failed to load referral code";
    }

    isLoading = false;
    notifyListeners();
  }

}
