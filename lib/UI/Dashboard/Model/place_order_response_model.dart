class PlaceOrderResponseModel {
  int? success;
  String? msg;
  Receipt? receipt;
  // Transaction? transaction;

  PlaceOrderResponseModel({
    this.success,
    this.msg,
    this.receipt,
    // this.transaction
  });

  PlaceOrderResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    receipt = json['receipt'] != null
        ? json['receipt'] == ""
            ? null
            : new Receipt.fromJson(json['receipt'])
        : null;
    // transaction = json['transaction'] != null
    //     ? new Transaction.fromJson(json['transaction'])
    //     : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    if (this.receipt != null) {
      data['receipt'] = this.receipt!.toJson();
    }
    // if (this.transaction != null) {
    //   data['transaction'] = this.transaction!.toJson();
    // }
    return data;
  }
}

class Receipt {
  String? headerText;
  String? businessName;
  String? locationName;
  String? subHeadingLine1;
  String? subHeadingLine2;
  String? subHeadingLine3;
  String? subHeadingLine4;
  String? subHeadingLine5;
  String? tableProductLabel;
  String? tableQtyLabel;
  String? tableUnitPriceLabel;
  String? tableSubtotalLabel;
  String? displayName;
  bool? logo;
  String? address;
  Null? website;
  String? locationCustomFields;
  String? taxLabel1;
  String? taxInfo1;
  String? contact;
  String? customerInfo;
  Null? customerTaxNumber;
  String? customerTaxLabel;
  String? customerCustomFields;
  String? customerLabel;
  String? customerName;
  String? customerMobile;
  String? customerInfoAddress;
  String? clientId;
  String? clientIdLabel;
  String? salesPerson;
  String? salesPersonLabel;
  String? commissionAgent;
  String? commissionAgentLabel;
  String? invoiceNo;
  String? invoiceNoPrefix;
  Null? shippingAddress;
  String? invoiceHeading;
  String? dateLabel;
  String? invoiceDate;
  String? transactionDate;
  String? dateTimeFormat;
  String? currencySymbol;
  bool? hidePrice;

  // List<Lines>? lines;
  String? itemDiscountLabel;
  String? discountedUnitPriceLabel;
  bool? showBaseUnitDetails;
  String? taxSummaryLabel;
  List<Null>? taxes;
  String? subtotalExcTax;
  int? totalLineDiscount;
  int? showCatCode;
  Null? catCodeLabel;
  String? subtotalLabel;
  String? subtotal;
  String? subtotalUnformatted;
  String? roundOffLabel;
  String? roundOff;
  String? roundOffAmount;
  String? totalExempt;
  int? totalExemptUf;
  String? taxedSubtotal;
  String? lineDiscountLabel;
  String? discountLabel;
  dynamic discount;
  String? taxLabel;
  String? lineTaxLabel;
  String? tax;
  int? shippingCharges;
  String? shippingChargesLabel;
  Null? shippingDetails;
  Null? deliveredTo;
  String? shippingDetailsLabel;
  String? packingChargeLabel;
  int? packingCharge;
  String? totalLabel;
  String? total;
  String? totalUnformatted;
  String? totalPaid;
  String? totalPaidLabel;
  int? totalDue;
  String? totalDueLabel;
  List<Payments>? payments;
  List<Null>? additionalExpenses;
  bool? barcode;
  Null? additionalNotes;
  String? footerText;
  bool? showBarcode;
  bool? showQrCode;
  List<Null>? qrCodeDetails;
  String? qrCodeText;
  int? isExport;
  String? design;
  Null? tableTaxHeadings;

  Receipt(
      {this.headerText,
      this.businessName,
      this.locationName,
      this.subHeadingLine1,
      this.subHeadingLine2,
      this.subHeadingLine3,
      this.subHeadingLine4,
      this.subHeadingLine5,
      this.tableProductLabel,
      this.tableQtyLabel,
      this.tableUnitPriceLabel,
      this.tableSubtotalLabel,
      this.displayName,
      this.logo,
      this.address,
      this.website,
      this.locationCustomFields,
      this.taxLabel1,
      this.taxInfo1,
      this.contact,
      this.customerInfo,
      this.customerTaxNumber,
      this.customerTaxLabel,
      this.customerCustomFields,
      this.customerLabel,
      this.customerName,
      this.customerMobile,
      this.customerInfoAddress,
      this.clientId,
      this.clientIdLabel,
      this.salesPerson,
      this.salesPersonLabel,
      this.commissionAgent,
      this.commissionAgentLabel,
      this.invoiceNo,
      this.invoiceNoPrefix,
      this.shippingAddress,
      this.invoiceHeading,
      this.dateLabel,
      this.invoiceDate,
      this.transactionDate,
      this.dateTimeFormat,
      this.currencySymbol,
      this.hidePrice,
      // this.lines,
      this.itemDiscountLabel,
      this.discountedUnitPriceLabel,
      this.showBaseUnitDetails,
      this.taxSummaryLabel,
      this.taxes,
      this.subtotalExcTax,
      this.totalLineDiscount,
      this.showCatCode,
      this.catCodeLabel,
      this.subtotalLabel,
      this.subtotal,
      this.subtotalUnformatted,
      this.roundOffLabel,
      this.roundOff,
      this.roundOffAmount,
      this.totalExempt,
      this.totalExemptUf,
      this.taxedSubtotal,
      this.lineDiscountLabel,
      this.discountLabel,
      this.discount,
      this.taxLabel,
      this.lineTaxLabel,
      this.tax,
      this.shippingCharges,
      this.shippingChargesLabel,
      this.shippingDetails,
      this.deliveredTo,
      this.shippingDetailsLabel,
      this.packingChargeLabel,
      this.packingCharge,
      this.totalLabel,
      this.total,
      this.totalUnformatted,
      this.totalPaid,
      this.totalPaidLabel,
      this.totalDue,
      this.totalDueLabel,
      this.payments,
      this.additionalExpenses,
      this.barcode,
      this.additionalNotes,
      this.footerText,
      this.showBarcode,
      this.showQrCode,
      this.qrCodeDetails,
      this.qrCodeText,
      this.isExport,
      this.design,
      this.tableTaxHeadings});

  Receipt.fromJson(Map<String, dynamic> json) {
    // headerText = json['header_text'];
    // businessName = json['business_name'];
    // locationName = json['location_name'];
    // subHeadingLine1 = json['sub_heading_line1'];
    // subHeadingLine2 = json['sub_heading_line2'];
    // subHeadingLine3 = json['sub_heading_line3'];
    // subHeadingLine4 = json['sub_heading_line4'];
    // subHeadingLine5 = json['sub_heading_line5'];
    // tableProductLabel = json['table_product_label'];
    // tableQtyLabel = json['table_qty_label'];
    // tableUnitPriceLabel = json['table_unit_price_label'];
    // tableSubtotalLabel = json['table_subtotal_label'];
    // displayName = json['display_name'];
    // logo = json['logo'];
    // address = json['address'];
    // website = json['website'];
    // locationCustomFields = json['location_custom_fields'];
    // taxLabel1 = json['tax_label1'];
    // taxInfo1 = json['tax_info1'];
    // contact = json['contact'];
    // customerInfo = json['customer_info'];
    // customerTaxNumber = json['customer_tax_number'];
    // customerTaxLabel = json['customer_tax_label'];
    // customerCustomFields = json['customer_custom_fields'];
    // customerLabel = json['customer_label'];
    // customerName = json['customer_name'];
    // customerMobile = json['customer_mobile'];
    // customerInfoAddress = json['customer_info_address'];
    // clientId = json['client_id'];
    // clientIdLabel = json['client_id_label'];
    // salesPerson = json['sales_person'];
    // salesPersonLabel = json['sales_person_label'];
    // commissionAgent = json['commission_agent'];
    // commissionAgentLabel = json['commission_agent_label'];
    invoiceNo = json['invoice_no'];
    // invoiceNoPrefix = json['invoice_no_prefix'];
    // shippingAddress = json['shipping_address'];
    // invoiceHeading = json['invoice_heading'];
    // dateLabel = json['date_label'];
    // invoiceDate = json['invoice_date'];
    transactionDate = json['transaction_date'];
    // dateTimeFormat = json['date_time_format'];
    // currencySymbol = json['currency_symbol'];
    // hidePrice = json['hide_price'];
    // if (json['lines'] != null) {
    //   lines = <Lines>[];
    //   json['lines'].forEach((v) {
    //     lines!.add(new Lines.fromJson(v));
    //   });
    // }
    // itemDiscountLabel = json['item_discount_label'];
    // discountedUnitPriceLabel = json['discounted_unit_price_label'];
    // showBaseUnitDetails = json['show_base_unit_details'];
    // taxSummaryLabel = json['tax_summary_label'];
    // if (json['taxes'] != null) {
    //   taxes = <Null>[];
    //   json['taxes'].forEach((v) {
    //     taxes!.add(new Null.fromJson(v));
    //   });
    // }
    // subtotalExcTax = json['subtotal_exc_tax'];
    // totalLineDiscount = json['total_line_discount'];
    // showCatCode = json['show_cat_code'];
    // catCodeLabel = json['cat_code_label'];
    // subtotalLabel = json['subtotal_label'];
    // subtotal = json['subtotal'];
    // subtotalUnformatted = json['subtotal_unformatted'];
    // roundOffLabel = json['round_off_label'];
    // roundOff = json['round_off'];
    // roundOffAmount = json['round_off_amount'];
    // totalExempt = json['total_exempt'];
    // totalExemptUf = json['total_exempt_uf'];
    // taxedSubtotal = json['taxed_subtotal'];
    // lineDiscountLabel = json['line_discount_label'];
    // discountLabel = json['discount_label'];
    // discount = json['discount'];
    // taxLabel = json['tax_label'];
    // lineTaxLabel = json['line_tax_label'];
    // tax = json['tax'];
    // shippingCharges = json['shipping_charges'];
    // shippingChargesLabel = json['shipping_charges_label'];
    // shippingDetails = json['shipping_details'];
    // deliveredTo = json['delivered_to'];
    // shippingDetailsLabel = json['shipping_details_label'];
    // packingChargeLabel = json['packing_charge_label'];
    // packingCharge = json['packing_charge'];
    // totalLabel = json['total_label'];
    // total = json['total'];
    // totalUnformatted = json['total_unformatted'];
    // totalPaid = json['total_paid'];
    // totalPaidLabel = json['total_paid_label'];
    // totalDue = json['total_due'];
    // totalDueLabel = json['total_due_label'];
    // if (json['payments'] != null) {
    //   payments = <Payments>[];
    //   json['payments'].forEach((v) {
    //     payments!.add(new Payments.fromJson(v));
    //   });
    // }
    // if (json['additional_expenses'] != null) {
    //   additionalExpenses = <Null>[];
    //   json['additional_expenses'].forEach((v) {
    //     additionalExpenses!.add(new Null.fromJson(v));
    //   });
    // }
    // barcode = json['barcode'];
    // additionalNotes = json['additional_notes'];
    // footerText = json['footer_text'];
    // showBarcode = json['show_barcode'];
    // showQrCode = json['show_qr_code'];
    // if (json['qr_code_details'] != null) {
    //   qrCodeDetails = <Null>[];
    //   json['qr_code_details'].forEach((v) {
    //     qrCodeDetails!.add(new Null.fromJson(v));
    //   });
    // }
    // qrCodeText = json['qr_code_text'];
    // isExport = json['is_export'];
    // design = json['design'];
    // tableTaxHeadings = json['table_tax_headings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['header_text'] = this.headerText;
    data['business_name'] = this.businessName;
    data['location_name'] = this.locationName;
    data['sub_heading_line1'] = this.subHeadingLine1;
    data['sub_heading_line2'] = this.subHeadingLine2;
    data['sub_heading_line3'] = this.subHeadingLine3;
    data['sub_heading_line4'] = this.subHeadingLine4;
    data['sub_heading_line5'] = this.subHeadingLine5;
    data['table_product_label'] = this.tableProductLabel;
    data['table_qty_label'] = this.tableQtyLabel;
    data['table_unit_price_label'] = this.tableUnitPriceLabel;
    data['table_subtotal_label'] = this.tableSubtotalLabel;
    data['display_name'] = this.displayName;
    data['logo'] = this.logo;
    data['address'] = this.address;
    data['website'] = this.website;
    data['location_custom_fields'] = this.locationCustomFields;
    data['tax_label1'] = this.taxLabel1;
    data['tax_info1'] = this.taxInfo1;
    data['contact'] = this.contact;
    data['customer_info'] = this.customerInfo;
    data['customer_tax_number'] = this.customerTaxNumber;
    data['customer_tax_label'] = this.customerTaxLabel;
    data['customer_custom_fields'] = this.customerCustomFields;
    data['customer_label'] = this.customerLabel;
    data['customer_name'] = this.customerName;
    data['customer_mobile'] = this.customerMobile;
    data['customer_info_address'] = this.customerInfoAddress;
    data['client_id'] = this.clientId;
    data['client_id_label'] = this.clientIdLabel;
    data['sales_person'] = this.salesPerson;
    data['sales_person_label'] = this.salesPersonLabel;
    data['commission_agent'] = this.commissionAgent;
    data['commission_agent_label'] = this.commissionAgentLabel;
    data['invoice_no'] = this.invoiceNo;
    data['invoice_no_prefix'] = this.invoiceNoPrefix;
    data['shipping_address'] = this.shippingAddress;
    data['invoice_heading'] = this.invoiceHeading;
    data['date_label'] = this.dateLabel;
    data['invoice_date'] = this.invoiceDate;
    data['transaction_date'] = this.transactionDate;
    data['date_time_format'] = this.dateTimeFormat;
    data['currency_symbol'] = this.currencySymbol;
    data['hide_price'] = this.hidePrice;
    // if (this.lines != null) {
    //   data['lines'] = this.lines!.map((v) => v.toJson()).toList();
    // }
    data['item_discount_label'] = this.itemDiscountLabel;
    data['discounted_unit_price_label'] = this.discountedUnitPriceLabel;
    data['show_base_unit_details'] = this.showBaseUnitDetails;
    data['tax_summary_label'] = this.taxSummaryLabel;
    // if (this.taxes != null) {
    //   data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    // }
    data['subtotal_exc_tax'] = this.subtotalExcTax;
    data['total_line_discount'] = this.totalLineDiscount;
    data['show_cat_code'] = this.showCatCode;
    data['cat_code_label'] = this.catCodeLabel;
    data['subtotal_label'] = this.subtotalLabel;
    data['subtotal'] = this.subtotal;
    data['subtotal_unformatted'] = this.subtotalUnformatted;
    data['round_off_label'] = this.roundOffLabel;
    data['round_off'] = this.roundOff;
    data['round_off_amount'] = this.roundOffAmount;
    data['total_exempt'] = this.totalExempt;
    data['total_exempt_uf'] = this.totalExemptUf;
    data['taxed_subtotal'] = this.taxedSubtotal;
    data['line_discount_label'] = this.lineDiscountLabel;
    data['discount_label'] = this.discountLabel;
    data['discount'] = this.discount;
    data['tax_label'] = this.taxLabel;
    data['line_tax_label'] = this.lineTaxLabel;
    data['tax'] = this.tax;
    data['shipping_charges'] = this.shippingCharges;
    data['shipping_charges_label'] = this.shippingChargesLabel;
    data['shipping_details'] = this.shippingDetails;
    data['delivered_to'] = this.deliveredTo;
    data['shipping_details_label'] = this.shippingDetailsLabel;
    data['packing_charge_label'] = this.packingChargeLabel;
    data['packing_charge'] = this.packingCharge;
    data['total_label'] = this.totalLabel;
    data['total'] = this.total;
    data['total_unformatted'] = this.totalUnformatted;
    data['total_paid'] = this.totalPaid;
    data['total_paid_label'] = this.totalPaidLabel;
    data['total_due'] = this.totalDue;
    data['total_due_label'] = this.totalDueLabel;
    if (this.payments != null) {
      data['payments'] = this.payments!.map((v) => v.toJson()).toList();
    }
    // if (this.additionalExpenses != null) {
    //   data['additional_expenses'] =
    //       this.additionalExpenses!.map((v) => v.toJson()).toList();
    // }
    data['barcode'] = this.barcode;
    data['additional_notes'] = this.additionalNotes;
    data['footer_text'] = this.footerText;
    data['show_barcode'] = this.showBarcode;
    data['show_qr_code'] = this.showQrCode;
    // if (this.qrCodeDetails != null) {
    //   data['qr_code_details'] =
    //       this.qrCodeDetails!.map((v) => v.toJson()).toList();
    // }
    data['qr_code_text'] = this.qrCodeText;
    data['is_export'] = this.isExport;
    data['design'] = this.design;
    data['table_tax_headings'] = this.tableTaxHeadings;
    return data;
  }
}

class Lines {
  String? name;
  Null? productDescription;
  String? variation;
  String? productVariation;
  String? quantity;
  int? quantityUf;
  String? units;
  String? baseUnitName;
  int? baseUnitMultiplier;
  String? origQuantity;
  String? unitPrice;
  String? unitPriceUf;
  String? tax;
  Null? taxId;
  String? taxUnformatted;
  Null? taxName;
  Null? taxPercent;
  String? unitPriceIncTax;
  String? unitPriceIncTaxUf;
  String? unitPriceExcTax;
  String? baseUnitPrice;
  dynamic priceExcTax;
  String? unitPriceBeforeDiscount;
  String? unitPriceBeforeDiscountUf;
  String? lineTotal;
  dynamic lineTotalUf;
  String? lineTotalExcTax;
  int? lineTotalExcTaxUf;
  int? variationId;
  String? lineDiscountAmountUf;
  String? lineDiscountTypeUf;
  String? lineDiscount;
  String? lineDiscountUf;
  String? totalLineDiscount;
  String? subSku;
  String? catCode;

  Lines(
      {this.name,
      this.productDescription,
      this.variation,
      this.productVariation,
      this.quantity,
      this.quantityUf,
      this.units,
      this.baseUnitName,
      this.baseUnitMultiplier,
      this.origQuantity,
      this.unitPrice,
      this.unitPriceUf,
      this.tax,
      this.taxId,
      this.taxUnformatted,
      this.taxName,
      this.taxPercent,
      this.unitPriceIncTax,
      this.unitPriceIncTaxUf,
      this.unitPriceExcTax,
      this.baseUnitPrice,
      this.priceExcTax,
      this.unitPriceBeforeDiscount,
      this.unitPriceBeforeDiscountUf,
      this.lineTotal,
      this.lineTotalUf,
      this.lineTotalExcTax,
      this.lineTotalExcTaxUf,
      this.variationId,
      this.lineDiscountAmountUf,
      this.lineDiscountTypeUf,
      this.lineDiscount,
      this.lineDiscountUf,
      this.totalLineDiscount,
      this.subSku,
      this.catCode});

  Lines.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    productDescription = json['product_description'];
    variation = json['variation'];
    productVariation = json['product_variation'];
    quantity = json['quantity'];
    quantityUf = json['quantity_uf'];
    units = json['units'];
    baseUnitName = json['base_unit_name'];
    baseUnitMultiplier = json['base_unit_multiplier'];
    origQuantity = json['orig_quantity'];
    unitPrice = json['unit_price'];
    unitPriceUf = json['unit_price_uf'];
    tax = json['tax'];
    taxId = json['tax_id'];
    taxUnformatted = json['tax_unformatted'];
    taxName = json['tax_name'];
    taxPercent = json['tax_percent'];
    unitPriceIncTax = json['unit_price_inc_tax'];
    unitPriceIncTaxUf = json['unit_price_inc_tax_uf'];
    unitPriceExcTax = json['unit_price_exc_tax'];
    baseUnitPrice = json['base_unit_price'];
    priceExcTax = json['price_exc_tax'];
    unitPriceBeforeDiscount = json['unit_price_before_discount'];
    unitPriceBeforeDiscountUf = json['unit_price_before_discount_uf'];
    lineTotal = json['line_total'];
    lineTotalUf = json['line_total_uf'];
    lineTotalExcTax = json['line_total_exc_tax'];
    lineTotalExcTaxUf = json['line_total_exc_tax_uf'];
    variationId = json['variation_id'];
    lineDiscountAmountUf = json['line_discount_amount_uf'];
    lineDiscountTypeUf = json['line_discount_type_uf'];
    lineDiscount = json['line_discount'];
    lineDiscountUf = json['line_discount_uf'];
    totalLineDiscount = json['total_line_discount'];
    subSku = json['sub_sku'];
    catCode = json['cat_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['product_description'] = this.productDescription;
    data['variation'] = this.variation;
    data['product_variation'] = this.productVariation;
    data['quantity'] = this.quantity;
    data['quantity_uf'] = this.quantityUf;
    data['units'] = this.units;
    data['base_unit_name'] = this.baseUnitName;
    data['base_unit_multiplier'] = this.baseUnitMultiplier;
    data['orig_quantity'] = this.origQuantity;
    data['unit_price'] = this.unitPrice;
    data['unit_price_uf'] = this.unitPriceUf;
    data['tax'] = this.tax;
    data['tax_id'] = this.taxId;
    data['tax_unformatted'] = this.taxUnformatted;
    data['tax_name'] = this.taxName;
    data['tax_percent'] = this.taxPercent;
    data['unit_price_inc_tax'] = this.unitPriceIncTax;
    data['unit_price_inc_tax_uf'] = this.unitPriceIncTaxUf;
    data['unit_price_exc_tax'] = this.unitPriceExcTax;
    data['base_unit_price'] = this.baseUnitPrice;
    data['price_exc_tax'] = this.priceExcTax;
    data['unit_price_before_discount'] = this.unitPriceBeforeDiscount;
    data['unit_price_before_discount_uf'] = this.unitPriceBeforeDiscountUf;
    data['line_total'] = this.lineTotal;
    data['line_total_uf'] = this.lineTotalUf;
    data['line_total_exc_tax'] = this.lineTotalExcTax;
    data['line_total_exc_tax_uf'] = this.lineTotalExcTaxUf;
    data['variation_id'] = this.variationId;
    data['line_discount_amount_uf'] = this.lineDiscountAmountUf;
    data['line_discount_type_uf'] = this.lineDiscountTypeUf;
    data['line_discount'] = this.lineDiscount;
    data['line_discount_uf'] = this.lineDiscountUf;
    data['total_line_discount'] = this.totalLineDiscount;
    data['sub_sku'] = this.subSku;
    data['cat_code'] = this.catCode;
    return data;
  }
}

class Payments {
  String? method;
  String? amount;
  String? date;

  Payments({this.method, this.amount, this.date});

  Payments.fromJson(Map<String, dynamic> json) {
    method = json['method'];
    amount = json['amount'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method'] = this.method;
    data['amount'] = this.amount;
    data['date'] = this.date;
    return data;
  }
}

class Transaction {
  int? businessId;
  int? locationId;
  String? type;
  String? status;
  Null? subStatus;
  int? contactId;
  Null? customerGroupId;
  String? invoiceNo;
  String? refNo;
  Null? source;
  int? totalBeforeTax;
  String? transactionDate;
  int? taxId;
  String? discountType;
  int? discountAmount;
  int? taxAmount;
  int? finalTotal;
  Null? additionalNotes;
  Null? staffNote;
  int? createdBy;
  Null? document;
  Null? customField1;
  Null? customField2;
  Null? customField3;
  Null? customField4;
  int? isDirectSale;
  Null? commissionAgent;
  int? isQuotation;
  Null? shippingDetails;
  Null? shippingAddress;
  Null? shippingStatus;
  Null? deliveredTo;
  Null? deliveryPerson;
  int? shippingCharges;
  Null? shippingCustomField1;
  Null? shippingCustomField2;
  Null? shippingCustomField3;
  Null? shippingCustomField4;
  Null? shippingCustomField5;
  int? exchangeRate;
  int? sellingPriceGroupId;
  Null? payTermNumber;
  Null? payTermType;
  int? isSuspend;
  int? isRecurring;
  int? recurInterval;
  String? recurIntervalType;
  Null? subscriptionRepeatOn;
  Null? subscriptionNo;
  int? recurRepetitions;
  Null? orderAddresses;
  Null? subType;
  int? rpEarned;
  int? rpRedeemed;
  int? rpRedeemedAmount;
  int? isCreatedFromApi;
  Null? typesOfServiceId;
  int? packingCharge;
  Null? packingChargeType;
  Null? serviceCustomField1;
  Null? serviceCustomField2;
  Null? serviceCustomField3;
  Null? serviceCustomField4;
  Null? serviceCustomField5;
  Null? serviceCustomField6;
  int? roundOffAmount;
  Null? importBatch;
  Null? importTime;
  Null? resTableId;
  Null? resWaiterId;
  Null? salesOrderIds;
  Null? preferPaymentMethod;
  Null? preferPaymentAccount;
  int? isExport;
  Null? exportCustomFieldsInfo;
  int? additionalExpenseValue1;
  int? additionalExpenseValue2;
  int? additionalExpenseValue3;
  int? additionalExpenseValue4;
  Null? additionalExpenseKey1;
  Null? additionalExpenseKey2;
  Null? additionalExpenseKey3;
  Null? additionalExpenseKey4;
  int? isKitchenOrder;
  String? updatedAt;
  String? createdAt;
  int? id;
  String? paymentStatus;
  List<PaymentLines>? paymentLines;
  List<SellLines>? sellLines;
  Contact? contact;

  Transaction(
      {this.businessId,
      this.locationId,
      this.type,
      this.status,
      this.subStatus,
      this.contactId,
      this.customerGroupId,
      this.invoiceNo,
      this.refNo,
      this.source,
      this.totalBeforeTax,
      this.transactionDate,
      this.taxId,
      this.discountType,
      this.discountAmount,
      this.taxAmount,
      this.finalTotal,
      this.additionalNotes,
      this.staffNote,
      this.createdBy,
      this.document,
      this.customField1,
      this.customField2,
      this.customField3,
      this.customField4,
      this.isDirectSale,
      this.commissionAgent,
      this.isQuotation,
      this.shippingDetails,
      this.shippingAddress,
      this.shippingStatus,
      this.deliveredTo,
      this.deliveryPerson,
      this.shippingCharges,
      this.shippingCustomField1,
      this.shippingCustomField2,
      this.shippingCustomField3,
      this.shippingCustomField4,
      this.shippingCustomField5,
      this.exchangeRate,
      this.sellingPriceGroupId,
      this.payTermNumber,
      this.payTermType,
      this.isSuspend,
      this.isRecurring,
      this.recurInterval,
      this.recurIntervalType,
      this.subscriptionRepeatOn,
      this.subscriptionNo,
      this.recurRepetitions,
      this.orderAddresses,
      this.subType,
      this.rpEarned,
      this.rpRedeemed,
      this.rpRedeemedAmount,
      this.isCreatedFromApi,
      this.typesOfServiceId,
      this.packingCharge,
      this.packingChargeType,
      this.serviceCustomField1,
      this.serviceCustomField2,
      this.serviceCustomField3,
      this.serviceCustomField4,
      this.serviceCustomField5,
      this.serviceCustomField6,
      this.roundOffAmount,
      this.importBatch,
      this.importTime,
      this.resTableId,
      this.resWaiterId,
      this.salesOrderIds,
      this.preferPaymentMethod,
      this.preferPaymentAccount,
      this.isExport,
      this.exportCustomFieldsInfo,
      this.additionalExpenseValue1,
      this.additionalExpenseValue2,
      this.additionalExpenseValue3,
      this.additionalExpenseValue4,
      this.additionalExpenseKey1,
      this.additionalExpenseKey2,
      this.additionalExpenseKey3,
      this.additionalExpenseKey4,
      this.isKitchenOrder,
      this.updatedAt,
      this.createdAt,
      this.id,
      this.paymentStatus,
      this.paymentLines,
      this.sellLines,
      this.contact});

  Transaction.fromJson(Map<String, dynamic> json) {
    businessId = json['business_id'];
    locationId = json['location_id'];
    type = json['type'];
    status = json['status'];
    subStatus = json['sub_status'];
    contactId = json['contact_id'];
    customerGroupId = json['customer_group_id'];
    invoiceNo = json['invoice_no'];
    refNo = json['ref_no'];
    source = json['source'];
    totalBeforeTax = json['total_before_tax'];
    transactionDate = json['transaction_date'];
    taxId = json['tax_id'];
    discountType = json['discount_type'];
    discountAmount = json['discount_amount'];
    taxAmount = json['tax_amount'];
    finalTotal = json['final_total'];
    additionalNotes = json['additional_notes'];
    staffNote = json['staff_note'];
    createdBy = json['created_by'];
    document = json['document'];
    customField1 = json['custom_field_1'];
    customField2 = json['custom_field_2'];
    customField3 = json['custom_field_3'];
    customField4 = json['custom_field_4'];
    isDirectSale = json['is_direct_sale'];
    commissionAgent = json['commission_agent'];
    isQuotation = json['is_quotation'];
    shippingDetails = json['shipping_details'];
    shippingAddress = json['shipping_address'];
    shippingStatus = json['shipping_status'];
    deliveredTo = json['delivered_to'];
    deliveryPerson = json['delivery_person'];
    shippingCharges = json['shipping_charges'];
    shippingCustomField1 = json['shipping_custom_field_1'];
    shippingCustomField2 = json['shipping_custom_field_2'];
    shippingCustomField3 = json['shipping_custom_field_3'];
    shippingCustomField4 = json['shipping_custom_field_4'];
    shippingCustomField5 = json['shipping_custom_field_5'];
    exchangeRate = json['exchange_rate'];
    sellingPriceGroupId = json['selling_price_group_id'];
    payTermNumber = json['pay_term_number'];
    payTermType = json['pay_term_type'];
    isSuspend = json['is_suspend'];
    isRecurring = json['is_recurring'];
    recurInterval = json['recur_interval'];
    recurIntervalType = json['recur_interval_type'];
    subscriptionRepeatOn = json['subscription_repeat_on'];
    subscriptionNo = json['subscription_no'];
    recurRepetitions = json['recur_repetitions'];
    orderAddresses = json['order_addresses'];
    subType = json['sub_type'];
    rpEarned = json['rp_earned'];
    rpRedeemed = json['rp_redeemed'];
    rpRedeemedAmount = json['rp_redeemed_amount'];
    isCreatedFromApi = json['is_created_from_api'];
    typesOfServiceId = json['types_of_service_id'];
    packingCharge = json['packing_charge'];
    packingChargeType = json['packing_charge_type'];
    serviceCustomField1 = json['service_custom_field_1'];
    serviceCustomField2 = json['service_custom_field_2'];
    serviceCustomField3 = json['service_custom_field_3'];
    serviceCustomField4 = json['service_custom_field_4'];
    serviceCustomField5 = json['service_custom_field_5'];
    serviceCustomField6 = json['service_custom_field_6'];
    roundOffAmount = json['round_off_amount'];
    importBatch = json['import_batch'];
    importTime = json['import_time'];
    resTableId = json['res_table_id'];
    resWaiterId = json['res_waiter_id'];
    salesOrderIds = json['sales_order_ids'];
    preferPaymentMethod = json['prefer_payment_method'];
    preferPaymentAccount = json['prefer_payment_account'];
    isExport = json['is_export'];
    exportCustomFieldsInfo = json['export_custom_fields_info'];
    additionalExpenseValue1 = json['additional_expense_value_1'];
    additionalExpenseValue2 = json['additional_expense_value_2'];
    additionalExpenseValue3 = json['additional_expense_value_3'];
    additionalExpenseValue4 = json['additional_expense_value_4'];
    additionalExpenseKey1 = json['additional_expense_key_1'];
    additionalExpenseKey2 = json['additional_expense_key_2'];
    additionalExpenseKey3 = json['additional_expense_key_3'];
    additionalExpenseKey4 = json['additional_expense_key_4'];
    isKitchenOrder = json['is_kitchen_order'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
    paymentStatus = json['payment_status'];
    if (json['payment_lines'] != null) {
      paymentLines = <PaymentLines>[];
      json['payment_lines'].forEach((v) {
        paymentLines!.add(new PaymentLines.fromJson(v));
      });
    }
    if (json['sell_lines'] != null) {
      sellLines = <SellLines>[];
      json['sell_lines'].forEach((v) {
        sellLines!.add(new SellLines.fromJson(v));
      });
    }
    contact =
        json['contact'] != null ? new Contact.fromJson(json['contact']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['business_id'] = this.businessId;
    data['location_id'] = this.locationId;
    data['type'] = this.type;
    data['status'] = this.status;
    data['sub_status'] = this.subStatus;
    data['contact_id'] = this.contactId;
    data['customer_group_id'] = this.customerGroupId;
    data['invoice_no'] = this.invoiceNo;
    data['ref_no'] = this.refNo;
    data['source'] = this.source;
    data['total_before_tax'] = this.totalBeforeTax;
    data['transaction_date'] = this.transactionDate;
    data['tax_id'] = this.taxId;
    data['discount_type'] = this.discountType;
    data['discount_amount'] = this.discountAmount;
    data['tax_amount'] = this.taxAmount;
    data['final_total'] = this.finalTotal;
    data['additional_notes'] = this.additionalNotes;
    data['staff_note'] = this.staffNote;
    data['created_by'] = this.createdBy;
    data['document'] = this.document;
    data['custom_field_1'] = this.customField1;
    data['custom_field_2'] = this.customField2;
    data['custom_field_3'] = this.customField3;
    data['custom_field_4'] = this.customField4;
    data['is_direct_sale'] = this.isDirectSale;
    data['commission_agent'] = this.commissionAgent;
    data['is_quotation'] = this.isQuotation;
    data['shipping_details'] = this.shippingDetails;
    data['shipping_address'] = this.shippingAddress;
    data['shipping_status'] = this.shippingStatus;
    data['delivered_to'] = this.deliveredTo;
    data['delivery_person'] = this.deliveryPerson;
    data['shipping_charges'] = this.shippingCharges;
    data['shipping_custom_field_1'] = this.shippingCustomField1;
    data['shipping_custom_field_2'] = this.shippingCustomField2;
    data['shipping_custom_field_3'] = this.shippingCustomField3;
    data['shipping_custom_field_4'] = this.shippingCustomField4;
    data['shipping_custom_field_5'] = this.shippingCustomField5;
    data['exchange_rate'] = this.exchangeRate;
    data['selling_price_group_id'] = this.sellingPriceGroupId;
    data['pay_term_number'] = this.payTermNumber;
    data['pay_term_type'] = this.payTermType;
    data['is_suspend'] = this.isSuspend;
    data['is_recurring'] = this.isRecurring;
    data['recur_interval'] = this.recurInterval;
    data['recur_interval_type'] = this.recurIntervalType;
    data['subscription_repeat_on'] = this.subscriptionRepeatOn;
    data['subscription_no'] = this.subscriptionNo;
    data['recur_repetitions'] = this.recurRepetitions;
    data['order_addresses'] = this.orderAddresses;
    data['sub_type'] = this.subType;
    data['rp_earned'] = this.rpEarned;
    data['rp_redeemed'] = this.rpRedeemed;
    data['rp_redeemed_amount'] = this.rpRedeemedAmount;
    data['is_created_from_api'] = this.isCreatedFromApi;
    data['types_of_service_id'] = this.typesOfServiceId;
    data['packing_charge'] = this.packingCharge;
    data['packing_charge_type'] = this.packingChargeType;
    data['service_custom_field_1'] = this.serviceCustomField1;
    data['service_custom_field_2'] = this.serviceCustomField2;
    data['service_custom_field_3'] = this.serviceCustomField3;
    data['service_custom_field_4'] = this.serviceCustomField4;
    data['service_custom_field_5'] = this.serviceCustomField5;
    data['service_custom_field_6'] = this.serviceCustomField6;
    data['round_off_amount'] = this.roundOffAmount;
    data['import_batch'] = this.importBatch;
    data['import_time'] = this.importTime;
    data['res_table_id'] = this.resTableId;
    data['res_waiter_id'] = this.resWaiterId;
    data['sales_order_ids'] = this.salesOrderIds;
    data['prefer_payment_method'] = this.preferPaymentMethod;
    data['prefer_payment_account'] = this.preferPaymentAccount;
    data['is_export'] = this.isExport;
    data['export_custom_fields_info'] = this.exportCustomFieldsInfo;
    data['additional_expense_value_1'] = this.additionalExpenseValue1;
    data['additional_expense_value_2'] = this.additionalExpenseValue2;
    data['additional_expense_value_3'] = this.additionalExpenseValue3;
    data['additional_expense_value_4'] = this.additionalExpenseValue4;
    data['additional_expense_key_1'] = this.additionalExpenseKey1;
    data['additional_expense_key_2'] = this.additionalExpenseKey2;
    data['additional_expense_key_3'] = this.additionalExpenseKey3;
    data['additional_expense_key_4'] = this.additionalExpenseKey4;
    data['is_kitchen_order'] = this.isKitchenOrder;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['payment_status'] = this.paymentStatus;
    if (this.paymentLines != null) {
      data['payment_lines'] =
          this.paymentLines!.map((v) => v.toJson()).toList();
    }
    if (this.sellLines != null) {
      data['sell_lines'] = this.sellLines!.map((v) => v.toJson()).toList();
    }
    if (this.contact != null) {
      data['contact'] = this.contact!.toJson();
    }
    return data;
  }
}

class PaymentLines {
  int? id;
  int? transactionId;
  int? businessId;
  int? isReturn;
  String? amount;
  String? method;
  Null? paymentType;
  Null? transactionNo;
  Null? cardTransactionNumber;
  Null? cardNumber;
  String? cardType;
  Null? cardHolderName;
  Null? cardMonth;
  Null? cardYear;
  Null? cardSecurity;
  Null? chequeNumber;
  Null? bankAccountNumber;
  String? paidOn;
  int? createdBy;
  int? paidThroughLink;
  Null? gateway;
  int? isAdvance;
  int? paymentFor;
  Null? parentId;
  Null? note;
  Null? document;
  String? paymentRefNo;
  Null? accountId;
  String? createdAt;
  String? updatedAt;

  PaymentLines(
      {this.id,
      this.transactionId,
      this.businessId,
      this.isReturn,
      this.amount,
      this.method,
      this.paymentType,
      this.transactionNo,
      this.cardTransactionNumber,
      this.cardNumber,
      this.cardType,
      this.cardHolderName,
      this.cardMonth,
      this.cardYear,
      this.cardSecurity,
      this.chequeNumber,
      this.bankAccountNumber,
      this.paidOn,
      this.createdBy,
      this.paidThroughLink,
      this.gateway,
      this.isAdvance,
      this.paymentFor,
      this.parentId,
      this.note,
      this.document,
      this.paymentRefNo,
      this.accountId,
      this.createdAt,
      this.updatedAt});

  PaymentLines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    businessId = json['business_id'];
    isReturn = json['is_return'];
    amount = json['amount'];
    method = json['method'];
    paymentType = json['payment_type'];
    transactionNo = json['transaction_no'];
    cardTransactionNumber = json['card_transaction_number'];
    cardNumber = json['card_number'];
    cardType = json['card_type'];
    cardHolderName = json['card_holder_name'];
    cardMonth = json['card_month'];
    cardYear = json['card_year'];
    cardSecurity = json['card_security'];
    chequeNumber = json['cheque_number'];
    bankAccountNumber = json['bank_account_number'];
    paidOn = json['paid_on'];
    createdBy = json['created_by'];
    paidThroughLink = json['paid_through_link'];
    gateway = json['gateway'];
    isAdvance = json['is_advance'];
    paymentFor = json['payment_for'];
    parentId = json['parent_id'];
    note = json['note'];
    document = json['document'];
    paymentRefNo = json['payment_ref_no'];
    accountId = json['account_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_id'] = this.transactionId;
    data['business_id'] = this.businessId;
    data['is_return'] = this.isReturn;
    data['amount'] = this.amount;
    data['method'] = this.method;
    data['payment_type'] = this.paymentType;
    data['transaction_no'] = this.transactionNo;
    data['card_transaction_number'] = this.cardTransactionNumber;
    data['card_number'] = this.cardNumber;
    data['card_type'] = this.cardType;
    data['card_holder_name'] = this.cardHolderName;
    data['card_month'] = this.cardMonth;
    data['card_year'] = this.cardYear;
    data['card_security'] = this.cardSecurity;
    data['cheque_number'] = this.chequeNumber;
    data['bank_account_number'] = this.bankAccountNumber;
    data['paid_on'] = this.paidOn;
    data['created_by'] = this.createdBy;
    data['paid_through_link'] = this.paidThroughLink;
    data['gateway'] = this.gateway;
    data['is_advance'] = this.isAdvance;
    data['payment_for'] = this.paymentFor;
    data['parent_id'] = this.parentId;
    data['note'] = this.note;
    data['document'] = this.document;
    data['payment_ref_no'] = this.paymentRefNo;
    data['account_id'] = this.accountId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class SellLines {
  int? id;
  int? transactionId;
  int? productId;
  int? variationId;
  int? quantity;
  String? secondaryUnitQuantity;
  String? quantityReturned;
  String? unitPriceBeforeDiscount;
  String? unitPrice;
  String? lineDiscountType;
  String? lineDiscountAmount;
  String? unitPriceIncTax;
  String? itemTax;
  Null? taxId;
  Null? discountId;
  Null? lotNoLineId;
  String? sellLineNote;
  Null? soLineId;
  String? soQuantityInvoiced;
  Null? resServiceStaffId;
  Null? resLineOrderStatus;
  Null? parentSellLineId;
  String? childrenType;
  Null? subUnitId;
  String? createdAt;
  String? updatedAt;

  SellLines(
      {this.id,
      this.transactionId,
      this.productId,
      this.variationId,
      this.quantity,
      this.secondaryUnitQuantity,
      this.quantityReturned,
      this.unitPriceBeforeDiscount,
      this.unitPrice,
      this.lineDiscountType,
      this.lineDiscountAmount,
      this.unitPriceIncTax,
      this.itemTax,
      this.taxId,
      this.discountId,
      this.lotNoLineId,
      this.sellLineNote,
      this.soLineId,
      this.soQuantityInvoiced,
      this.resServiceStaffId,
      this.resLineOrderStatus,
      this.parentSellLineId,
      this.childrenType,
      this.subUnitId,
      this.createdAt,
      this.updatedAt});

  SellLines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    productId = json['product_id'];
    variationId = json['variation_id'];
    quantity = json['quantity'];
    secondaryUnitQuantity = json['secondary_unit_quantity'];
    quantityReturned = json['quantity_returned'];
    unitPriceBeforeDiscount = json['unit_price_before_discount'];
    unitPrice = json['unit_price'];
    lineDiscountType = json['line_discount_type'];
    lineDiscountAmount = json['line_discount_amount'];
    unitPriceIncTax = json['unit_price_inc_tax'];
    itemTax = json['item_tax'];
    taxId = json['tax_id'];
    discountId = json['discount_id'];
    lotNoLineId = json['lot_no_line_id'];
    sellLineNote = json['sell_line_note'];
    soLineId = json['so_line_id'];
    soQuantityInvoiced = json['so_quantity_invoiced'];
    resServiceStaffId = json['res_service_staff_id'];
    resLineOrderStatus = json['res_line_order_status'];
    parentSellLineId = json['parent_sell_line_id'];
    childrenType = json['children_type'];
    subUnitId = json['sub_unit_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_id'] = this.transactionId;
    data['product_id'] = this.productId;
    data['variation_id'] = this.variationId;
    data['quantity'] = this.quantity;
    data['secondary_unit_quantity'] = this.secondaryUnitQuantity;
    data['quantity_returned'] = this.quantityReturned;
    data['unit_price_before_discount'] = this.unitPriceBeforeDiscount;
    data['unit_price'] = this.unitPrice;
    data['line_discount_type'] = this.lineDiscountType;
    data['line_discount_amount'] = this.lineDiscountAmount;
    data['unit_price_inc_tax'] = this.unitPriceIncTax;
    data['item_tax'] = this.itemTax;
    data['tax_id'] = this.taxId;
    data['discount_id'] = this.discountId;
    data['lot_no_line_id'] = this.lotNoLineId;
    data['sell_line_note'] = this.sellLineNote;
    data['so_line_id'] = this.soLineId;
    data['so_quantity_invoiced'] = this.soQuantityInvoiced;
    data['res_service_staff_id'] = this.resServiceStaffId;
    data['res_line_order_status'] = this.resLineOrderStatus;
    data['parent_sell_line_id'] = this.parentSellLineId;
    data['children_type'] = this.childrenType;
    data['sub_unit_id'] = this.subUnitId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Contact {
  int? id;
  int? businessId;
  String? type;
  Null? contactType;
  Null? landMark;
  Null? streetName;
  Null? buildingNumber;
  Null? additionalNumber;
  Null? supplierBusinessName;
  String? name;
  Null? prefix;
  Null? firstName;
  Null? middleName;
  Null? lastName;
  Null? email;
  String? contactId;
  String? contactStatus;
  Null? taxNumber;
  Null? city;
  Null? state;
  Null? country;
  Null? addressLine1;
  Null? addressLine2;
  Null? zipCode;
  Null? dob;
  String? mobile;
  Null? landline;
  Null? alternateNumber;
  Null? payTermNumber;
  Null? payTermType;
  String? creditLimit;
  int? createdBy;
  String? balance;
  int? totalRp;
  int? totalRpUsed;
  int? totalRpExpired;
  int? isDefault;
  Null? shippingAddress;
  Null? shippingCustomFieldDetails;
  int? isExport;
  Null? exportCustomField1;
  Null? exportCustomField2;
  Null? exportCustomField3;
  Null? exportCustomField4;
  Null? exportCustomField5;
  Null? exportCustomField6;
  Null? position;
  Null? customerGroupId;
  Null? customField1;
  Null? customField2;
  Null? customField3;
  Null? customField4;
  Null? customField5;
  Null? customField6;
  Null? customField7;
  Null? customField8;
  Null? customField9;
  Null? customField10;
  Null? deletedAt;
  String? createdAt;
  String? updatedAt;

  Contact(
      {this.id,
      this.businessId,
      this.type,
      this.contactType,
      this.landMark,
      this.streetName,
      this.buildingNumber,
      this.additionalNumber,
      this.supplierBusinessName,
      this.name,
      this.prefix,
      this.firstName,
      this.middleName,
      this.lastName,
      this.email,
      this.contactId,
      this.contactStatus,
      this.taxNumber,
      this.city,
      this.state,
      this.country,
      this.addressLine1,
      this.addressLine2,
      this.zipCode,
      this.dob,
      this.mobile,
      this.landline,
      this.alternateNumber,
      this.payTermNumber,
      this.payTermType,
      this.creditLimit,
      this.createdBy,
      this.balance,
      this.totalRp,
      this.totalRpUsed,
      this.totalRpExpired,
      this.isDefault,
      this.shippingAddress,
      this.shippingCustomFieldDetails,
      this.isExport,
      this.exportCustomField1,
      this.exportCustomField2,
      this.exportCustomField3,
      this.exportCustomField4,
      this.exportCustomField5,
      this.exportCustomField6,
      this.position,
      this.customerGroupId,
      this.customField1,
      this.customField2,
      this.customField3,
      this.customField4,
      this.customField5,
      this.customField6,
      this.customField7,
      this.customField8,
      this.customField9,
      this.customField10,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Contact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessId = json['business_id'];
    type = json['type'];
    contactType = json['contact_type'];
    landMark = json['land_mark'];
    streetName = json['street_name'];
    buildingNumber = json['building_number'];
    additionalNumber = json['additional_number'];
    supplierBusinessName = json['supplier_business_name'];
    name = json['name'];
    prefix = json['prefix'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    email = json['email'];
    contactId = json['contact_id'];
    contactStatus = json['contact_status'];
    taxNumber = json['tax_number'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    addressLine1 = json['address_line_1'];
    addressLine2 = json['address_line_2'];
    zipCode = json['zip_code'];
    dob = json['dob'];
    mobile = json['mobile'];
    landline = json['landline'];
    alternateNumber = json['alternate_number'];
    payTermNumber = json['pay_term_number'];
    payTermType = json['pay_term_type'];
    creditLimit = json['credit_limit'];
    createdBy = json['created_by'];
    balance = json['balance'];
    totalRp = json['total_rp'];
    totalRpUsed = json['total_rp_used'];
    totalRpExpired = json['total_rp_expired'];
    isDefault = json['is_default'];
    shippingAddress = json['shipping_address'];
    shippingCustomFieldDetails = json['shipping_custom_field_details'];
    isExport = json['is_export'];
    exportCustomField1 = json['export_custom_field_1'];
    exportCustomField2 = json['export_custom_field_2'];
    exportCustomField3 = json['export_custom_field_3'];
    exportCustomField4 = json['export_custom_field_4'];
    exportCustomField5 = json['export_custom_field_5'];
    exportCustomField6 = json['export_custom_field_6'];
    position = json['position'];
    customerGroupId = json['customer_group_id'];
    customField1 = json['custom_field1'];
    customField2 = json['custom_field2'];
    customField3 = json['custom_field3'];
    customField4 = json['custom_field4'];
    customField5 = json['custom_field5'];
    customField6 = json['custom_field6'];
    customField7 = json['custom_field7'];
    customField8 = json['custom_field8'];
    customField9 = json['custom_field9'];
    customField10 = json['custom_field10'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['business_id'] = this.businessId;
    data['type'] = this.type;
    data['contact_type'] = this.contactType;
    data['land_mark'] = this.landMark;
    data['street_name'] = this.streetName;
    data['building_number'] = this.buildingNumber;
    data['additional_number'] = this.additionalNumber;
    data['supplier_business_name'] = this.supplierBusinessName;
    data['name'] = this.name;
    data['prefix'] = this.prefix;
    data['first_name'] = this.firstName;
    data['middle_name'] = this.middleName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['contact_id'] = this.contactId;
    data['contact_status'] = this.contactStatus;
    data['tax_number'] = this.taxNumber;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['address_line_1'] = this.addressLine1;
    data['address_line_2'] = this.addressLine2;
    data['zip_code'] = this.zipCode;
    data['dob'] = this.dob;
    data['mobile'] = this.mobile;
    data['landline'] = this.landline;
    data['alternate_number'] = this.alternateNumber;
    data['pay_term_number'] = this.payTermNumber;
    data['pay_term_type'] = this.payTermType;
    data['credit_limit'] = this.creditLimit;
    data['created_by'] = this.createdBy;
    data['balance'] = this.balance;
    data['total_rp'] = this.totalRp;
    data['total_rp_used'] = this.totalRpUsed;
    data['total_rp_expired'] = this.totalRpExpired;
    data['is_default'] = this.isDefault;
    data['shipping_address'] = this.shippingAddress;
    data['shipping_custom_field_details'] = this.shippingCustomFieldDetails;
    data['is_export'] = this.isExport;
    data['export_custom_field_1'] = this.exportCustomField1;
    data['export_custom_field_2'] = this.exportCustomField2;
    data['export_custom_field_3'] = this.exportCustomField3;
    data['export_custom_field_4'] = this.exportCustomField4;
    data['export_custom_field_5'] = this.exportCustomField5;
    data['export_custom_field_6'] = this.exportCustomField6;
    data['position'] = this.position;
    data['customer_group_id'] = this.customerGroupId;
    data['custom_field1'] = this.customField1;
    data['custom_field2'] = this.customField2;
    data['custom_field3'] = this.customField3;
    data['custom_field4'] = this.customField4;
    data['custom_field5'] = this.customField5;
    data['custom_field6'] = this.customField6;
    data['custom_field7'] = this.customField7;
    data['custom_field8'] = this.customField8;
    data['custom_field9'] = this.customField9;
    data['custom_field10'] = this.customField10;
    data['deleted_at'] = this.deletedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
