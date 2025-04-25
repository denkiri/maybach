import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/base_url.dart';
import '../models/account_respons.dart';
import '../models/deposit_history.dart';
import '../models/result.dart';

class AccountsService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();

  Future<AccountsResponse?> fetchAccounts({int page = 1, int pageSize = 10}) async {
    const String url = '${BaseUrl.baseUrl}/account/list-users';
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
        return AccountsResponse.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching accounts: $e");
    }
    return null;
  }
  Future<Result> manageUser(String userId, String action) async {
    const String url = '${BaseUrl.baseUrl}/account/manage-user';
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        return Result(success: false, message: "Error: Missing tokens");
      }

      Response response = await _dio.post(
        url,
        data: {
          "user": userId,
          "action": action,
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
        return Result(success: true, message: response.data['details'] ?? "User managed successfully");
      } else {
        return Result(success: false, message: "Error: Unexpected response from server");
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        return Result(success: false, message: e.response?.data['details'] ?? "An error occurred");
      }
      return Result(success: false, message: "Error managing user: ${e.toString()}");
    }
  }
  Future<DepositHistoryResponse?> fetchUserDepositHistory(String userId) async {
    const String url = '${BaseUrl.baseUrl}/account/user-deposit-history';

    try {
      // Read tokens
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      // Make the request
      Response response = await _dio.get(
        url,
        queryParameters: {'user_id': userId},
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
      );

      // Check if response is successful
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return DepositHistoryResponse.fromJson(data);
      } else {
        print("Failed to fetch deposit history: ${response.statusCode}");
      }
    } catch (e, stackTrace) {
      print("Error fetching deposit history: $e");
      print("Stack trace: $stackTrace");
    }

    return null;
  }

}