import '../models/dashboard_model.dart';
import '../service/dashboard_service.dart';
import 'package:flutter/foundation.dart';

class DashboardViewModel extends ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();
  DashboardModel? _dashboardData;
  String _errorMessage = '';
  bool _isLoading = false;

  DashboardModel? get dashboardData => _dashboardData;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Notify listeners about the loading state

    try {
      _dashboardData = await _dashboardService.fetchUserDashboard();
      if (_dashboardData == null) {
        _errorMessage = 'Failed to load dashboard data';
      }
    } catch (e) {
      _errorMessage = 'Error fetching dashboard: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners that loading is complete
    }
  }
}