class Payment {
  final String id;
  final String payId;
  final String payStatus;
  final PayObject payObject;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      payId: json['payId'],
      payStatus: json['payStatus'],
      payObject: PayObject.fromJson(json['payObject']),
    );
  }

  Payment(
      {required this.id,
      required this.payId,
      required this.payStatus,
      required this.payObject});
}

class PayObject {
  final String ip;
  final int fee;
  final int amount;
  final Source source;
  final int captured;
  final String currency;
  final int refunded;
  final String created_at;
  final String fee_format;
  final String description;
  final String amount_format;
  final String captured_format;
  final String refunded_format;


  factory PayObject.fromJson(Map<String, dynamic> json) {
    return PayObject(
      ip: json['ip'],
      fee: json['fee'],
      amount: json['amount'],
      source:Source.fromJson( json['source']),
      captured: json['captured'],
      currency: json['currency'],
      refunded: json['refunded'],
      created_at: json['created_at'],
      fee_format: json['fee_format'],
      description: json['description'],
      amount_format: json['amount_format'],
      captured_format: json['captured_format'],
      refunded_format: json['refunded_format'],

    );
  }

  PayObject({required this.ip, required this.fee, required this.amount, required this.source, required this.captured, required this.currency, required this.refunded, required this.created_at, required this.fee_format, required this.description, required this.amount_format, required this.captured_format, required this.refunded_format});
}

class Source {
  final String name;
  final String type;
  final String company;
  final String? message;
  final String transaction_url;

  Source(
      {required this.name,
      required this.type,
      required this.company,
       this.message,
      required this.transaction_url});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      name: json['name'],
      type: json['type'],
      company: json['company'],
      message: json['message'],
      transaction_url: json['transaction_url'],
    );
  }
}






//   "payObject": {
//     "ip": "string",
//     "fee": 0,
//     "amount": 0,
//     "source": {
//       "name": "string",
//       "type": "string",
//       "company": "string",
//       "message": "Unknown Type: null",
//       "transaction_url": "string"
//     },
//     "captured": 0,
//     "currency": "string",
//     "refunded": 0,
//     "created_at": "string",
//     "fee_format": "string",
//     "description": "string",
//     "amount_format": "string",
//     "captured_format": "string",
//     "refunded_format": "string"
//   }