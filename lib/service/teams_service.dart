import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../constants/base_url.dart';
import '../models/teams.dart';

class TeamsService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();

  Future<TeamsResponse?> fetchTeams({int page = 1, int pageSize = 10}) async {
    const String url = '${BaseUrl.baseUrl}/account/user-teams';
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
        return TeamsResponse.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching teams: $e");
    }
    return null;
  }
}