import 'package:dio/dio.dart';
import 'package:flutter_projects/service/unlock_exemptions.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/base_url.dart';
import '../models/deposit_request.dart';

class PaymentService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();

  Future<DepositResponse> makeDeposit(DepositRequest request) async {
    const String baseUrl = "${BaseUrl.baseUrl}/payment/stk-push";
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

      // Handle successful response (201)
      if (response.statusCode == 201) {
        return DepositResponse.fromJson(response.data);
      }
      // Handle client errors (400-499)
      else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        final errorData = response.data;
        if (errorData is Map && errorData.containsKey('details')) {
          throw UnlockException(errorData['details']);
        } else {
          throw UnlockException('Failed to process deposit (Status: ${response.statusCode})');
        }
      }
      // Handle server errors (500+)
      else {
        throw UnlockException('Server error occurred (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response?.statusCode != null) {
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

  Future<AnotherAccountDepositResponse> makeAnotherAccountDeposit(AnotherAccountDepositRequest request) async {
    const String baseUrl = "${BaseUrl.baseUrl}/payment/alternative-stk-push";
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

      // Handle successful response (201)
      if (response.statusCode == 201) {
        return AnotherAccountDepositResponse.fromJson(response.data);
      }
      // Handle client errors (400-499)
      else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        final errorData = response.data;
        if (errorData is Map && errorData.containsKey('details')) {
          throw UnlockException(errorData['details']);
        } else {
          throw UnlockException('Failed to process deposit (Status: ${response.statusCode})');
        }
      }
      // Handle server errors (500+)
      else {
        throw UnlockException('Server error occurred (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors
      if (e.response?.statusCode != null) {
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

  Future<WithdrawalResponse> makeWithdrawal(WithdrawalRequest request) async {
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

      if (response.statusCode == 201) {
        return WithdrawalResponse.fromJson(response.data);
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        final errorData = response.data;
        if (errorData is Map && errorData.containsKey('details')) {
          throw UnlockException(errorData['details']);
        } else {
          throw UnlockException('Failed to process withdrawal (Status: ${response.statusCode})');
        }
      } else {
        throw UnlockException('Server error occurred (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode != null) {
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

  Future<TransferResponse> transferFunds(TransferRequest request) async {
    const String baseUrl = "${BaseUrl.baseUrl}/payment/transfer-funds";
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

      if (response.statusCode == 201) {
        return TransferResponse.fromJson(response.data);
      } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
        final errorData = response.data;
        if (errorData is Map && errorData.containsKey('details')) {
          throw UnlockException(errorData['details']);
        } else {
          throw UnlockException('Failed to process transfer (Status: ${response.statusCode})');
        }
      } else {
        throw UnlockException('Server error occurred (Status: ${response.statusCode})');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode != null) {
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
