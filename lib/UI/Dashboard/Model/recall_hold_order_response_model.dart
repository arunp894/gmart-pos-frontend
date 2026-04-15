import 'package:gmart/UI/Dashboard/Model/recall_hold_order_details_response_model.dart';

class RecallHoldOrderResponseModel {
  List<Transactions>? transactions;

  RecallHoldOrderResponseModel({this.transactions});

  RecallHoldOrderResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(new Transactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.transactions != null) {
      data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  int? id;
  String? type;
  String? invoiceNo;
  String? transactionDate;
  String? finalTotal;
  String? isSuspend;
  List<SellDetails>? sellDetails;
  Contact? contact;
  List<PaymentLines>? paymentLines;
  String? discountType;
  String? discountAmount;

  Transactions(
      {this.id,
      this.type,
      this.invoiceNo,
      this.transactionDate,
      this.finalTotal,
      this.sellDetails,
      this.paymentLines,
      this.discountType,
      this.discountAmount,this.isSuspend,this.contact});

  Transactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    invoiceNo = json['invoice_no'];
    transactionDate = json['transaction_date'];
    finalTotal = json['final_total'];
    isSuspend = json['is_suspend'].toString();
    if (json['sell_details'] != null) {
      sellDetails = <SellDetails>[];
      json['sell_details'].forEach((v) {
        sellDetails!.add(new SellDetails.fromJson(v));
      });
    }
    if (json['payment_lines'] != null) {
      paymentLines = <PaymentLines>[];
      json['payment_lines'].forEach((v) {
        paymentLines!.add(new PaymentLines.fromJson(v));
      });
    }
    contact =
    json['contact'] != null ? new Contact.fromJson(json['contact']) : null;
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['invoice_no'] = this.invoiceNo;
    data['transaction_date'] = this.transactionDate;
    data['final_total'] = this.finalTotal;
    data['is_suspend'] = this.isSuspend;
    if (this.sellDetails != null) {
      data['sell_details'] = this.sellDetails!.map((v) => v.toJson()).toList();
    }
    if (this.paymentLines != null) {
      data['payment_lines'] =
          this.paymentLines!.map((v) => v.toJson()).toList();
    }
    if (this.contact != null) {
      data['contact'] = this.contact!.toJson();
    }
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    return data;
  }
}
class Contact {
  String? name;
  String? mobile;

  Contact({this.name, this.mobile});

  Contact.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    return data;
  }
}

class PaymentLines {
  String? method;
  String? amount;
  String? isReturn;

  PaymentLines({this.method, this.amount, this.isReturn});

  PaymentLines.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    amount = json['amount'];
    isReturn = json['is_return'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    data['amount'] = this.amount;
    data['is_return'] = this.isReturn;
    return data;
  }
}
