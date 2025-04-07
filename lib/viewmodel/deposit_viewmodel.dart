import 'package:flutter/material.dart';
import '../models/deposit_request.dart';
import '../service/payment_service.dart';

class DepositViewModel extends ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  bool isLoading = false;
  String responseMessage = "";
  Future<void> deposit(int amount, String phoneNumber) async {
    isLoading = true;
    responseMessage = "";
    notifyListeners();

    try {
      DepositRequest request = DepositRequest(amount: amount, phoneNumber: phoneNumber);
      DepositResponse response = await _paymentService.makeDeposit(request);
      responseMessage = response.details;
    } catch (e) {
      responseMessage = "Deposit failed: ${e.toString()}";
    }

    isLoading = false;
    notifyListeners();
  }
  Future<void> anotherAccountDeposit(int amount, String phoneNumber,String recipientUsername) async {
    isLoading = true;
    responseMessage = "";
    notifyListeners();

    try {
      AnotherAccountDepositRequest request = AnotherAccountDepositRequest(amount: amount, phoneNumber: phoneNumber, recipientUsername: recipientUsername);
      AnotherAccountDepositResponse response = await _paymentService.makeAnotherAccountDeposit(request);
      responseMessage = response.message;
    } catch (e) {
      responseMessage = "Deposit failed: ${e.toString()}";
    }

    isLoading = false;
    notifyListeners();
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
