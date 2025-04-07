import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/upload_response.dart';
import '../service/upload_service.dart';
import '../service/views_service.dart';

class SubmitViewsViewModel with ChangeNotifier {
  final UploadService _uploadService = UploadService();
  final ViewsService _viewsService = ViewsService();

  String? _errorMessage;
  bool _isLoading = false;
  SubmitViewsResponse? _submitResponse;

  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  SubmitViewsResponse? get submitResponse => _submitResponse;

  void setErrorMessage(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearResponse() {
    _submitResponse = null;
    notifyListeners();
  }

  Future<void> submitViews({
    required Uint8List fileBytes,
    required String fileName,
    required String phoneNumber,
    required int numberOfViews,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _submitResponse = null;
    notifyListeners();

    try {
      // Upload the image first
      UploadResponse uploadResponse = await _uploadService.uploadImage(
        fileBytes: fileBytes,
        fileName: fileName,
      );

      // Check if files were uploaded successfully
      if (uploadResponse.files.isEmpty) {
        throw Exception("No files were uploaded");
      }

      // Submit the views with the uploaded file ID
      SubmitViewsRequest request = SubmitViewsRequest(
        phoneNumber: phoneNumber,
        numberOfViews: numberOfViews,
        screenshot: uploadResponse.files.first.id,
      );

      _submitResponse = await _viewsService.submitViews(request);
    } catch (e) {
      setErrorMessage("Upload failed: ${e.toString()}");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}