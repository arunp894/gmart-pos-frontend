import 'package:gmart/UI/Dashboard/Model/product_list_reponse_model.dart';

class ScannedProductResponseModel {
  List<ScanProduct>? product;

  ScannedProductResponseModel({this.product});

  ScannedProductResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['product'] != null) {
      product = <ScanProduct>[];
      json['product'].forEach((v) {
        product!.add(new ScanProduct.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['product'] = this.product!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScanProduct {
  int? productId;
  String? name;
  String? type;
  int? enableStock;
  int? variationId;
  String? variation;
  dynamic qtyAvailable;
  dynamic sellingPrice;
  String? unit;
  String? barcode;
  String? posSellQuantityEdit;
  String? imageUrl;
  List<VariationDouble>? variationDouble;
  IsTimeLimit? isTimeLimit;
  IsAgeLimit? isAgeLimit;

  ScanProduct(
      {this.productId,
        this.name,
        this.type,
        this.enableStock,
        this.variationId,
        this.variation,
        this.qtyAvailable,
        this.sellingPrice,
        this.unit,
        this.imageUrl,
        this.variationDouble,
        this.isTimeLimit,
        this.isAgeLimit,
        this.posSellQuantityEdit,
        this.barcode});

  ScanProduct.fromJson(Map<String, dynamic> json) {
    productId = int.parse(json['product_id'] == null
        ? "0"
        : json['product_id'] == ""
        ? "0"
        : json['product_id'].toString());
    name = json['name'];
    type = json['type'];
    // enableStock = int.parse(json['enable_stock'] ?? "0");
    enableStock = int.parse(json['enable_stock'] == null
        ? "0"
        : json['enable_stock'] == ""
        ? "0"
        : json['enable_stock'].toString());
    // variationId = int.parse(json['variation_id'] ?? "0");
    variationId = int.parse(json['variation_id'] == null
        ? "0"
        : json['variation_id'] == ""
        ? "0"
        : json['variation_id'].toString());
    variation = json['variation'];
    qtyAvailable = json['qty_available'];
    sellingPrice = json['selling_price'];
    unit = json['unit'];
    barcode = json['barcode'];
    posSellQuantityEdit = json['pos_sell_quantity_edit'];
    imageUrl = json['image_url'];
    if (json['variation_double'] != null) {
      variationDouble = <VariationDouble>[];
      json['variation_double'].forEach((v) {
        variationDouble!.add(new VariationDouble.fromJson(v));
      });
    }
    isTimeLimit = json['is_time_limit'] != null
        ? new IsTimeLimit.fromJson(json['is_time_limit'])
        : null;
    isAgeLimit = json['is_age_limit'] != null
        ? new IsAgeLimit.fromJson(json['is_age_limit'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['enable_stock'] = this.enableStock;
    data['variations_id'] = this.variationId;
    data['variation'] = this.variation;
    data['qty_available'] = this.qtyAvailable;
    data['selling_price'] = this.sellingPrice;
    data['unit'] = this.unit;
    data['barcode'] = this.barcode;
    data['image_url'] = this.imageUrl;
    if (this.variationDouble != null) {
      data['variation_double'] =
          this.variationDouble!.map((v) => v.toJson()).toList();
    }
    if (this.isTimeLimit != null) {
      data['is_time_limit'] = this.isTimeLimit!.toJson();
    }
    if (this.isAgeLimit != null) {
      data['is_age_limit'] = this.isAgeLimit!.toJson();
    }
    return data;
  }
}

class IsTimeLimit {
  String? fromTime;
  String? toTime;
  String? timeDescription;

  IsTimeLimit({this.fromTime, this.toTime, this.timeDescription});

  IsTimeLimit.fromJson(Map<String, dynamic> json) {
    fromTime = json['from_time'];
    toTime = json['to_time'];
    timeDescription = json['time_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from_time'] = this.fromTime;
    data['to_time'] = this.toTime;
    data['time_description'] = this.timeDescription;
    return data;
  }
}

class IsAgeLimit {
  String? age;
  String? ageLimitDescription;

  IsAgeLimit({this.age, this.ageLimitDescription});

  IsAgeLimit.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    ageLimitDescription = json['age_limit_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['age_limit_description'] = this.ageLimitDescription;
    return data;
  }
}