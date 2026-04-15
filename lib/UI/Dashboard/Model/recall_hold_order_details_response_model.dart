class RecallHoldOrderDetailsResponseModel {
  List<SellDetails>? sellDetails;

  RecallHoldOrderDetailsResponseModel({this.sellDetails});

  RecallHoldOrderDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['sell_details'] != null) {
      sellDetails = <SellDetails>[];
      json['sell_details'].forEach((v) {
        sellDetails!.add(new SellDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sellDetails != null) {
      data['sell_details'] = this.sellDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SellDetails {
  String? productName;
  int? productId;
  int? enableStock;
  String? productType;
  String? productVariationName;
  int? variationId;
  String? unit;
  String? defaultSellPrice;
  String? unitPriceBeforeDiscount;
  String? sellPriceIncTax;
  String? quantityOrdered;
  String? posSellQuantityEdit;

  SellDetails(
      {this.productName,
      this.productId,
      this.enableStock,
      this.productType,
      this.productVariationName,
      this.variationId,
      this.defaultSellPrice,
      this.unit,
      this.unitPriceBeforeDiscount,
      this.sellPriceIncTax,
      this.quantityOrdered,
      this.posSellQuantityEdit});

  SellDetails.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    productId = int.parse(json['product_id'].toString());
    // enableStock = int.parse(json['enable_stock'] ?? "0");
    enableStock = int.parse(json['enable_stock'] == null
        ? "0"
        : json['enable_stock'] == ""
            ? "0"
            : json['enable_stock'].toString());
    productType = json['product_type'];
    productVariationName = json['product_variation_name'];
    variationId = int.parse(json['variation_id'] == null
        ? "0"
        : json['variation_id'] == ""
            ? "0"
            : json['variation_id'].toString());
    defaultSellPrice = json['default_sell_price'];
    unitPriceBeforeDiscount = json['unit_price_before_discount'];
    sellPriceIncTax = json['sell_price_inc_tax'];
    quantityOrdered = json['quantity_ordered'];
    unit = json['unit'];
    posSellQuantityEdit = json['pos_sell_quantity_edit'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['product_id'] = this.productId;
    data['enable_stock'] = this.enableStock;
    data['product_type'] = this.productType;
    data['product_variation_name'] = this.productVariationName;
    data['variation_id'] = this.variationId;
    data['default_sell_price'] = this.defaultSellPrice;
    data['unit_price_before_discount'] = this.unitPriceBeforeDiscount;
    data['sell_price_inc_tax'] = this.sellPriceIncTax;
    data['quantity_ordered'] = this.quantityOrdered;
    data['unit'] = this.unit;
    data['pos_sell_quantity_edit'] = this.posSellQuantityEdit;
    return data;
  }
}
