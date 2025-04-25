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
