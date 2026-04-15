class CashRegisterDetailsResponseModel {
  RegisterDetails? registerDetails;
  Details? details;

  CashRegisterDetailsResponseModel({this.registerDetails, this.details});

  CashRegisterDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    registerDetails = json['register_details'] != null
        ? new RegisterDetails.fromJson(json['register_details'])
        : null;
    details =
        json['details'] != null ? new Details.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.registerDetails != null) {
      data['register_details'] = this.registerDetails!.toJson();
    }
    if (this.details != null) {
      data['details'] = this.details!.toJson();
    }
    return data;
  }
}

class RegisterDetails {
  String? openTime;
  String? closedAt;
  String? closingNote;
  String? cashInHand;
  String? totalSale;
  String? totalExpense;
  String? totalCash;
  String? totalCashExpense;
  String? totalPayNow;
  String? totalPayNowExpense;
  String? totalCheque;
  String? totalChequeExpense;
  String? totalCard;
  String? totalCardExpense;
  String? totalBankTransfer;
  String? totalBankTransferExpense;
  String? totalRefund;
  String? totalCashRefund;
  String? totalChequeRefund;
  String? totalCardRefund;
  String? totalBankTransferRefund;
  String? totalCheques;
  String? totalCardSlips;
  String? totalOther;
  String? totalOtherExpense;

  RegisterDetails(
      {this.openTime,
      this.closedAt,
      this.closingNote,
      this.cashInHand,
      this.totalSale,
      this.totalExpense,
      this.totalCash,
      this.totalCashExpense,
      this.totalPayNow,
      this.totalPayNowExpense,
      this.totalCheque,
      this.totalChequeExpense,
      this.totalCard,
      this.totalCardExpense,
      this.totalBankTransfer,
      this.totalBankTransferExpense,
      this.totalRefund,
      this.totalCashRefund,
      this.totalChequeRefund,
      this.totalCardRefund,
      this.totalBankTransferRefund,
      this.totalCheques,
      this.totalCardSlips,
      this.totalOther,
      this.totalOtherExpense});

  RegisterDetails.fromJson(Map<String, dynamic> json) {
    openTime = json['open_time'];
    closedAt = json['closed_at'];
    closingNote = json['closing_note'];
    cashInHand = json['cash_in_hand'];
    totalSale = json['total_sale'];
    totalExpense = json['total_expense'];
    totalCash = json['total_cash'];
    totalCashExpense = json['total_cash_expense'];
    totalPayNow = json['total_pay_now'];
    totalPayNowExpense = json['total_pay_now_expense'];
    totalCheque = json['total_cheque'];
    totalChequeExpense = json['total_cheque_expense'];
    totalCard = json['total_card'];
    totalCardExpense = json['total_card_expense'];
    totalBankTransfer = json['total_bank_transfer'];
    totalBankTransferExpense = json['total_bank_transfer_expense'];
    totalOther = json['total_other'];
    totalOtherExpense = json['total_other_expense'];
    totalRefund = json['total_refund'];
    totalCashRefund = json['total_cash_refund'];
    totalChequeRefund = json['total_cheque_refund'];
    totalCardRefund = json['total_card_refund'];
    totalBankTransferRefund = json['total_bank_transfer_refund'];
    totalCheques = json['total_cheques'];
    totalCardSlips = json['total_card_slips'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['open_time'] = this.openTime;
    data['closed_at'] = this.closedAt;
    data['closing_note'] = this.closingNote;
    data['cash_in_hand'] = this.cashInHand;
    data['total_sale'] = this.totalSale;
    data['total_expense'] = this.totalExpense;
    data['total_cash'] = this.totalCash;
    data['total_cash_expense'] = this.totalCashExpense;
    data['total_pay_now'] = this.totalPayNow;
    data['total_pay_now_expense'] = this.totalPayNowExpense;
    data['total_cheque'] = this.totalCheque;
    data['total_cheque_expense'] = this.totalChequeExpense;
    data['total_card'] = this.totalCard;
    data['total_card_expense'] = this.totalCardExpense;
    data['total_bank_transfer'] = this.totalBankTransfer;
    data['total_bank_transfer_expense'] = this.totalBankTransferExpense;
    data['total_refund'] = this.totalRefund;
    data['total_cash_refund'] = this.totalCashRefund;
    data['total_cheque_refund'] = this.totalChequeRefund;
    data['total_card_refund'] = this.totalCardRefund;
    data['total_bank_transfer_refund'] = this.totalBankTransferRefund;
    data['total_cheques'] = this.totalCheques;
    data['total_card_slips'] = this.totalCardSlips;
    return data;
  }
}

class Details {
  List<ProductDetailsByBrand>? productDetailsByBrand;
  TransactionDetails? transactionDetails;
  List<ProductDetails>? productDetails;
  List<ProductDetailsVoid>? productDetailsVoid;
  List<ProductDetailsByCategory>? productDetailsByCategory;
  List<HourelySales>? hourelySales;
  String? firstBillNo;
  String? lastBillNo;
  int? totalBills;

  Details(
      {this.productDetailsByBrand,
      this.transactionDetails,
      this.productDetails,
      this.productDetailsVoid,
      this.hourelySales,
      this.firstBillNo,
      this.lastBillNo,
      this.totalBills});

  Details.fromJson(Map<String, dynamic> json) {
    if (json['product_details_by_brand'] != null) {
      productDetailsByBrand = <ProductDetailsByBrand>[];
      json['product_details_by_brand'].forEach((v) {
        productDetailsByBrand!.add(new ProductDetailsByBrand.fromJson(v));
      });
    }
    transactionDetails = json['transaction_details'] != null
        ? new TransactionDetails.fromJson(json['transaction_details'])
        : null;
    if (json['product_details'] != null) {
      productDetails = <ProductDetails>[];
      json['product_details'].forEach((v) {
        productDetails!.add(new ProductDetails.fromJson(v));
      });
    }
    if (json['product_details_void'] != null) {
      productDetailsVoid = <ProductDetailsVoid>[];
      json['product_details_void'].forEach((v) {
        productDetailsVoid!.add(new ProductDetailsVoid.fromJson(v));
      });
    }
    if (json['product_details_by_category'] != null) {
      productDetailsByCategory = <ProductDetailsByCategory>[];
      json['product_details_by_category'].forEach((v) {
        productDetailsByCategory!.add(new ProductDetailsByCategory.fromJson(v));
      });
    }
    if (json['Hourely_sales'] != null) {
      hourelySales = <HourelySales>[];
      json['Hourely_sales'].forEach((v) {
        hourelySales!.add(new HourelySales.fromJson(v));
      });
    }
    firstBillNo = json['first_bill_no'];
    lastBillNo = json['last_bill_no'];
    totalBills = json['total_bills'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productDetailsByBrand != null) {
      data['product_details_by_brand'] =
          this.productDetailsByBrand!.map((v) => v.toJson()).toList();
    }
    if (this.transactionDetails != null) {
      data['transaction_details'] = this.transactionDetails!.toJson();
    }
    if (this.productDetails != null) {
      data['product_details'] =
          this.productDetails!.map((v) => v.toJson()).toList();
    }
    if (this.productDetailsVoid != null) {
      data['product_details_void'] =
          this.productDetailsVoid!.map((v) => v.toJson()).toList();
    }
    if (this.productDetailsByCategory != null) {
      data['product_details_by_category'] =
          this.productDetailsByCategory!.map((v) => v.toJson()).toList();
    }
    if (this.hourelySales != null) {
      data['Hourely_sales'] =
          this.hourelySales!.map((v) => v.toJson()).toList();
    }
    data['first_bill_no'] = this.firstBillNo;
    data['last_bill_no'] = this.lastBillNo;
    data['total_bills'] = this.totalBills;
    return data;
  }
}

class HourelySales {
  String? range;
  String? ordersCount;
  String? itemsCount;
  String? totalAmount;

  HourelySales(
      {this.range, this.ordersCount, this.itemsCount, this.totalAmount});

  HourelySales.fromJson(Map<String, dynamic> json) {
    range = json['range'].toString();
    ordersCount = json['orders_count'].toString();
    itemsCount = json['items_count'].toString();
    totalAmount = json['total_amount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['range'] = this.range;
    data['orders_count'] = this.ordersCount;
    data['items_count'] = this.itemsCount;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class ProductDetailsByCategory {
  String? categoryName;
  String? totalQuantity;
  String? totalAmount;

  ProductDetailsByCategory(
      {this.categoryName, this.totalQuantity, this.totalAmount});

  ProductDetailsByCategory.fromJson(Map<String, dynamic> json) {
    categoryName = json['category_name'];
    totalQuantity = json['total_quantity'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_name'] = this.categoryName;
    data['total_quantity'] = this.totalQuantity;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class ProductDetailsVoid {
  String? productName;
  String? productType;
  String? variationName;
  String? productVariationName;
  String? productCode;
  String? sku;
  String? subSku;
  String? totalQuantity;
  String? totalAmount;

  ProductDetailsVoid(
      {this.productName,
      this.productType,
      this.variationName,
      this.productVariationName,
      this.productCode,
      this.sku,
      this.subSku,
      this.totalQuantity,
      this.totalAmount});

  ProductDetailsVoid.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    productType = json['product_type'];
    variationName = json['variation_name'];
    productVariationName = json['product_variation_name'];
    productCode = json['product_code'];
    sku = json['sku'];
    subSku = json['sub_sku'];
    totalQuantity = json['total_quantity'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['product_type'] = this.productType;
    data['variation_name'] = this.variationName;
    data['product_variation_name'] = this.productVariationName;
    data['product_code'] = this.productCode;
    data['sku'] = this.sku;
    data['sub_sku'] = this.subSku;
    data['total_quantity'] = this.totalQuantity;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class ProductDetailsByBrand {
  String? brandName;
  String? totalQuantity;
  String? totalAmount;

  ProductDetailsByBrand({this.brandName, this.totalQuantity, this.totalAmount});

  ProductDetailsByBrand.fromJson(Map<String, dynamic> json) {
    brandName = json['brand_name'];
    totalQuantity = json['total_quantity'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['brand_name'] = this.brandName;
    data['total_quantity'] = this.totalQuantity;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class TransactionDetails {
  String? totalTax;
  String? totalDiscount;
  String? totalSales;
  String? totalShippingCharges;

  TransactionDetails(
      {this.totalTax,
      this.totalDiscount,
      this.totalSales,
      this.totalShippingCharges});

  TransactionDetails.fromJson(Map<String, dynamic> json) {
    totalTax = json['total_tax'];
    totalDiscount = json['total_discount'];
    totalSales = json['total_sales'];
    totalShippingCharges = json['total_shipping_charges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_tax'] = this.totalTax;
    data['total_discount'] = this.totalDiscount;
    data['total_sales'] = this.totalSales;
    data['total_shipping_charges'] = this.totalShippingCharges;
    return data;
  }
}

class ProductDetails {
  String? productName;
  String? productType;
  String? variationName;
  String? productVariationName;
  String? productCode;
  String? sku;
  String? subSku;
  String? totalQuantity;
  String? totalAmount;

  ProductDetails(
      {this.productName,
      this.productType,
      this.variationName,
      this.productVariationName,
      this.productCode,
      this.sku,
      this.subSku,
      this.totalQuantity,
      this.totalAmount});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    productName = json['product_name'];
    productType = json['product_type'];
    variationName = json['variation_name'];
    productVariationName = json['product_variation_name'];
    productCode = json['product_code'];
    sku = json['sku'];
    subSku = json['sub_sku'];
    totalQuantity = json['total_quantity'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_name'] = this.productName;
    data['product_type'] = this.productType;
    data['variation_name'] = this.variationName;
    data['product_variation_name'] = this.productVariationName;
    data['product_code'] = this.productCode;
    data['sku'] = this.sku;
    data['sub_sku'] = this.subSku;
    data['total_quantity'] = this.totalQuantity;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}
