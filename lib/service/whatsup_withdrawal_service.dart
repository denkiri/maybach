// service/whatsup_withdrawal_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_projects/service/unlock_exemptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/base_url.dart';
import '../models/withdrawal_request.dart';
import '../models/withdrawal_list_response.dart';
import '../models/unlock_response.dart';
class PaymentService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();

  Future<WithdrawResponse> makeWithdrawal(WithdrawRequest request) async {
    const String baseUrl = "${BaseUrl.baseUrl}/payment/withdraw";
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      final response = await _dio.post(
        baseUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
        data: request.toJson(),
      );

      // Handle successful response (200)
      if (response.statusCode == 200) {
        return WithdrawResponse.fromJson(response.data);
      }
      // Handle client error (400) with server message
      else if (response.statusCode == 400) {
        final errorData = response.data;
        if (errorData is Map && errorData.containsKey('details')) {
          throw UnlockException(errorData['details']);
        } else {
          throw UnlockException('Failed to process withdrawal');
        }
      }
      // Handle other status codes
      else {
        throw UnlockException('Failed to process withdrawal (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('details')) {
          throw UnlockException(errorData['details']);
        }
      }
      throw UnlockException('Network error: ${e.message}');
    } catch (e) {
      throw UnlockException('Unexpected error: ${e.toString()}');
    }
  }

  Future<WithdrawalListResponse> getWithdrawals({String? nextUrl}) async {
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      const url = "${BaseUrl.baseUrl}/payment/list-withdrawals?filter_by=WHATSAPP";

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
          },
        ),
      );

      if (response.statusCode == 200) {
        return WithdrawalListResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to fetch withdrawals");
      }
    } catch (e) {
      throw Exception("Error fetching withdrawals: ${e.toString()}");
    }
  }

  Future<UnlockResponse> unlockWithdrawal(String requestId) async {
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      const url = "${BaseUrl.baseUrl}/payment/unlock-withdrawal";

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
        data: {
          "request_id": requestId,
        },
      );

      // Handle successful response (200)
      if (response.statusCode == 200) {
        return UnlockResponse.fromJson(response.data);
      }
      // Handle client error (400) with server message
      else if (response.statusCode == 400) {
        final errorData = response.data;
        if (errorData is Map && errorData.containsKey('details')) {
          throw UnlockException(errorData['details']);
        } else {
          throw UnlockException('Failed to unlock withdrawal');
        }
      }
      // Handle other status codes
      else {
        throw UnlockException('Failed to unlock withdrawal (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData is Map && errorData.containsKey('details')) {
          throw UnlockException(errorData['details']);
        }
      }
      throw UnlockException('Network error: ${e.message}');
    } catch (e) {
      throw UnlockException('Unexpected error: ${e.toString()}');
    }
  }


}
