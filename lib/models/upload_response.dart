// models/upload_response.dart
class UploadResponse {
  final String details;
  final List<UploadedFile> files;

  UploadResponse({
    required this.details,
    required this.files,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      details: json['details'],
      files: (json['files'] as List)
          .map((file) => UploadedFile.fromJson(file))
          .toList(),
    );
  }
}

class UploadedFile {
  final String id;
  final String file;
  final String name;
  final String dateCreated;

  UploadedFile({
    required this.id,
    required this.file,
    required this.name,
    required this.dateCreated,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      id: json['id'],
      file: json['file'],
      name: json['name'],
      dateCreated: json['date_created'],
    );
  }
}

// models/submit_views_request.dart
class SubmitViewsRequest {
  final String phoneNumber;
  final int numberOfViews;
  final String screenshot;

  SubmitViewsRequest({
    required this.phoneNumber,
    required this.numberOfViews,
    required this.screenshot,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'number_of_views': numberOfViews,
      'screenshot': screenshot,
    };
  }
}

// models/submit_views_response.dart
class SubmitViewsResponse {
  final String details;

  SubmitViewsResponse({
    required this.details,
  });

  factory SubmitViewsResponse.fromJson(Map<String, dynamic> json) {
    return SubmitViewsResponse(
      details: json['details'],
    );
  }
}