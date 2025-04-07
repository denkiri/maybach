import 'package:flutter/material.dart';
import '../components/utils/toast_utils.dart';
import '../models/loan.dart';
import '../models/loan_request.dart';
import '../models/profile_model.dart';
import '../service/loan_service.dart';
class LoanViewModel with ChangeNotifier {
  final LoanService _apiService = LoanService();

  ProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _apiService.fetchUserProfile();
      _error = null;

      // Fill the form with profile data
      if (_profile != null) {
        firstNameController.text = _profile!.details.firstName;
        lastNameController.text = _profile!.details.lastName;
        emailController.text = _profile!.details.email;
        phoneNumberController.text = _profile!.details.phoneNumber;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    amountController.dispose();
    super.dispose();
  }

  LoanListResponse? _loanResponse;
  LoanListResponse? get loanResponse => _loanResponse;

  List<Loan> _loans = [];
  List<Loan> get loans => _loans;

  int _currentPage = 1;
  final int _pageSize = 10;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> fetchLoans({bool loadMore = false}) async {
    if (!loadMore) {
      _currentPage = 1;
      _hasMore = true;
      _isLoading = true;
      notifyListeners();
    }

    try {
      final response = await _apiService.fetchLoans(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (response != null) {
        _loanResponse = response;

        if (!loadMore) {
          _loans = response.results;
        } else {
          _loans.addAll(response.results);
        }

        _hasMore = response.next != null;
        _currentPage++;
      }
    } catch (e) {
      debugPrint("Error fetching loans: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreLoans() async {
    if (_hasMore && !_isLoading) {
      await fetchLoans(loadMore: true);
    }
  }

  Future<void> refreshLoans() async {
    await fetchLoans(loadMore: false);
  }

  Future<bool> applyLoan() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final amountText = amountController.text.trim();
    final amount = int.tryParse(amountText) ?? 0;

    if (amount <= 0) {
      _error = "Please enter a valid loan amount";
      ToastUtils.showWarningToast(_error!);
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      LoanRequest request = LoanRequest(amount: amount);
      LoanResponse response = await _apiService.applyForLoan(request);

      amountController.clear();
      await refreshLoans();

      return true;
    } catch (e) {
      _error = e.toString(); // Show clean server error like "Insufficient balance..."
      ToastUtils.showErrorToast(_error!);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }





}