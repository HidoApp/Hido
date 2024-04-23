class Invoice {
   final String id;
  final String invoiceStatus;
  final String? url;

  Invoice(
      {required this.id, required this.invoiceStatus, this.url});

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
        id: json['id'],
        invoiceStatus: json['invoiceStatus'],
        url: json['url']);
  }
}