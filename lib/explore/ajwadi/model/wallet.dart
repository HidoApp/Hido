import 'package:ajwad_v4/explore/ajwadi/model/transaction.dart';

class Wallet {
  final double? totalInitiatedAmount;
  final List<Transaction>? transactions;

  Wallet({
    this.totalInitiatedAmount,
    this.transactions,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      totalInitiatedAmount: (json['totalInitiatedAmount'] is int)
          ? double.parse((json['totalInitiatedAmount'] as int)
              .toDouble()
              .toStringAsFixed(1))
          : double.parse((json['totalInitiatedAmount'] as double? ?? 0.0)
              .toStringAsFixed(1)),
      transactions: json['transactions'] != null
          ? (json['transactions'] as List)
              .map((e) => Transaction.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalInitiatedAmount': totalInitiatedAmount,
      'transactions':
          transactions?.map((transaction) => transaction.toJson()).toList(),
    };
  }
}
