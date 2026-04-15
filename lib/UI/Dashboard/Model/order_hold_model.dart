class OrderHoldModel {
  List<OrderedProduct>? product;
  String? voucher;
  String? discountType;
  String? discountValue;
  String? discountPrice;
  double? total;

  OrderHoldModel(
      {this.product,
      this.voucher,
      this.discountType,
      this.discountValue,
      this.discountPrice,
      this.total});

  OrderHoldModel.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = <OrderedProduct>[];
      json['product'].forEach((v) {
        product!.add(OrderedProduct.fromJson(v));
      });
    }
    voucher = json['voucher'];
    discountType = json['discount_type'];
    discountValue = json['discount_value'];
    discountPrice = json['discount_price'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.map((v) => v.toJson()).toList();
    }
    data['voucher'] = voucher;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['discount_price'] = discountPrice;
    data['total'] = total;
    return data;
  }
}

class OrderedProduct {
  int? productId;
  double? quantity;
  double? sellerPrice;
  int? productVariablesId;

  OrderedProduct(
      {this.productId,
      this.quantity,
      this.sellerPrice,
      this.productVariablesId});

  OrderedProduct.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
    sellerPrice = json['seller_price'];
    productVariablesId = json['ProductVariables_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['quantity'] = quantity;
    data['seller_price'] = sellerPrice;
    data['ProductVariables_id'] = productVariablesId;
    return data;
  }
}
