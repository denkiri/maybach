import 'package:flutter/cupertino.dart';
import '../models/account_respons.dart';
import '../models/deposit_history.dart';
import '../models/result.dart';
import '../service/account_service.dart';

class AccountViewModel with ChangeNotifier {
  final AccountsService _accountsService = AccountsService();
  List<UserAccount> _accounts = [];
  List<DepositHistory> _depositHistory = [];
  bool _isLoading = false;
  bool _isFetchingDeposits = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final int _pageSize = 10;
  String? _errorMessage;
  int _depositPage = 1;
  bool _hasMoreDeposits = true;

  int get depositPage => _depositPage;
  bool get hasMoreDeposits => _hasMoreDeposits;

  List<UserAccount> get accounts => _accounts;
  List<DepositHistory> get depositHistory => _depositHistory;
  bool get isLoading => _isLoading;
  bool get isFetchingDeposits => _isFetchingDeposits;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAccounts({bool loadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (!loadMore) {
      _currentPage = 1;
      _hasMore = true;
      _errorMessage = null;
    }
    notifyListeners();

    try {
      final response = await _accountsService.fetchAccounts(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response != null) {
        if (loadMore) {
          _accounts.addAll(response.results);
        } else {
          _accounts = response.results;
        }

        _hasMore = response.next != null;
        _currentPage++;
      } else {
        _errorMessage = "Failed to load accounts";
      }
    } catch (e) {
      _errorMessage = "An error occurred: ${e.toString()}";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void refreshAccounts() {
    fetchAccounts(loadMore: false);
  }

  void loadMoreAccounts() {
    if (_hasMore && !_isLoading) {
      fetchAccounts(loadMore: true);
    }
  }
  Future<Result> deactivateAccount(String userId) async {
    Result result = await _accountsService.manageUser(userId, "DEACTIVATE");

    if (result.success) {
      _accounts.removeWhere((account) => account.id == userId);
      notifyListeners();
    }

    return result;
  }
  Future<Result> activateAccount(String userId) async {
    Result result = await _accountsService.manageUser(userId, "ACTIVATE");

    if (result.success) {
      _accounts.removeWhere((account) => account.id == userId);
      notifyListeners();
    }

    return result;
  }
  Future<void> fetchUserDepositHistory(String userId) async {
    if (_isFetchingDeposits) return;

    _isFetchingDeposits = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _accountsService.fetchUserDepositHistory(userId);

      if (response != null) {
        _depositHistory = response.deposits;
       // print("Deposit history fetched successfully: ${_depositHistory.length} records");
        for (var deposit in _depositHistory) {
         // print("Deposit ID: ${deposit.id}, Amount: ${deposit.amount}, Status: ${deposit.id}, Date: ${deposit.createdAt}");
        }
      } else {
        _depositHistory = []; // Ensure it's empty if response is null
        _errorMessage = "Failed to load deposit history";
        print("Error: Failed to load deposit history");
      }
    } catch (e) {
      _depositHistory = [];
      _errorMessage = "An error occurred: ${e.toString()}";
      print("Error fetching deposit history: $e");
    } finally {
      _isFetchingDeposits = false;
      notifyListeners();
    }
  }


  void clearDepositHistory() {
    _depositHistory = [];
    notifyListeners();
  }
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

// Initialize scroll listener
  void initScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreAccounts();
      }
    });
  }

// Dispose the controller when not needed
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

}
