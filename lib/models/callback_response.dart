class CallbackResponse {
  final String invoiceId;
  final String status;

  CallbackResponse({required this.invoiceId, required this.status});

  factory CallbackResponse.fromJson(Map<String, dynamic> json) {
    final details = json['details'];
    return CallbackResponse(
      invoiceId: details['invoice_id'],
      status: details['status'],
    );
  }
}

class PaymentConfirmationResponse {
  final String id;
  final String referenceNumber;
  final String status;

  PaymentConfirmationResponse({
    required this.id,
    required this.referenceNumber,
    required this.status,
  });

  factory PaymentConfirmationResponse.fromJson(Map<String, dynamic> json) {
    final details = json['details'];
    return PaymentConfirmationResponse(
      id: details['id'],
      referenceNumber: details['reference_number'],
      status: details['status'],
    );
  }
}
