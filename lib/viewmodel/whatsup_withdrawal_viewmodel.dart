// viewmodel/whatsup_withdrawal_viewmodel.dart
import 'package:flutter/cupertino.dart';

import '../models/withdrawal_request.dart';
import '../models/withdrawal_list_response.dart';
import '../models/unlock_response.dart';
import '../service/unlock_exemptions.dart';
import '../service/whatsup_withdrawal_service.dart';

class WithdrawViewModel extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();

  bool isLoading = false;
  bool isLoadingMore = false;
  bool isUnlocking = false;
  String responseMessage = "";

  List<WithdrawalItem> withdrawals = [];
  String? nextPageUrl;
  bool hasMore = true;

  Future<void> initiateWithdrawal(String phoneNumber, double amount) async {
    isLoading = true;
    notifyListeners();
    try {
      WithdrawRequest request = WithdrawRequest(
        phoneNumber: phoneNumber,
        amount: amount,
      );
      WithdrawResponse response = await _paymentService.makeWithdrawal(request);
      responseMessage = response.details;
      await fetchWithdrawals();
    } catch (e) {
      responseMessage = "Failed to withdraw: ${e.toString()}";
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchWithdrawals() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _paymentService.getWithdrawals();
      withdrawals = response.results;
      nextPageUrl = response.next;
      hasMore = response.next != null;
      responseMessage = "";
    } catch (e) {
      responseMessage = "Failed to load withdrawals: ${e.toString()}";
      withdrawals = [];
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreWithdrawals() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    notifyListeners();
    try {
      final response = await _paymentService.getWithdrawals(nextUrl: nextPageUrl);
      withdrawals.addAll(response.results);
      nextPageUrl = response.next;
      hasMore = response.next != null;
    } catch (e) {
      responseMessage = "Failed to load more withdrawals: ${e.toString()}";
    }
    isLoadingMore = false;
    notifyListeners();
  }

// In WithdrawViewModel
  Future<void> unlockWithdrawal(String withdrawalId) async {
    isUnlocking = true;
    notifyListeners();

    try {
      final response = await _paymentService.unlockWithdrawal(withdrawalId);
      responseMessage = "Withdrawal unlocked successfully";
      await fetchWithdrawals(); // Refresh the list
    } on UnlockException catch (e) {
      responseMessage = e.message; // Use the precise error message
    } catch (e) {
      responseMessage = "Failed to unlock withdrawal: ${e.toString()}";
    } finally {
      isUnlocking = false;
      notifyListeners();
    }
  }
}