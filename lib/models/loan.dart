class LoanListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Loan> results;

  LoanListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory LoanListResponse.fromJson(Map<String, dynamic> json) {
    return LoanListResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: List<Loan>.from(json['results'].map((x) => Loan.fromJson(x))),
    );
  }
}

class Loan {
  final String id;
  final double applicationFee;
  final DateTime dateCreated;
  final DateTime dateUpdated;
  final DateTime? dateDeleted;
  final String amount;
  final String status;

  Loan({
    required this.id,
    required this.applicationFee,
    required this.dateCreated,
    required this.dateUpdated,
    this.dateDeleted,
    required this.amount,
    required this.status,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    return Loan(
      id: json['id'],
      applicationFee: json['application_fee'].toDouble(),
      dateCreated: DateTime.parse(json['date_created']),
      dateUpdated: DateTime.parse(json['date_updated']),
      dateDeleted: json['date_deleted'] != null ? DateTime.parse(json['date_deleted']) : null,
      amount: json['amount'],
      status: json['status'],
    );
  }
}