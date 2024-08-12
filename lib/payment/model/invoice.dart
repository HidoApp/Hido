class Invoice {
  //  final String id;
  // final String invoiceStatus;
  // final String? url;
  final String id;
  final String? payId;
  final String invoiceStatus;
  final String? url;
  final String sessionId;
  final String? message;
  final List<ValidationError>? validationErrors;
  final String? payStatus;
  Invoice(
      {required this.id,
      required this.invoiceStatus,
      required this.sessionId,
      required this.payId,
      this.url,
      this.payStatus,
      this.message,
      this.validationErrors});

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      payId: json['payId'] ?? "",
      sessionId: json['sessionId'] ?? "",
      payStatus: json['payStatus'] ?? '',
      id: json['id'] ?? '',
      invoiceStatus: json['invoiceStatus'] ?? '',
      url: json['url'] ?? '',
      message: json['Message'] ?? '',
      validationErrors: json['validationErrors'] != null
          ? (json['validationErrors'] as List)
              .map((e) => ValidationError.fromJson(e))
              .toList()
          : [],
      // validationErrors: json['ValidationErrors'] != null
      //     ? ValidationError.fromJson(json['ValidationErrors'])
      //     : null,
    );
  }
}

class ValidationError {
  final String name;
  final String error;

  ValidationError({required this.name, required this.error});

  factory ValidationError.fromJson(Map<String, dynamic> json) {
    return ValidationError(
      name: json['Name'] ?? '',
      error: json['Error'] ?? '',
    );
  }
}
