// services/views_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/base_url.dart';
import '../models/upload_response.dart';
class ViewsService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();

  Future<SubmitViewsResponse> submitViews(SubmitViewsRequest request) async {
    const String baseUrl = "${BaseUrl.baseUrl}/moneyzone/submit-views";

    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      final response = await _dio.post(
        baseUrl,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return SubmitViewsResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to submit views");
      }
    } catch (e) {
      throw Exception("Error submitting views: ${e.toString()}");
    }
  }
}