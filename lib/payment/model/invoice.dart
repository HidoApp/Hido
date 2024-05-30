class Invoice {
  //  final String id;
  // final String invoiceStatus;
  // final String? url;
  final String id;
  final String invoiceStatus;
  final String? url;
  final String? message;
  final List<ValidationError>? validationErrors;

  Invoice(
  { required this.id,
    required this.invoiceStatus,
    this.url,
    this.message,
    this.validationErrors
   });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
       id: json['id']??'',
      invoiceStatus: json['invoiceStatus']??'',
      url: json['url']??'',
      message: json['Message']??'',
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
      name: json['Name']??'',
      error: json['Error']??'',
    );
  }
}
