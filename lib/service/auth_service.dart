import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/login_response.dart';
import '../models/signup_model.dart';
import '../constants/base_url.dart';
class AuthService {
  final Dio _dio = Dio();

  Future<LoginResponse?> login(String email, String password) async {
    const String url = '${BaseUrl.baseUrl}/account/login';

    try {
      Response response = await _dio.post(url, data: {
        "email": email,
        "password": password,
      });

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);

        // Save tokens in SharedPreferences
        const storage = FlutterSecureStorage();

        await storage.write(key: 'jwt_token', value: loginResponse.jwtToken);
        await storage.write(key: 'refresh_token', value: loginResponse.accessToken);

        return loginResponse;
      }
    } catch (e) {
      print("Login Error: $e");
    }
    return null;
  }
  Future<String?> registerUser(SignupModel signupData) async {
    const String url = '${BaseUrl.baseUrl}/account/register';

    try {
      final response = await _dio.post(
        url,
        data: signupData.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data["details"]; // "Successfully registered"
      } else {
        return response.data["details"] ?? "Registration failed. Please try again.";
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          return e.response!.data["details"] ?? "Something went wrong.";
        } else {
          return "Network error: ${e.message}";
        }
      }
      return "Error: ${e.toString()}";
    }
  }

  Future<String?> getDefaultReferralCode() async {
    const String url = '${BaseUrl.baseUrl}/account/default-referral-code';

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        return response.data["details"]; // Returns the referral code
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response != null) {
          print("Referral code fetch error: ${e.response!.data}");
        } else {
          print("Network error: ${e.message}");
        }
      }
    }
    return null;
  }

}
