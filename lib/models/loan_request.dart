class LoanRequest {
  final int amount;

  LoanRequest({required this.amount});

  Map<String, dynamic> toJson() => {
    'amount': amount,
  };
}
class LoanResponse {
  final String details;

  LoanResponse({required this.details});

  factory LoanResponse.fromJson(Map<String, dynamic> json) => LoanResponse(
    details: json['details'],
  );
}