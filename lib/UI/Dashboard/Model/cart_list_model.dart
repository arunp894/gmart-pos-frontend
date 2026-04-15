class CartListModel {
  List<ProductList>? productList;

  // Calculation? calculation;
  String? billNo = "";
  String? cashPaid;
  String? balance;
  double? discountAmount = 0.0;

  CartListModel(
      {this.productList,
      // this.calculation,
      this.billNo = "",
      this.balance,
      this.cashPaid,
      this.discountAmount});

  CartListModel.fromJson(Map<String, dynamic> json) {
    if (json['productList'] != null) {
      productList = <ProductList>[];
      json['productList'].forEach((v) {
        productList!.add(ProductList.fromJson(v));
      });
    }
    // calculation = json['calculation'] != null
    //     ? Calculation.fromJson(json['calculation'])
    //     : null;
    billNo = json['billNo'];
    cashPaid = json['cashPaid'];
    balance = json['balance'];
    discountAmount = json['discountAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['billNo'] = billNo;
    if (productList != null) {
      data['productList'] = productList!.map((v) => v.toJson()).toList();
    }
    // if (calculation != null) {
    //   data['calculation'] = calculation!.toJson();
    // }
    data['cashPaid'] = cashPaid;
    data['balance'] = balance;
    data['discountAmount'] = discountAmount;
    return data;
  }
}

class ProductList {
  String? id;
  double? quantity;
  String? name;
  double? unitPrice;
  double? totalPrice;
  String? productVariantId;
  String? unit;
  int? variationDoubleId;
  String? isEdit;

  ProductList(
      {this.quantity,
      this.name,
      this.unitPrice,
      this.totalPrice,
      this.id,
      this.unit,
      this.productVariantId,
      this.variationDoubleId,
      this.isEdit});

  ProductList.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    name = json['name'];
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    id = json['id'];
    unit = json['unit'];
    productVariantId = json['productVariantId'];
    variationDoubleId = json['variationDoubleId'];
    isEdit = json['isEdit'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['name'] = name;
    data['unitPrice'] = unitPrice;
    data['totalPrice'] = totalPrice;
    data['id'] = id;
    data['unit'] = unit;
    data['productVariantId'] = productVariantId;
    data['variationDoubleId'] = variationDoubleId;
    return data;
  }
}

class Calculation {
  double? discountAmount = 0.0;
  double? grandTotal = 0.0;

  Calculation({this.discountAmount = 0.0, this.grandTotal = 0.0});

  Calculation.fromJson(Map<String, dynamic> json) {
    discountAmount = json['discountAmount'];
    grandTotal = json['grandTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['discountAmount'] = discountAmount;
    data['grandTotal'] = grandTotal;
    return data;
  }
}
