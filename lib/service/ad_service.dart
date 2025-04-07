import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/base_url.dart';
import '../models/ad.dart';
class AdService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();
  static const String url = '${BaseUrl.baseUrl}/moneyzone/ads';
  Future<void> postAd(String adFileId) async {
    const String url = "${BaseUrl.baseUrl}/moneyzone/ads";

    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
        data: {"ad": adFileId},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to post ad");
      }
    } catch (e) {
      throw Exception("Error posting ad: ${e.toString()}");
    }
  }

  Future<List<Ad>> fetchAds() async {
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return [];
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

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return Ad.fromJsonList(response.data['results']);
      }
    } catch (e) {
      print("Error fetching ads: $e");
    }
    return [];
  }
}