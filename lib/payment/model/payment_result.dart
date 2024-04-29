class PaymentResult {
  final String id;
  final String paymentStatues;
  final String? transactionUrl;

  PaymentResult(
      {required this.id, required this.paymentStatues, this.transactionUrl});

  factory PaymentResult.fromJson(Map<String, dynamic> json) {
    return PaymentResult(
        id: json['id'],
        paymentStatues: json['payStatus'],
        transactionUrl: json['transactionUrl']);
  }
}
