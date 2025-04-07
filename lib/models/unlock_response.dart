// models/unlock_response.dart
class UnlockResponse {
  final String details;

  UnlockResponse({required this.details});

  factory UnlockResponse.fromJson(Map<String, dynamic> json) {
    return UnlockResponse(details: json['details']);
  }
}