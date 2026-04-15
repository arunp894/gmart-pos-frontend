class MethodResponseModel {
  Data? data;

  MethodResponseModel({this.data});

  MethodResponseModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? cashPaid;
  String? balance;
  String? billNo;
  List<CustomerProductList>? productList;

  Data({this.cashPaid, this.balance, this.billNo, this.productList});

  Data.fromJson(Map<String, dynamic> json) {
    cashPaid = json['cashPaid'];
    balance = json['balance'];
    billNo = json['billNo'];
    if (json['productList'] != null) {
      productList = <CustomerProductList>[];
      json['productList'].forEach((v) {
        productList!.add(new CustomerProductList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cashPaid'] = this.cashPaid;
    data['balance'] = this.balance;
    data['billNo'] = this.billNo;
    if (this.productList != null) {
      data['productList'] = this.productList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerProductList {
  double? unitPrice;
  double? quantity;
  String? productVariantId;
  double? totalPrice;
  String? name;
  String? id;
  String? unit;

  CustomerProductList(
      {this.unitPrice,
      this.quantity,
      this.productVariantId,
      this.totalPrice,
      this.name,
      this.unit,
      this.id});

  CustomerProductList.fromJson(Map<String, dynamic> json) {
    unitPrice = json['unitPrice'];
    quantity = json['quantity'];
    productVariantId = json['productVariantId'];
    totalPrice = json['totalPrice'];
    name = json['name'];
    id = json['id'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitPrice'] = this.unitPrice;
    data['quantity'] = this.quantity;
    data['productVariantId'] = this.productVariantId;
    data['totalPrice'] = this.totalPrice;
    data['name'] = this.name;
    data['id'] = this.id;
    data['unit'] = this.unit;
    return data;
  }
}
