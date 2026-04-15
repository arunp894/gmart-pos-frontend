class ReportResponseModel {
  int? totalPurchaseShippingCharge;
  String? totalSellShippingCharge;
  int? totalPurchaseAdditionalExpense;
  String? totalSellAdditionalExpense;
  String? totalTransferShippingCharges;
  String? openingStock;
  String? closingStock;
  int? totalPurchase;
  String? totalPurchaseDiscount;
  String? totalPurchaseReturn;
  String? totalSell;
  String? totalSellDiscount;
  String? totalSellReturnDiscount;
  String? totalSellReturn;
  String? totalSellRoundOff;
  int? totalExpense;
  String? totalAdjustment;
  String? totalRecovered;
  String? totalRewardAmount;
  String? netProfit;
  String? grossProfit;
  String? fromDate;
  String? toDate;
  int? totalBill;
  String? first;
  String? latest;
  List<Summery>? summery;
  List<PaymentSummary>? paymentSummary;

  ReportResponseModel(
      {this.totalPurchaseShippingCharge,
      this.totalSellShippingCharge,
      this.totalPurchaseAdditionalExpense,
      this.totalSellAdditionalExpense,
      this.totalTransferShippingCharges,
      this.openingStock,
      this.closingStock,
      this.totalPurchase,
      this.totalPurchaseDiscount,
      this.totalPurchaseReturn,
      this.totalSell,
      this.totalSellDiscount,
      this.totalSellReturnDiscount,
      this.totalSellReturn,
      this.totalSellRoundOff,
      this.totalExpense,
      this.totalAdjustment,
      this.totalRecovered,
      this.totalRewardAmount,
      this.netProfit,
      this.grossProfit,
      this.fromDate,
      this.toDate,
      this.totalBill,
      this.first,
      this.latest,
      this.summery,this.paymentSummary});

  ReportResponseModel.fromJson(Map<String, dynamic> json) {
    totalPurchaseShippingCharge = json['total_purchase_shipping_charge'];
    totalSellShippingCharge = json['total_sell_shipping_charge'].toString();
    totalPurchaseAdditionalExpense = json['total_purchase_additional_expense'];
    totalSellAdditionalExpense = json['total_sell_additional_expense'].toString();
    totalTransferShippingCharges = json['total_transfer_shipping_charges'].toString();
    openingStock = json['opening_stock'].toString();
    closingStock = json['closing_stock'].toString();
    totalPurchase = json['total_purchase'];
    totalPurchaseDiscount = json['total_purchase_discount'].toString();
    totalPurchaseReturn = json['total_purchase_return'].toString();
    totalSell = json['total_sell'].toString();
    totalSellDiscount = json['total_sell_discount'].toString();
    totalSellReturnDiscount = json['total_sell_return_discount'].toString();
    totalSellReturn = json['total_sell_return'].toString();
    totalSellRoundOff = json['total_sell_round_off'].toString();
    totalExpense = json['total_expense'];
    totalAdjustment = json['total_adjustment'].toString();
    totalRecovered = json['total_recovered'].toString();
    totalRewardAmount = json['total_reward_amount'].toString();
    netProfit = json['net_profit'].toString();
    grossProfit = json['gross_profit'].toString();
    fromDate = json['from_date'].toString();
    toDate = json['to_date'].toString();
    totalBill = json['total_bill'];
    first = json['first'].toString();
    latest = json['latest'].toString();
    if (json['summery'] != null) {
      summery = <Summery>[];
      json['summery'].forEach((v) {
        summery!.add(Summery.fromJson(v));
      });
    }
    if (json['paymeny_summary'] != null) {
      paymentSummary = <PaymentSummary>[];
      json['paymeny_summary'].forEach((v) {
        paymentSummary!.add(PaymentSummary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_purchase_shipping_charge'] = totalPurchaseShippingCharge;
    data['total_sell_shipping_charge'] = totalSellShippingCharge;
    data['total_purchase_additional_expense'] = totalPurchaseAdditionalExpense;
    data['total_sell_additional_expense'] = totalSellAdditionalExpense;
    data['total_transfer_shipping_charges'] = totalTransferShippingCharges;
    data['opening_stock'] = openingStock;
    data['closing_stock'] = closingStock;
    data['total_purchase'] = totalPurchase;
    data['total_purchase_discount'] = totalPurchaseDiscount;
    data['total_purchase_return'] = totalPurchaseReturn;
    data['total_sell'] = totalSell;
    data['total_sell_discount'] = totalSellDiscount;
    data['total_sell_return_discount'] = totalSellReturnDiscount;
    data['total_sell_return'] = totalSellReturn;
    data['total_sell_round_off'] = totalSellRoundOff;
    data['total_expense'] = totalExpense;
    data['total_adjustment'] = totalAdjustment;
    data['total_recovered'] = totalRecovered;
    data['total_reward_amount'] = totalRewardAmount;
    data['net_profit'] = netProfit;
    data['gross_profit'] = grossProfit;
    data['from_date'] = fromDate;
    data['to_date'] = toDate;
    data['total_bill'] = totalBill;
    data['first'] = first;
    data['latest'] = latest;
    if (summery != null) {
      data['summery'] = summery!.map((v) => v.toJson()).toList();
    }
    if (paymentSummary != null) {
      data['paymeny_summary'] = paymentSummary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Summery {
  String? categoryName;
  String? currentStock;
  String? totalQtySold;
  String? subtotal;

  Summery(
      {this.categoryName, this.currentStock, this.totalQtySold, this.subtotal});

  Summery.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    currentStock = json['current_stock'];
    totalQtySold = json['total_qty_sold'];
    subtotal = json['subtotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_name'] = categoryName;
    data['current_stock'] = currentStock;
    data['total_qty_sold'] = totalQtySold;
    data['subtotal'] = subtotal;
    return data;
  }
}

class PaymentSummary{
  String? method;
  String? amount;

  PaymentSummary({this.method,this.amount});

  PaymentSummary.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['method'] = method;
    data['amount'] = amount;
    return data;
  }

}
