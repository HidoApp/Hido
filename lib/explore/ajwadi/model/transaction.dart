import 'dart:convert';

class Transaction {
  final String? id;
  final double? amount;
  final String? transactionStatus;
  final String? status;
  final String? userId;
  final bool? hasRefunded;
  final String? refundedAmount;
  final String? refundPercentage;
  final String? paymentId;
  final String? invoiceId;
  final String? created;
  final String? updated;
  final DetailsInfo? details;

  Transaction({
    this.id,
    this.amount,
    this.transactionStatus,
    this.status,
    this.userId,
    this.hasRefunded,
    this.refundedAmount,
    this.refundPercentage,
    this.paymentId,
    this.invoiceId,
    this.created,
    this.updated,
    this.details,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      amount: (json['amount'] is int)
          ? double.parse((json['amount'] as int).toDouble().toStringAsFixed(1))
          : double.parse((json['amount'] as double? ?? 0.0).toStringAsFixed(1)),
      transactionStatus: json['transactionStatus'] ?? '',
      status: json['status'] ?? '',
      userId: json['userId'] ?? '',
      hasRefunded: json['hasRefunded'] ?? true,
      refundedAmount: json['refundedAmount'] ?? '',
      refundPercentage: json['refundPercentage'] ?? '',
      paymentId: json['paymentId'] ?? '',
      invoiceId: json['invoiceId'] ?? '',
      created: json['created'] ?? '',
      updated: json['updated'] ?? '',
      details: json['details'] != null ? DetailsInfo.fromJson(json['details']) : null, // Handle as single object

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'transactionStatus': transactionStatus,
      'status': status,
      'userId': userId,
      'hasRefunded': hasRefunded,
      'refundedAmount': refundedAmount,
      'refundPercentage': refundPercentage,
      'paymentId': paymentId,
      'invoiceId': invoiceId,
      'created': created,
      'updated': updated,
      'details': details,
    };
  }
}

class DetailsInfo {
  final String? bookingId;
  final String? adventureId;
  final String? eventId;
  final String? hospitalityId;
 final String? placeId;


  DetailsInfo(
      {this.bookingId, this.adventureId, this.eventId, this.hospitalityId,this.placeId});

  factory DetailsInfo.fromJson(Map<String, dynamic> json) {
    return DetailsInfo(
      bookingId: json['bookingId'] ?? '',
      adventureId: json['adventureId'] ?? '',
      hospitalityId: json['hospitalityId'] ?? '',
      eventId: json['eventId'] ?? '',
      placeId: json['placeId'] ?? '',

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'adventureId': adventureId,
      'placeId': placeId,
     'eventId':eventId,

    };
  }
}
