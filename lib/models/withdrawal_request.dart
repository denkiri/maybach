class WithdrawRequest {
  final String phoneNumber;
  final double amount;
  final String typeOfWithdrawal;

  WithdrawRequest({
    required this.phoneNumber,
    required this.amount,
    this.typeOfWithdrawal = "WHATSAPP",
  });

  Map<String, dynamic> toJson() {
    return {
      "phone_number": phoneNumber,
      "amount": amount,
      "type_of_withdrawal": typeOfWithdrawal,
    };
  }
}

// models/withdraw_response.dart
class WithdrawResponse {
  final String details;

  WithdrawResponse({required this.details});

  factory WithdrawResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawResponse(details: json["details"]);
  }
}