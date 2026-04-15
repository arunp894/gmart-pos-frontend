class CustomReportModel {
  String? startBill;
  String? endBill;
  String? totalBill;
  String? totalSale;
  String? netSale;
  List<DSummery>? summery;
  List<PSummery>? pSummery;

  CustomReportModel(
      {this.startBill,
      this.endBill,
      this.totalBill,
      this.totalSale,
      this.netSale,
      this.summery,
      this.pSummery});

  CustomReportModel.fromJson(Map<String, dynamic> json) {
    startBill = json['start_bill'];
    endBill = json['end_bill'];
    totalBill = json['total_bill'];
    totalSale = json['total_sale'];
    netSale = json['net_sale'];
    if (json['summery'] != null) {
      summery = <DSummery>[];
      json['summery'].forEach((v) {
        summery!.add(DSummery.fromJson(v));
      });
    }
    if (json['p_summery'] != null) {
      pSummery = <PSummery>[];
      json['p_summery'].forEach((v) {
        pSummery!.add(PSummery.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start_bill'] = startBill;
    data['end_bill'] = endBill;
    data['total_bill'] = totalBill;
    data['total_sale'] = totalSale;
    data['net_sale'] = netSale;
    if (summery != null) {
      data['summery'] = summery!.map((v) => v.toJson()).toList();
    }
    if (pSummery != null) {
      data['p_summery'] = pSummery!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DSummery {
  String? categoryName;
  String? totalQtySold;
  String? subtotal;

  DSummery({this.categoryName, this.totalQtySold, this.subtotal});

  DSummery.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    totalQtySold = json['total_qty_sold'];
    subtotal = json['subtotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_name'] = categoryName;
    data['total_qty_sold'] = totalQtySold;
    data['subtotal'] = subtotal;
    return data;
  }
}

class PSummery {
  String? method;
  String? amount;

  PSummery({this.method, this.amount});

  PSummery.fromJson(Map<String, dynamic> json) {
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
