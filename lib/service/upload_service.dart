import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/base_url.dart';
import '../models/upload_response.dart';

class UploadService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();

  Future<UploadResponse> uploadImage({
    required Uint8List fileBytes,
    required String fileName,
  }) async {
    const String baseUrl = "${BaseUrl.baseUrl}/store/upload";

    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');


      MultipartFile multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      );

      FormData formData = FormData.fromMap({
        "document": multipartFile,
      });

      final response = await _dio.post(
        baseUrl,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type": "multipart/form-data",
          },
        ),
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UploadResponse.fromJson(response.data);
      } else {
        throw Exception("Failed to upload image: ${response.statusMessage}");
      }
    } on DioException catch (e) {
      throw Exception("Error uploading image: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Error uploading image: ${e.toString()}");
    }
  }
}