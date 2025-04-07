class WithdrawalListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<WithdrawalItem> results;

  WithdrawalListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory WithdrawalListResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawalListResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((item) => WithdrawalItem.fromJson(item))
          .toList(),
    );
  }
}

class WithdrawalItem {
  final String id;
  final String amount;
  final String phoneNumber;
  final String status;
  final String withdrawalType;
  final String dateCreated;

  WithdrawalItem({
    required this.id,
    required this.amount,
    required this.phoneNumber,
    required this.status,
    required this.withdrawalType,
    required this.dateCreated,
  });

  factory WithdrawalItem.fromJson(Map<String, dynamic> json) {
    return WithdrawalItem(
      id: json['id'],
      amount: json['amount'],
      phoneNumber: json['phone_number'],
      status: json['status'],
      withdrawalType: json['withdrawal_type'],
      dateCreated: json['date_created'],
    );
  }
}