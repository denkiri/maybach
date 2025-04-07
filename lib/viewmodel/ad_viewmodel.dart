import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/ad.dart';
import '../service/ad_service.dart';
import '../service/upload_service.dart';

class AdViewModel extends ChangeNotifier {
  final UploadService _uploadService = UploadService();
  final AdService _service = AdService();

  List<Ad> ads = [];
  bool isLoading = false;
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  Future<void> loadAds() async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      ads = await _service.fetchAds();
    } catch (e) {
      _errorMessage = 'Failed to load ads: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadAndPostAd(Uint8List fileBytes, String fileName) async {
    isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final uploadResponse = await _uploadService.uploadImage(
        fileBytes: fileBytes,
        fileName: fileName,
      );

      if (uploadResponse.files.isEmpty) {
        throw Exception("No file returned from upload.");
      }

      final fileId = uploadResponse.files.first.id;
      await _service.postAd(fileId);

      // Reload ads to include the newly posted one
      await loadAds();
    } catch (e) {
      _errorMessage = 'Failed to upload/post ad: $e';
      isLoading = false; // prevent double loading state
      notifyListeners();
    }
  }
}
