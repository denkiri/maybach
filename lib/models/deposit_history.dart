class DepositHistory {
  final String id;
  final double amount;
  final DateTime createdAt;

  DepositHistory({
    required this.id,
    required this.amount,
    required this.createdAt,
  });

  factory DepositHistory.fromJson(Map<String, dynamic> json) {
    return DepositHistory(
      id: json['id'] ?? '',
      amount: double.tryParse(json['amount'] ?? '0.0') ?? 0.0,
      createdAt: DateTime.parse(json['date_created']),
    );
  }
}

class DepositHistoryResponse {
  final List<DepositHistory> deposits;
  final int total;
  final String? next;
  final String? previous;

  DepositHistoryResponse({
    required this.deposits,
    required this.total,
    this.next,
    this.previous,
  });

  factory DepositHistoryResponse.fromJson(Map<String, dynamic> json) {
    return DepositHistoryResponse(
      deposits: (json['results'] as List)
          .map((item) => DepositHistory.fromJson(item))
          .toList(),
      total: json['count'],
      next: json['next'],
      previous: json['previous'],
    );
  }
}
