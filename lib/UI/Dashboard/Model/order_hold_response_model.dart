import 'package:gmart/UI/Dashboard/Model/recall_hold_order_details_response_model.dart';

class HoldorderResponseModel {
  int? success;
  String? msg;
  String? receipt;
  Transaction? transaction;

  HoldorderResponseModel(
      {this.success, this.msg, this.receipt, this.transaction});

  HoldorderResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg'];
    receipt = json['receipt'];
    transaction = json['transaction'] != null
        ? new Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['receipt'] = this.receipt;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.toJson();
    }
    return data;
  }
}

class Transaction {
  int? businessId;
  int? locationId;
  String? type;
  String? status;
  String? subStatus;
  int? contactId;
  String? customerGroupId;
  String? invoiceNo;
  String? refNo;
  String? source;
  int? totalBeforeTax;
  String? transactionDate;
  int? taxId;
  String? discountType;
  int? discountAmount;
  double? taxAmount;
  int? finalTotal;
  String? additionalNotes;
  String? staffNote;
  int? createdBy;
  String? document;
  String? customField1;
  String? customField2;
  String? customField3;
  String? customField4;
  int? isDirectSale;
  String? commissionAgent;
  int? isQuotation;
  dynamic shippingDetails;
  dynamic shippingAddress;
  dynamic shippingStatus;
  dynamic deliveredTo;
  dynamic deliveryPerson;
  int? shippingCharges;
  Null? shippingCustomField1;
  Null? shippingCustomField2;
  Null? shippingCustomField3;
  Null? shippingCustomField4;
  Null? shippingCustomField5;
  int? exchangeRate;
  int? sellingPriceGroupId;
  dynamic payTermNumber;
  dynamic payTermType;
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
  List<SellDetails>? sellDetails;

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
      this.sellDetails});

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
    if (json['sell_details'] != null) {
      sellDetails = <SellDetails>[];
      json['sell_details'].forEach((v) {
        sellDetails!.add(new SellDetails.fromJson(v));
      });
    }
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
    if (this.sellDetails != null) {
      data['sell_details'] = this.sellDetails!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
