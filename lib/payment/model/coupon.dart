class Coupon {
  Coupon({
    this.id,
    this.description,
    this.type,
    this.allowMultipleUses,
    this.createdById,
    this.code,
    this.discountAmount,
    this.discountPercentage,
    this.maxDiscount,
    this.minSpend,
    this.usageLimit,
    this.validFrom,
    this.validTo,
    this.status,
    this.couponStatus,
    this.created,
  });

  final String? id;
  final String? description;
  final String? type;
  final bool? allowMultipleUses;
  final String? createdById;
  final String? code;
  final int? discountAmount;
  final int? discountPercentage;
  final int? maxDiscount;
  final int? minSpend;
  final int? usageLimit;
  final String? validFrom;
  final String? validTo;
  final String? status;
  final String? couponStatus;
  final String? created;

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json["id"],
      description: json["description"],
      type: json["type"],
      allowMultipleUses: json["allowMultipleUses"],
      createdById: json["createdById"],
      code: json["code"],
      discountAmount: json["discountAmount"],
      discountPercentage: json["discountPercentage"],
      maxDiscount: json["maxDiscount"],
      minSpend: json["minSpend"],
      usageLimit: json["usageLimit"],
      validFrom: json['validFrom'],
      validTo: json['validTo'],
      status: json["status"],
      couponStatus: json["couponStatus"],
      created: json['created'],
    );
  }
}
