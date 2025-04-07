import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/base_url.dart';
import '../models/job.dart';

class JobService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();

  Future<List<Job>?> fetchJobs() async {
    const String url = '${BaseUrl.baseUrl}/moneyzone/jobs';
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
        List<dynamic> jobList = response.data["results"];
        return jobList.map((job) => Job.fromJson(job)).toList();
      }
    } catch (e) {
      print("Error fetching job details: $e");
    }
    return null;
  }
  Future<JobApplicationResponse?> applyForJob(JobApplicationRequest request) async {
    const String url = '${BaseUrl.baseUrl}/moneyzone/job-application';
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');
      if (jwtToken == null || refreshToken == null) {
        throw "Missing authentication tokens";
      }

      Response response = await _dio.post(
        url,
        data: request.toJson(),
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return JobApplicationResponse.fromJson(response.data);
      } else {
        throw "Unexpected server response";
      }
    } on DioException catch (e) {
      if (e.response?.data != null && e.response?.data['details'] != null) {
        // throw actual server error
        throw e.response!.data['details'];
      } else {
        throw "Server error occurred";
      }
    } catch (e) {
      throw "Unexpected error: $e";
    }
  }

}
