// services/loan_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/base_url.dart';
import '../models/loan.dart';
import '../models/loan_request.dart';
import '../models/profile_model.dart';

class LoanService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();

  Future<ProfileModel?> fetchUserProfile() async {
    const String url = '${BaseUrl.baseUrl}/account/user-profile';
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return ProfileModel.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching user profile: $e");
    }
    return null;
  }
  Future<LoanResponse> applyForLoan(LoanRequest request) async {
    const String url = '${BaseUrl.baseUrl}/moneyzone/loan-application';

    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        throw "Authentication tokens not found";
      }

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoanResponse.fromJson(response.data);
      } else {
        throw "Failed to process loan application: ${response.statusCode}";
      }
    } on DioException catch (e) {
      // Catch specific server error message
      if (e.response?.data != null && e.response?.data['details'] != null) {
        throw e.response!.data['details']; // clean, user-friendly error message
      } else {
        throw "An unexpected error occurred while applying for the loan.";
      }
    } catch (e) {
      throw e.toString(); // Propagate unexpected error messages
    }
  }

  Future<LoanListResponse?> fetchLoans({int page = 1, int pageSize = 10}) async {
    const String url = '${BaseUrl.baseUrl}/moneyzone/loan-application';
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return LoanListResponse.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching loans: $e");
    }
    return null;
  }
}