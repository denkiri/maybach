import 'package:flutter/cupertino.dart';
import '../models/teams.dart';
import '../service/teams_service.dart';
class TeamsViewModel with ChangeNotifier {
  final TeamsService _teamsService = TeamsService();

  List<TeamMember> _teams = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  String? _errorMessage;

  List<TeamMember> get teams => _teams;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTeams({bool loadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (!loadMore) {
      _currentPage = 1;
      _hasMore = true;
      _errorMessage = null;
    }
    notifyListeners();

    try {
      final response = await _teamsService.fetchTeams(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response != null) {
        if (loadMore) {
          _teams.addAll(response.results);
        } else {
          _teams = response.results;
        }

        _hasMore = response.next != null;
        _currentPage++;
      } else {
        _errorMessage = "Failed to load teams";
      }
    } catch (e) {
      _errorMessage = "An error occurred: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshTeams() {
    fetchTeams(loadMore: false);
  }

  void loadMoreTeams() {
    if (_hasMore && !_isLoading) {
      fetchTeams(loadMore: true);
    }
  }
}