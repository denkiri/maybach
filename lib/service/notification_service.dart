// services/notification_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_projects/constants/base_url.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/notification_model.dart';

class NotificationService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();
  Future<List<NotificationModel>> fetchNotifications() async {
    const String url = '${BaseUrl.baseUrl}/notification';
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        throw Exception("Error: Missing tokens");
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

      if (response.statusCode == 200) {
        return NotificationListResponse.fromJson(response.data).results;
      }
      throw Exception("Failed to load notifications");
    } catch (e) {
      print("Error fetching notifications: $e");
      rethrow;
    }
  }

  Future<NotificationModel> postNotification(String message) async {
    const String url = '${BaseUrl.baseUrl}/notification';
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        throw Exception("Error: Missing tokens");
      }

      Response response = await _dio.post(
        url,
        data: jsonEncode({"message": message}),
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return NotificationModel.fromJson(response.data['details']);
      }
      throw Exception("Failed to post notification");
    } catch (e) {
      print("Error posting notification: $e");
      rethrow;
    }
  }
}