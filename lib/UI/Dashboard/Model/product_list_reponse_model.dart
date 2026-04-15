import 'package:gmart/UI/Dashboard/Model/scanned_product_response_model.dart';

class ProductListResponseModel {
  Products? products;
  List<dynamic>? allowedGroupPrices;
  bool? showPrices;
  PosSettings? posSettings;

  ProductListResponseModel(
      {this.products,
        this.allowedGroupPrices,
        this.showPrices,
        this.posSettings});

  ProductListResponseModel.fromJson(Map<String, dynamic> json) {
    products = json['products'] != null
        ? new Products.fromJson(json['products'])
        : null;
    /*if (json['allowed_group_prices'] != null) {
      allowedGroupPrices = <Null>[];
      json['allowed_group_prices'].forEach((v) {
        allowedGroupPrices!.add(new Null.fromJson(v));
      });
    }*/
    // allowedGroupPrices = json['allowed_group_prices'] ?? [];
    showPrices = json['show_prices'];
    posSettings = json['pos_settings'] != null
        ? new PosSettings.fromJson(json['pos_settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.toJson();
    }
    if (this.allowedGroupPrices != null) {
      data['allowed_group_prices'] =
          this.allowedGroupPrices!.map((v) => v.toJson()).toList();
    }
    data['show_prices'] = this.showPrices;
    if (this.posSettings != null) {
      data['pos_settings'] = this.posSettings!.toJson();
    }
    return data;
  }
}

class Products {
  int? currentPage;
  List<ProductsList>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Products(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  Products.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <ProductsList>[];
      json['data'].forEach((v) {
        data!.add(new ProductsList.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class ProductsList {
  int? productId;
  String? name;
  String? type;
  int? enableStock;
  String? productImage;
  int? variantId;
  String? variation;
  String? qtyAvailable;
  String? sellingPrice;
  String? posSellQuantityEdit;
  String? subSku;
  String? unit;
  List<Media>? media;
  List<dynamic>? groupPrices;
  List<VariationDouble>? variationDouble;
  IsTimeLimit? isTimeLimit;
  IsAgeLimit? isAgeLimit;

  ProductsList(
      {this.productId,
        this.name,
        this.type,
        this.enableStock,
        this.productImage,
        this.variantId,
        this.variation,
        this.qtyAvailable,
        this.sellingPrice,
        this.subSku,
        this.unit,
        this.media,
        this.variationDouble,
        this.groupPrices,
        this.isTimeLimit,
        this.isAgeLimit,
        this.posSellQuantityEdit});

  ProductsList.fromJson(Map<String, dynamic> json) {
    productId = int.parse(json['product_id'].toString());
    name = json['name'];
    type = json['type'];
    enableStock = int.parse(json['enable_stock'].toString());
    productImage = json['product_image'];
    variantId = int.parse(json['variations_id'].toString());
    variation = json['variation'];
    qtyAvailable = json['qty_available'];
    sellingPrice = json['selling_price'];
    subSku = json['sub_sku'];
    unit = json['unit'];
    posSellQuantityEdit = json['pos_sell_quantity_edit'];
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

  ProductsList.fromLocalJson(Map<String, dynamic> json) {
    productId = int.parse(json['product_id'].toString());
    name = json['name'];
    type = json['type'];
    variantId = int.parse(json['variation_id'].toString());
    variation = json['variation'];
    qtyAvailable = json['qty_available'];
    sellingPrice = json['default_selling_price'];
    subSku = json['barcode'];
    unit = json['unit'];
    posSellQuantityEdit = json['pos_edit'].toString();
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
    data['product_image'] = this.productImage;
    data['variations_id'] = this.variantId;
    data['variation'] = this.variation;
    data['qty_available'] = this.qtyAvailable;
    data['selling_price'] = this.sellingPrice;
    data['sub_sku'] = this.subSku;
    data['unit'] = this.unit;
    data['pos_sell_quantity_edit'] = this.posSellQuantityEdit;
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
    /*if (this.groupPrices != null) {
      data['group_prices'] = this.groupPrices!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}

class VariationDouble {
  int? id;
  String? name;
  String? productId;
  String? subSku;
  String? barcode;
  String? variationId;
  int? variationValueId;
  String? profitPercent;
  String? defaultSellPrice;
  String? unit;
  String? sellPriceIncTax;
  String? conRate;

  VariationDouble(
      {this.id,
        this.name,
        this.productId,
        this.subSku,
        this.barcode,
        this.variationId,
        this.variationValueId,
        this.profitPercent,
        this.defaultSellPrice,
        this.sellPriceIncTax,
        this.conRate,
        this.unit});

  VariationDouble.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productId = json['product_id'] != null ? json['product_id'].toString() : "0";
    subSku = json['sub_sku'];
    barcode = json['barcode'];
    variationId = json['variation_id'] != null ? json['variation_id'].toString() : "0";
    // variationValueId = json['variation_value_id'] ?? 0;
    variationValueId = int.tryParse(json['variation_value_id'].toString()) ?? 0;
    profitPercent = json['profit_percent'];
    defaultSellPrice = json['default_sell_price'];
    sellPriceIncTax = json['sell_price_inc_tax'];
    conRate = json['con_rate'];
    unit = json['unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['product_id'] = this.productId;
    data['sub_sku'] = this.subSku;
    data['barcode'] = this.barcode;
    data['variation_id'] = this.variationId;
    data['variation_value_id'] = this.variationValueId;
    data['profit_percent'] = this.profitPercent;
    data['default_sell_price'] = this.defaultSellPrice;
    data['sell_price_inc_tax'] = this.sellPriceIncTax;
    data['con_rate'] = this.conRate;
    data['unit'] = this.unit;
    return data;
  }
}

class Media {
  int? id;
  int? businessId;
  String? fileName;
  String? description;
  int? uploadedBy;
  String? modelType;
  String? modelMediaType;
  int? modelId;
  String? createdAt;
  String? updatedAt;
  String? displayName;
  String? displayUrl;

  Media(
      {this.id,
        this.businessId,
        this.fileName,
        this.description,
        this.uploadedBy,
        this.modelType,
        this.modelMediaType,
        this.modelId,
        this.createdAt,
        this.updatedAt,
        this.displayName,
        this.displayUrl});

  Media.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    fileName = json['file_name'];
    description = json['description'];
    uploadedBy = json['uploaded_by'];
    modelType = json['model_type'];
    modelMediaType = json['model_media_type'];
    modelId = json['model_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    displayName = json['display_name'];
    displayUrl = json['display_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['file_name'] = this.fileName;
    data['description'] = this.description;
    data['uploaded_by'] = this.uploadedBy;
    data['model_type'] = this.modelType;
    data['model_media_type'] = this.modelMediaType;
    data['model_id'] = this.modelId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['display_name'] = this.displayName;
    data['display_url'] = this.displayUrl;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}

class PosSettings {
  String? amountRoundingMethod;
  String? cmmsnCalculationType;
  String? razorPayKeyId;
  String? razorPayKeySecret;
  String? stripePublicKey;
  String? stripeSecretKey;
  String? customerDisplayScreen;
  String? displayScreenHeading;
  String? cashDenominations;
  String? enableCashDenominationOn;
  List<String>? enableCashDenominationForPaymentMethods;
  String? cashDenominationStrictCheck;
  String? carouselImage1;
  dynamic showStock;
  dynamic enableShippping;
  int? displaySku;
  int? displayProductImage;
  int? disablePayCheckout;
  int? disableDraft;
  int? disableExpressCheckout;
  int? hideProductSuggestion;
  int? hideRecentTrans;
  int? disableDiscount;
  int? disableOrderTax;
  int? isPosSubtotalEditable;

  PosSettings(
      {this.amountRoundingMethod,
        this.cmmsnCalculationType,
        this.razorPayKeyId,
        this.razorPayKeySecret,
        this.stripePublicKey,
        this.stripeSecretKey,
        this.customerDisplayScreen,
        this.displayScreenHeading,
        this.cashDenominations,
        this.enableCashDenominationOn,
        this.enableCashDenominationForPaymentMethods,
        this.cashDenominationStrictCheck,
        this.carouselImage1,
        this.showStock,
        this.enableShippping,
        this.displaySku,
        this.displayProductImage,
        this.disablePayCheckout,
        this.disableDraft,
        this.disableExpressCheckout,
        this.hideProductSuggestion,
        this.hideRecentTrans,
        this.disableDiscount,
        this.disableOrderTax,
        this.isPosSubtotalEditable});

  PosSettings.fromJson(Map<String, dynamic> json) {
    amountRoundingMethod = json['amount_rounding_method'];
    cmmsnCalculationType = json['cmmsn_calculation_type'];
    razorPayKeyId = json['razor_pay_key_id'];
    razorPayKeySecret = json['razor_pay_key_secret'];
    stripePublicKey = json['stripe_public_key'];
    stripeSecretKey = json['stripe_secret_key'];
    customerDisplayScreen = json['customer_display_screen'];
    displayScreenHeading = json['display_screen_heading'];
    cashDenominations = json['cash_denominations'];
    enableCashDenominationOn = json['enable_cash_denomination_on'];
    enableCashDenominationForPaymentMethods =
        json['enable_cash_denomination_for_payment_methods'].cast<String>();
    cashDenominationStrictCheck = json['cash_denomination_strict_check'];
    carouselImage1 = json['carousel_image_1'];
    showStock = json['show_stock'];
    enableShippping = json['enable_shippping'];
    displaySku = json['display_sku'];
    displayProductImage = json['display_product_image'];
    disablePayCheckout = json['disable_pay_checkout'];
    disableDraft = json['disable_draft'];
    disableExpressCheckout = json['disable_express_checkout'];
    hideProductSuggestion = json['hide_product_suggestion'];
    hideRecentTrans = json['hide_recent_trans'];
    disableDiscount = json['disable_discount'];
    disableOrderTax = json['disable_order_tax'];
    isPosSubtotalEditable = json['is_pos_subtotal_editable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount_rounding_method'] = this.amountRoundingMethod;
    data['cmmsn_calculation_type'] = this.cmmsnCalculationType;
    data['razor_pay_key_id'] = this.razorPayKeyId;
    data['razor_pay_key_secret'] = this.razorPayKeySecret;
    data['stripe_public_key'] = this.stripePublicKey;
    data['stripe_secret_key'] = this.stripeSecretKey;
    data['customer_display_screen'] = this.customerDisplayScreen;
    data['display_screen_heading'] = this.displayScreenHeading;
    data['cash_denominations'] = this.cashDenominations;
    data['enable_cash_denomination_on'] = this.enableCashDenominationOn;
    data['enable_cash_denomination_for_payment_methods'] =
        this.enableCashDenominationForPaymentMethods;
    data['cash_denomination_strict_check'] = this.cashDenominationStrictCheck;
    data['carousel_image_1'] = this.carouselImage1;
    data['show_stock'] = this.showStock;
    data['enable_shippping'] = this.enableShippping;
    data['display_sku'] = this.displaySku;
    data['display_product_image'] = this.displayProductImage;
    data['disable_pay_checkout'] = this.disablePayCheckout;
    data['disable_draft'] = this.disableDraft;
    data['disable_express_checkout'] = this.disableExpressCheckout;
    data['hide_product_suggestion'] = this.hideProductSuggestion;
    data['hide_recent_trans'] = this.hideRecentTrans;
    data['disable_discount'] = this.disableDiscount;
    data['disable_order_tax'] = this.disableOrderTax;
    data['is_pos_subtotal_editable'] = this.isPosSubtotalEditable;
    return data;
  }
}
