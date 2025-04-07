import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/base_url.dart';
import '../models/dashboard_model.dart';
class DashboardService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();

  Future<DashboardModel?> fetchUserDashboard() async {
    const String url = '${BaseUrl.baseUrl}/account/user-dashboard';
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

      if (response.statusCode == 200) {
        return DashboardModel.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching dashboard data: $e");
    }
    return null;
  }
}