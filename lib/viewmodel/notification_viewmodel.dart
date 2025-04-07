import 'package:flutter/material.dart';
import '../models/notification_model.dart';
import '../service/notification_service.dart';
class NotificationViewModel extends ChangeNotifier {
  final NotificationService _service = NotificationService();
  List<NotificationModel> notifications = [];
  bool isLoading = false;
  bool isPosting = false;
  String? errorMessage;

  Future<void> loadNotifications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      notifications = await _service.fetchNotifications();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> postNotification(String message) async {
    isPosting = true;
    errorMessage = null;
    notifyListeners();

    try {
      final newNotification = await _service.postNotification(message);
      notifications.insert(0, newNotification);
    } catch (e) {
      errorMessage = e.toString();
    }

    isPosting = false;
    notifyListeners();
  }
}