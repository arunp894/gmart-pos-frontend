import 'package:gmart/UI/Dashboard/Model/product_list_reponse_model.dart';

class LocalProductListResponseModel {
  List<ProductsList>? data;

  LocalProductListResponseModel({
    this.data,
  });

  LocalProductListResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProductsList>[];
      json['data'].forEach((v) {
        data!.add(new ProductsList.fromLocalJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class ProductsList {
//   int? productId;
//   String? name;
//   String? type;
//   int? enableStock;
//   String? productImage;
//   int? variantId;
//   String? variation;
//   String? qtyAvailable;
//   String? sellingPrice;
//   String? posSellQuantityEdit;
//   String? subSku;
//   String? unit;
//
//   // List<Media>? media;
//   List<dynamic>? groupPrices;
//   List<VariationDouble>? variationDouble;
//   IsTimeLimit? isTimeLimit;
//   IsAgeLimit? isAgeLimit;
//
//   ProductsList(
//       {this.productId,
//       this.name,
//       this.type,
//       this.enableStock,
//       this.productImage,
//       this.variantId,
//       this.variation,
//       this.qtyAvailable,
//       this.sellingPrice,
//       this.subSku,
//       this.unit,
//       // this.media,
//       this.variationDouble,
//       this.groupPrices,
//       this.isTimeLimit,
//       this.isAgeLimit,
//       this.posSellQuantityEdit});
//
//   ProductsList.fromJson(Map<String, dynamic> json) {
//     productId = int.parse(json['product_id'].toString());
//     name = json['name'];
//     type = json['type'];
//     // enableStock = int.parse(json['enable_stock'].toString());
//     productImage = json['product_image'];
//     variantId = int.parse(json['variation_id'].toString());
//     variation = json['variation'];
//     qtyAvailable = json['qty_available'];
//     sellingPrice = json['default_selling_price'];
//     subSku = json['barcode'];
//     unit = json['unit'];
//     posSellQuantityEdit = json['pos_edit'].toString();
//     if (json['variation_double'] != null) {
//       variationDouble = <VariationDouble>[];
//       json['variation_double'].forEach((v) {
//         variationDouble!.add(new VariationDouble.fromJson(v));
//       });
//     }
//     isTimeLimit = json['is_time_limit'] != null
//         ? new IsTimeLimit.fromJson(json['is_time_limit'])
//         : null;
//     isAgeLimit = json['is_age_limit'] != null
//         ? new IsAgeLimit.fromJson(json['is_age_limit'])
//         : null;
//     // if (json['media'] != null) {
//     //   media = <Media>[];
//     //   json['media'].forEach((v) {
//     //     media!.add(new Media.fromJson(v));
//     //   });
//     // }
//     // groupPrices = json['group_prices'] ?? [];
//     /* if (json['group_prices'] != null) {
//       groupPrices = <Null>[];
//       json['group_prices'].forEach((v) {
//         groupPrices!.add(new Null.fromJson(v));
//       });
//     }*/
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['product_id'] = this.productId;
//     data['name'] = this.name;
//     data['type'] = this.type;
//     data['enable_stock'] = this.enableStock;
//     data['product_image'] = this.productImage;
//     data['variations_id'] = this.variantId;
//     data['variation'] = this.variation;
//     data['qty_available'] = this.qtyAvailable;
//     data['selling_price'] = this.sellingPrice;
//     data['sub_sku'] = this.subSku;
//     data['unit'] = this.unit;
//     data['pos_sell_quantity_edit'] = this.posSellQuantityEdit;
//     if (this.variationDouble != null) {
//       data['variation_double'] =
//           this.variationDouble!.map((v) => v.toJson()).toList();
//     }
//     if (this.isTimeLimit != null) {
//       data['is_time_limit'] = this.isTimeLimit!.toJson();
//     }
//     if (this.isAgeLimit != null) {
//       data['is_age_limit'] = this.isAgeLimit!.toJson();
//     }
//     /*if (this.groupPrices != null) {
//       data['group_prices'] = this.groupPrices!.map((v) => v.toJson()).toList();
//     }*/
//     return data;
//   }
// }
//
// class VariationDouble {
//   int? id;
//   String? name;
//   String? productId;
//   String? subSku;
//   String? barcode;
//   String? variationId;
//   int? variationValueId;
//   String? profitPercent;
//   String? defaultSellPrice;
//   String? unit;
//   String? sellPriceIncTax;
//   String? conRate;
//
//   VariationDouble(
//       {this.id,
//       this.name,
//       this.productId,
//       this.subSku,
//       this.barcode,
//       this.variationId,
//       this.variationValueId,
//       this.profitPercent,
//       this.defaultSellPrice,
//       this.sellPriceIncTax,
//       this.conRate,
//       this.unit});
//
//   VariationDouble.fromJson(Map<String, dynamic> json) {
//     id = json['variation_double_id'];
//     name = json['name'];
//     productId = json['product_id'];
//     subSku = json['barcode'];
//     barcode = json['barcode'];
//     variationId = json['variation_id'];
//     // variationValueId = json['variation_value_id'] ?? 0;
//     variationValueId = json['variation_value_id'];
//     // profitPercent = json['profit_percent'];
//     defaultSellPrice = json['default_selling_price'];
//     sellPriceIncTax = json['selling_price_inc_tax'];
//     conRate = json['con_rate'];
//     unit = json['unit'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['variation_double_id'] = this.id;
//     data['name'] = this.name;
//     data['product_id'] = this.productId;
//     data['sub_sku'] = this.subSku;
//     data['barcode'] = this.barcode;
//     data['variation_id'] = this.variationId;
//     data['variation_value_id'] = this.variationValueId;
//     data['profit_percent'] = this.profitPercent;
//     data['default_selling_price'] = this.defaultSellPrice;
//     data['selling_price_inc_tax'] = this.sellPriceIncTax;
//     data['con_rate'] = this.conRate;
//     data['unit'] = this.unit;
//     return data;
//   }
// }
