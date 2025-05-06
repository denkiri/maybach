import 'package:flutter/material.dart';
import '../models/deposit_request.dart';
import '../service/payment_service.dart';

class DepositViewModel extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  bool isLoading = false;
  String responseMessage = "";
  Future<void> trackPaymentStatus(String invoiceId) async {
    final startTime = DateTime.now();
    const timeout = Duration(minutes: 5);

    while (DateTime.now().difference(startTime) < timeout) {
      try {
        final callbackResponse = await _paymentService.checkPaymentStatus(invoiceId);

        if (callbackResponse.status == "PAID") {
          responseMessage = "✅ Payment successful";
          break;
        } else if (callbackResponse.status == "CANCELLED") {
          responseMessage = "❌ Payment was cancelled";
          break;
        } else {
          responseMessage = "⏳ Waiting for payment confirmation...";
        }
      } catch (e) {
        responseMessage = "⚠️ Error checking status: ${e.toString()}";
        break;
      }

      notifyListeners();
      await Future.delayed(Duration(seconds: 10));
    }

    if (responseMessage == "⏳ Waiting for payment confirmation...") {
      responseMessage = "❗ Timeout: Payment still pending after 5 minutes.";
      notifyListeners();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deposit(int amount, String phoneNumber,String receiptNo) async {
    isLoading = true;
    responseMessage = "";
    notifyListeners();

    try {
      final request = DepositRequest(amount: amount, phoneNumber: phoneNumber, receiptNo: receiptNo);
      final response = await _paymentService.makeDeposit(request);

      responseMessage = "📲 Payment request sent. Waiting for confirmation...";
      notifyListeners();

      await trackPaymentStatus(response.invoiceId);
    } catch (e) {
      responseMessage = "❌ ${e.toString()}";
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> anotherAccountDeposit(int amount, String phoneNumber, String recipientUsername,String receiptNo) async {
    isLoading = true;
    responseMessage = "";
    notifyListeners();

    try {
      final request = AnotherAccountDepositRequest(
        amount: amount,
        phoneNumber: phoneNumber,
        recipientUsername: recipientUsername,
        receiptNo: receiptNo,
      );

      final response = await _paymentService.makeAnotherAccountDeposit(request);

      responseMessage = "📲 Payment request sent for @$recipientUsername. Waiting for confirmation...";
      notifyListeners();

      await trackPaymentStatus(response.invoiceId); // This kicks off polling
    } catch (e) {
      responseMessage = "❌ Deposit failed: ${e.toString()}";
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> withdraw(int amount, String phoneNumber) async {
    isLoading = true;
    responseMessage = "";
    notifyListeners();

    try {
      WithdrawalRequest request = WithdrawalRequest(amount: amount,typeOfWithdrawal: "WALLET", phoneNumber: phoneNumber);
      WithdrawalResponse response = await _paymentService.makeWithdrawal(request);
      responseMessage = response.details;
    } catch (e) {
      responseMessage = "Withdrawal failed: ${e.toString()}";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> transfer(int amount, String recipientUsername) async {
    isLoading = true;
    responseMessage = "";
    notifyListeners();

    try {
      TransferRequest request = TransferRequest(amount: amount, recipientUsername: recipientUsername);
      TransferResponse response = await _paymentService.transferFunds(request);
      responseMessage = response.details;
    } catch (e) {
      responseMessage = "Transfer failed: ${e.toString()}";
    }

    isLoading = false;
    notifyListeners();
  }
}
