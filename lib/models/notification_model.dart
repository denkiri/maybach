class NotificationModel {
  final String id;
  final String message;
  final DateTime dateCreated;

  NotificationModel({
    required this.id,
    required this.message,
    required this.dateCreated,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      message: json['message'],
      dateCreated: DateTime.parse(json['date_created']),
    );
  }
}

class NotificationListResponse {
  final int count;
  final List<NotificationModel> results;

  NotificationListResponse({
    required this.count,
    required this.results,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    var resultsList = json['results'] as List;
    List<NotificationModel> notifications = resultsList
        .map((item) => NotificationModel.fromJson(item))
        .toList();

    return NotificationListResponse(
      count: json['count'],
      results: notifications,
    );
  }
}