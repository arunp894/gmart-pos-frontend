class PaymentModel {
  List<Payment>? payment;
  String? discountType;

  PaymentModel({this.payment, this.discountType});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    if (json['payment'] != null) {
      payment = <Payment>[];
      json['payment'].forEach((v) {
        payment!.add(Payment.fromJson(v));
      });
    }
    discountType = json['discount_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (payment != null) {
      data['payment'] = payment!.map((v) => v.toJson()).toList();
    }
    data['discount_type'] = discountType;
    return data;
  }
}

class Payment {
  String? amount;
  String? method;

  Payment({this.amount, this.method});

  Payment.fromJson(Map<String, dynamic> json) {
    amount = json['amount'].toString();
    method = json['method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['method'] = method;
    return data;
  }
}
