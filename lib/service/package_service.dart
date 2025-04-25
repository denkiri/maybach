import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/base_url.dart';
import '../models/package_model.dart';

class PackageService {
  final Dio _dio = Dio();
  static const storage = FlutterSecureStorage();
  //CUSTOM
  Future<PackageModel?> fetchSilverPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=CUSTOM&search=SILVER';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  Future<PackageModel?> fetchPlatinumPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=CUSTOM&search=PLATINUM';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  Future<PackageModel?> fetchGoldPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=CUSTOM&search=GOLD';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  Future<PackageModel?> fetchMayBachPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=CUSTOM&search=MAYBACK_DEAL';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  Future<PackageModel?> fetchWhatsupLinkagePackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=CUSTOM&search=WHATSUP_LINKAGE';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }

  //BONUS
  Future<PackageModel?> fetchWelcomePackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=BONUS&search=WELCOME';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  Future<PackageModel?> fetchCashBackPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=BONUS&search=CASHBACK';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  Future<PackageModel?> fetchProBonusPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=BONUS&search=PRO BONUS';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  //WRITING
  Future<PackageModel?> fetchRemoTasksPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=WRITING&search=REMOTASKS';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  Future<PackageModel?> fetchCloudWorkersPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=WRITING&search=CLOUD WORKERS';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  //CLEARANCE
  Future<PackageModel?> fetchClearancePackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=CLEARANCE&search=CLEARANCE';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  //DOLLAR_ZONE
  Future<PackageModel?> fetchAdvertisingAgencyPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=DOLLAR_ZONE&search=ADVERTISING';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  Future<PackageModel?> fetchVerificationPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=DOLLAR_ZONE&search=VERIFICATION';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  Future<PackageModel?> fetchCertificationPackage() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=DOLLAR_ZONE&search=CERTIFICATION';
    try {
      String? jwtToken = await storage.read(key:'jwt_token');
      String? refreshToken = await storage.read(key:'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return null;
      }

      Response response = await _dio.get(
        url,
        options: Options(
          headers: {
            "Authorization":"Bearer $refreshToken",
            "JWTAUTH":"Bearer $jwtToken",
            "Content-Type":"application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return PackageModel.fromJson(response.data[0]);
      }
    } catch (e) {
      print("Error fetching package: $e");
    }
    return null;
  }
  //PURCHASE PACKAGE
  Future<Map<String, dynamic>> purchasePackage(String packageId) async {
    const String url = '${BaseUrl.baseUrl}/payment/purchase-package';
    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        print("Error: Missing tokens");
        return {
          'success': false,
          'message': 'Authentication required',
        };
      }

      Response response = await _dio.post(
        url,
        data: {
          "package_id": packageId,
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
        return {
          'success': true,
          'message': response.data['details'] ?? 'Package purchased successfully',
        };
      } else {
        return {
          'success': false,
          'message': response.data['details'] ?? 'Failed to purchase package',
        };
      }
    } on DioException catch (e) {
      print("Error purchasing package: $e");
      return {
        'success': false,
        'message': e.response?.data['details'] ?? 'Network error occurred',
      };
    } catch (e) {
      print("Unexpected error purchasing package: $e");
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    }
  }
  //STARLINK_MOTORS
  Future<List<PackageModel>> fetchStarlinkMotorsPackages() async {
    const String url = '${BaseUrl.baseUrl}/packages?filter=STARLINK_MOTORS';

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

      if (response.statusCode == 200 && response.data is List) {
        return PackageModel.fromJsonList(response.data);
      }
    } catch (e) {
      print("Error fetching packages: $e");
    }
    return [];
  }
  Future<Map<String, dynamic>> updatePackage(String packageId, Map<String, dynamic> body) async {
    final String url = '${BaseUrl.baseUrl}/packages/$packageId';

    try {
      String? jwtToken = await storage.read(key: 'jwt_token');
      String? refreshToken = await storage.read(key: 'refresh_token');

      if (jwtToken == null || refreshToken == null) {
        return {"success": false, "message": "Missing authentication tokens"};
      }

      Response response = await _dio.patch(
        url,
        data: body,
        options: Options(
          headers: {
            "Authorization": "Bearer $refreshToken",
            "JWTAUTH": "Bearer $jwtToken",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return {"success": true, "message": response.data["details"] ?? "Package updated"};
      }
    } catch (e) {
      return {"success": false, "message": "Update failed: $e"};
    }

    return {"success": false, "message": "Unexpected error during update"};
  }







}
