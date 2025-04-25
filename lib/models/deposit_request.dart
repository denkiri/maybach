class DepositRequest {
  final int amount;
  final String phoneNumber;

  DepositRequest({required this.amount, required this.phoneNumber});

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "phone_number": phoneNumber,
    };
  }
}
class AnotherAccountDepositRequest {
  final int amount;
  final String phoneNumber;
  final String recipientUsername;

  AnotherAccountDepositRequest({
    required this.amount,
    required this.phoneNumber,
    required this.recipientUsername,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'phone_number': phoneNumber,
    'recipient_username': recipientUsername,
  };
}

class DepositResponse {
  final String details;
  final String invoiceId;
  final String status;

  DepositResponse({
    required this.details,
    required this.invoiceId,
    required this.status,
  });

  factory DepositResponse.fromJson(Map<String, dynamic> json) {
    return DepositResponse(
      details: json["details"],
      invoiceId: json["invoice_id"],
      status: json["status"],
    );
  }
}

class AnotherAccountDepositResponse {
  final String message;
  final String invoiceId;

  AnotherAccountDepositResponse({
    required this.message,
    required this.invoiceId,
  });

  factory AnotherAccountDepositResponse.fromJson(Map<String, dynamic> json) => AnotherAccountDepositResponse(
    message: json['message'],
    invoiceId: json['invoice_id'],
  );
}

class WithdrawalRequest {
  final String phoneNumber;
  final String typeOfWithdrawal;
  final int amount;

  WithdrawalRequest({
    required this.phoneNumber,
    required this.typeOfWithdrawal,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'phone_number': phoneNumber,
        'type_of_withdrawal': typeOfWithdrawal,
        'amount': amount,
      };
}

class WithdrawalResponse {
  final String details;

  WithdrawalResponse({required this.details});

  factory WithdrawalResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawalResponse(
      details: json['details'],
    );
  }
}

class TransferRequest {
  final String recipientUsername;
  final int amount;

  TransferRequest({
    required this.recipientUsername,
    required this.amount,
  });

  Map<String, dynamic> toJson() => {
        'recipient_username': recipientUsername,
        'amount': amount,
      };
}

class TransferResponse {
  final String details;

  TransferResponse({required this.details});

  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    return TransferResponse(
      details: json['details'],
    );
  }
}

