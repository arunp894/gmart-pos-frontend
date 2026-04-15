class PurchaseSaleReportResponse {
  Purchase? purchase;
  Sell? sell;
  dynamic totalPurchaseReturn;
  dynamic totalSellReturn;
  Difference? difference;

  PurchaseSaleReportResponse(
      {this.purchase,
      this.sell,
      this.totalPurchaseReturn,
      this.totalSellReturn,
      this.difference});

  PurchaseSaleReportResponse.fromJson(Map<String, dynamic> json) {
    purchase =
        json['purchase'] != null ? Purchase.fromJson(json['purchase']) : null;
    sell = json['sell'] != null ? Sell.fromJson(json['sell']) : null;
    totalPurchaseReturn = json['total_purchase_return'];
    totalSellReturn = json['total_sell_return'];
    difference = json['difference'] != null
        ? Difference.fromJson(json['difference'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (purchase != null) {
      data['purchase'] = purchase!.toJson();
    }
    if (sell != null) {
      data['sell'] = sell!.toJson();
    }
    data['total_purchase_return'] = totalPurchaseReturn;
    data['total_sell_return'] = totalSellReturn;
    if (difference != null) {
      data['difference'] = difference!.toJson();
    }
    return data;
  }
}

class Purchase {
  String? totalPurchaseIncTax;
  String? totalPurchaseExcTax;
  int? purchaseDue;
  String? totalShippingCharges;
  String? totalAdditionalExpense;

  Purchase(
      {this.totalPurchaseIncTax,
      this.totalPurchaseExcTax,
      this.purchaseDue,
      this.totalShippingCharges,
      this.totalAdditionalExpense});

  Purchase.fromJson(Map<String, dynamic> json) {
    totalPurchaseIncTax = json['total_purchase_inc_tax'];
    totalPurchaseExcTax = json['total_purchase_exc_tax'];
    purchaseDue = json['purchase_due'];
    totalShippingCharges = json['total_shipping_charges'];
    totalAdditionalExpense = json['total_additional_expense'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_purchase_inc_tax'] = totalPurchaseIncTax;
    data['total_purchase_exc_tax'] = totalPurchaseExcTax;
    data['purchase_due'] = purchaseDue;
    data['total_shipping_charges'] = totalShippingCharges;
    data['total_additional_expense'] = totalAdditionalExpense;
    return data;
  }
}

class Sell {
  String? totalSellIncTax;
  String? totalSellExcTax;
  String? invoiceDue;
  String? totalShippingCharges;
  String? totalAdditionalExpense;

  Sell(
      {this.totalSellIncTax,
      this.totalSellExcTax,
      this.invoiceDue,
      this.totalShippingCharges,
      this.totalAdditionalExpense});

  Sell.fromJson(Map<String, dynamic> json) {
    totalSellIncTax = json['total_sell_inc_tax'];
    totalSellExcTax = json['total_sell_exc_tax'];
    invoiceDue = json['invoice_due'];
    totalShippingCharges = json['total_shipping_charges'];
    totalAdditionalExpense = json['total_additional_expense'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_sell_inc_tax'] = totalSellIncTax;
    data['total_sell_exc_tax'] = totalSellExcTax;
    data['invoice_due'] = invoiceDue;
    data['total_shipping_charges'] = totalShippingCharges;
    data['total_additional_expense'] = totalAdditionalExpense;
    return data;
  }
}

class Difference {
  double? total;
  int? due;

  Difference({this.total, this.due});

  Difference.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    due = json['due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['due'] = due;
    return data;
  }
}
