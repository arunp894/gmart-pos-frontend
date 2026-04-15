import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gmart/Constant/app_color.dart';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/Engine/database_engine.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/Model/all_category_product_response_model.dart'
    as ac;
import 'package:gmart/UI/Dashboard/Model/cart_list_model.dart';
import 'package:gmart/UI/Dashboard/Model/cash_register_details_response_model.dart';
import 'package:gmart/UI/Dashboard/Model/custom_report_model.dart';
import 'package:gmart/UI/Dashboard/Model/local_product_list_response_model.dart'
    as lp;
import 'package:gmart/UI/Dashboard/Model/place_order_response_model.dart';
import 'package:gmart/UI/Dashboard/Model/product_list_reponse_model.dart';
import 'package:gmart/UI/Dashboard/Model/recall_hold_order_details_response_model.dart';
import 'package:gmart/UI/Dashboard/Model/recall_hold_order_response_model.dart';
import 'package:gmart/UI/Dashboard/Model/report_response_model.dart';
import 'package:gmart/UI/Dashboard/Model/scanned_product_response_model.dart';
import 'package:gmart/UI/Dashboard/View/selling_price_widget.dart';
import 'package:gmart/UI/Login/Model/login_response_model.dart';
import 'package:gmart/Utils/loading_dialog_box.dart';

class DashboardViewModel extends BaseModel {
  int categoryId = 0;
  CartListModel cartListModel = CartListModel();
  Calculation calculation = Calculation();
  List<ac.Category>? categoryProduct;
  int pageNo = 1;
  List<ProductsList> productList = [];
  int totalPage = 0;
  List<ScanProduct> scannedProduct = [];
  List<Transactions> holderOrder = [];
  List<SellDetails> sellerOrder = [];
  bool isUpiClear = false;
  CustomReportModel finalReport = CustomReportModel();
  static const MethodChannel _channel = MethodChannel('usb_printer_channel');
  String scanValue = "";
  String finalScanned = "";
  SharedPreferences? prefs;
  Details? cashDetails;
  RegisterDetails? cashRegDetails;
  String textUpdate = "Order Processing";
  String? lastPurchase = "";
  bool isComplete = false;
  List<ProductList> lastPurchaseList = [];


  Future<void> loadInitial() async {
    super.setState(ViewState.inActive);
    await getInitial().then(
          (value) async {
        if (value) {
          await getProductList(categoryId: categoryId, isInitial: true, page: 1)
              .then(
                (value) {
              if (value) {
                super.setState(ViewState.active);
              }
            },
          );
        }
      },
    );
  }


  Future<bool> getInitial() async {
    prefs = spEngine!.prefs;
    bool result = false;
    try {
      await httpEngine!
          .get(
              url: applicationCore!.appProfile.baseUrl! +
                  AppStrings.getAllCategoryProductUrl)
          .then(
        (value) {
          ac.AllCategoryProductResponseModel entity =
              ac.AllCategoryProductResponseModel.fromJson(value.data);
          categoryProduct = entity.category;
          prefs!.setBool(AppStrings.isUpdate, true);
          categoryId = entity.category![0].id ?? 0;
          cartListModel.productList = [];
          calculation.grandTotal = 0.0;
          calculation.discountAmount = 0.0;
          cartListModel.billNo = "";
          result = true;
        },
      );
    } on DioException catch (e) {
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> getLocalCategory() async {
    prefs = spEngine!.prefs;
    bool result = false;
    try {
      await DatabaseEngine().getTableValues(tableName: 'categories').then(
        (value) {
          ac.AllCategoryProductResponseModel entity =
              ac.AllCategoryProductResponseModel.fromJson({"category": value});
          categoryProduct = entity.category;
          categoryId =
              entity.category!.isEmpty ? 0 : entity.category![0].id ?? 0;
          cartListModel.productList = [];
          calculation.grandTotal = 0.0;
          calculation.discountAmount = 0.0;
          cartListModel.billNo = "";
          result = true;
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  /*Future<bool> getProductByScan(
      {required String scannedCode,
      required BuildContext context,
      required GlobalKey keyLoader}) async {
    bool result = false;
    prefs = spEngine!.prefs;
    try {
      LoadingDialogBox().loading(context, keyLoader);
      await httpEngine!
          .get(
        url:
            "${applicationCore!.appProfile.baseUrl!}${AppStrings.getScannedProductUrl}?location_id=${prefs!.getInt(AppStrings.businessLocations)}&term=$scannedCode&search_fields[0]=sku",
      )
          .then(
        (value) {
          ScannedProductResponseModel entity =
              ScannedProductResponseModel.fromJson(value.data);
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          scannedProduct = entity.product ?? [];
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
    }
    return result;
  }*/


  Future<bool> getProductBySearch({required String searchKey}) async {
    prefs = spEngine!.prefs;
    bool result = false;
    try {
      super.setState(ViewState.innerInActive);
      // LoadingDialogBox().loading(context, keyLoader);
      await httpEngine!
          .get(
        url:
            "${applicationCore!.appProfile.baseUrl!}${AppStrings.getScannedProductUrl}?location_id=${prefs!.getInt(AppStrings.businessLocations)}&term=$searchKey&search_fields[0]=name&search_fields[1]=sku",
      )
          .then(
        (value) {
          ScannedProductResponseModel entity =
              ScannedProductResponseModel.fromJson(value.data);
          // Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          super.setState(ViewState.innerActive);
          scannedProduct = entity.product ?? [];
          result = true;
        },
      );
    } on DioException catch (e) {
      super.setState(ViewState.innerActive);
      // Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      super.setState(ViewState.innerActive);
      // Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
    }
    return result;
  }
  Future<bool> getProductByScan({
    required String scannedCode,
    required BuildContext context,
    required GlobalKey keyLoader,
  }) async {
    bool result = false;
    prefs = spEngine!.prefs;

    try {
      int locationId = prefs!.getInt(AppStrings.businessLocations)!;

      // 1️⃣ Find matching product OR variant by barcode
      final joinedRows = await DatabaseEngine().executeRawQuery(
        query: """
      SELECT 
        p.*, 
        v.variation_double_id AS v_double_id,
        v.unit AS v_unit,
        v.barcode AS v_barcode,
        v.variation_id AS v_variation_id,
        v.selling_price_inc_tax AS v_price_tax,
        v.default_selling_price AS v_price,
        v.location_id AS v_location_id,
        v.product_id AS v_pid
      FROM products p
      LEFT JOIN variations v ON p.product_id = v.product_id
      WHERE 
        p.location_id = ?
        AND (p.barcode LIKE '%' || ? || '%' 
             OR v.barcode LIKE '%' || ? || '%');
      """,
        arguments: [locationId, scannedCode, scannedCode],
      );

      if (joinedRows.isEmpty) {
        scannedProduct = [];
        return true;
      }

      // 2️⃣ Extract unique product rows
      Map<int, Map<String, dynamic>> productMap = {};
      for (var row in joinedRows) {
        int pid = row['product_id'];
        productMap.putIfAbsent(pid, () => Map.from(row));
      }

      List<Map<String, dynamic>> products = productMap.values.toList();

      // 3️⃣ Extract product IDs
      List<int> productIds =
          products.map<int>((p) => p['product_id'] as int).toList();

      String idPlaceholders = List.filled(productIds.length, '?').join(',');

      // 4️⃣ Load ALL variations for these products
      final variations = await DatabaseEngine().executeRawQuery(
        query:
            "SELECT * FROM variations WHERE product_id IN ($idPlaceholders) AND location_id=${prefs!.getInt(AppStrings.businessLocations)}",
        arguments: productIds,
      );

      // 5️⃣ Group variations by product_id
      Map<int, List<Map<String, dynamic>>> variationMap = {};
      for (var v in variations) {
        int pid = v['product_id'];
        variationMap.putIfAbsent(pid, () => []);
        variationMap[pid]!.add(v);
      }

      // 6️⃣ Load categories
      List<int> categoryIds =
          products.map<int>((p) => p['category_id'] as int).toSet().toList();

      String catPlaceholders = List.filled(categoryIds.length, '?').join(',');

      final categories = await DatabaseEngine().executeRawQuery(
        query:
            "SELECT * FROM categories WHERE category_id IN ($catPlaceholders)",
        arguments: categoryIds,
      );

      Map<int, Map<String, dynamic>> categoryMap = {
        for (var c in categories) c['category_id']: c
      };

      // 7️⃣ Build OUTPUT (same as your search method)
      List<Map<String, dynamic>> output = [];

      for (var p in products) {
        int pid = p['product_id'];
        int catId = p['category_id'];
        final category = categoryMap[catId];

        output.add({
          ...p,
          'variation_double': variationMap[pid] ?? [],
          'is_age_limit': category?['age_limit'] != null
              ? {
                  'age': category?['age_limit'],
                  'age_limit_description': category?['age_description'],
                }
              : null,
          'is_time_limit': category?['from_time'] != null
              ? {
                  'from_time': category?['from_time'],
                  'to_time': category?['to_time'],
                  'time_description': category?['time_description'],
                }
              : null,
        });
      }

      // 8️⃣ Convert to Model
      ScannedProductResponseModel entity =
          ScannedProductResponseModel.fromJson({"product": output});

      scannedProduct = entity.product ?? [];

      super.setState(ViewState.innerActive);
      result = true;
    } catch (e) {
      debugPrint("Barcode scan error: $e");
    }

    return result;
  }

  /*Future<bool> getProductBySearch({required String searchKey}) async {
    bool result = false;
    prefs = spEngine!.prefs;

    try {
      final locationId = prefs!.getInt(AppStrings.businessLocations);

      // 1️⃣ Search in variations first
      List<Map<String, dynamic>> products =
          await DatabaseEngine().executeRawQuery(
        query: '''
        SELECT DISTINCT p.*
        FROM products p
        JOIN variations v ON p.product_id = v.product_id
        WHERE p.location_id = ? AND v.location_id = ? AND ('|' || v.barcode || '|' LIKE '%|' || ? || '|%')
      ''',
        arguments: [locationId, locationId, searchKey],
      );

      // 2️⃣ If not found, search in product barcode
      if (products.isEmpty) {
        products = await DatabaseEngine().executeRawQuery(
          query: '''
          SELECT *
          FROM products
          WHERE location_id = ? AND ('|' || barcode || '|' LIKE '%|' || ? || '|%')
        ''',
          arguments: [locationId, searchKey],
        );
      }

      // 3️⃣ If still not found, search by product name
      if (products.isEmpty) {
        products = await DatabaseEngine().executeRawQuery(
          query: '''
          SELECT *
          FROM products
          WHERE location_id = ? AND name LIKE '%' || ? || '%'
        ''',
          arguments: [locationId, searchKey],
        );
      }

      if (products.isEmpty) {
        scannedProduct = [];
        return true;
      }

      // Extract product IDs
      final productIds =
          products.map<int>((p) => p['product_id'] as int).toSet().toList();
      final idPlaceholders = List.filled(productIds.length, '?').join(',');

      // Load variations for found products
      final variations = await DatabaseEngine().executeRawQuery(
        query: '''
        SELECT *
        FROM variations
        WHERE product_id IN ($idPlaceholders) AND location_id = ?
      ''',
        arguments: [...productIds, locationId],
      );

      // Map variations by product_id
      final Map<int, List<Map<String, dynamic>>> variationMap = {};
      for (var v in variations) {
        final pid = v['product_id'];
        variationMap.putIfAbsent(pid, () => []).add(v);
      }

      // Load categories
      final categoryIds =
          products.map<int>((p) => p['category_id'] as int).toSet().toList();
      final catPlaceholders = List.filled(categoryIds.length, '?').join(',');

      final categories = await DatabaseEngine().executeRawQuery(
        query:
            "SELECT * FROM categories WHERE category_id IN ($catPlaceholders)",
        arguments: categoryIds,
      );

      final categoryMap = {for (var c in categories) c['category_id']: c};

      // Merge product + variations + category
      final output = products.map((p) {
        final pid = p['product_id'];
        final cat = categoryMap[p['category_id']];

        return {
          ...p,
          'variation_double': variationMap[pid] ?? [],
          'is_age_limit': cat?['age_limit'] != null
              ? {
                  'age': cat?['age_limit'],
                  'age_limit_description': cat?['age_description'],
                }
              : null,
          'is_time_limit': cat?['from_time'] != null
              ? {
                  'from_time': cat?['from_time'],
                  'to_time': cat?['to_time'],
                  'time_description': cat?['time_description'],
                }
              : null,
        };
      }).toList();

      scannedProduct =
          ScannedProductResponseModel.fromJson({'product': output}).product ??
              [];

      super.setState(ViewState.innerActive);
      result = true;
    } catch (e) {
      debugPrint("Search error: $e");
    }

    return result;
  }*/

  void handleKeyEvent(
      {required KeyEvent value,
      required String typeValue,
      required BuildContext context,
      required GlobalKey keyLoader,
      required Function() onDone}) async {
    if (value is KeyDownEvent) {
      final key = value.logicalKey;

      if (key == LogicalKeyboardKey.enter) {
        debugPrint("✅ Final Barcode: $scanValue");
        finalScanned = scanValue;
        scanValue = ''; // Clear buffer

        final value = await getProductByScan(
          scannedCode: finalScanned,
          context: context,
          keyLoader: keyLoader,
        );

        if (value) {
          if (isComplete) {
            Navigator.of(context).pop();
          }
          if (scannedProduct.isNotEmpty) {
            if (scannedProduct.length > 1) {
              getScannedDialog(context, typeValue, onDone);
            } else {
              final scanned = scannedProduct[0];
              if (scanned.isTimeLimit != null) {
                dialogueEngine!.showDialogueBox(
                    msg: scanned.isTimeLimit!.timeDescription ?? "");
              } else {
                if (scanned.isAgeLimit != null) {
                  showDialogueBox(
                    context: context,
                    msg: scanned.isAgeLimit!.ageLimitDescription ?? "",
                    onYes: () {
                      Navigator.of(context).pop();
                      if (scanned.variationDouble != null &&
                          scanned.variationDouble!.isNotEmpty) {
                       /* if (scanned.variationDouble!
                            .where((element) => element.name == scanned.name)
                            .isEmpty) {
                          scanned.variationDouble!.add(VariationDouble(
                            name: scanned.name ?? "",
                            id: 0,
                            barcode: scanned.barcode ?? "",
                            defaultSellPrice: scanned.sellingPrice ?? "",
                            unit: scanned.unit ?? "",
                            variationId: scanned.variationId.toString(),
                            productId: scanned.productId.toString(),
                          ));
                        }*/
                        List<VariationDouble> filter = scanned.variationDouble!
                            .where((element) =>
                                (element.barcode?.split('|') ?? [])
                                    .contains(finalScanned))
                            .toList();
                        if (filter.isEmpty) {
                          getDoublePrice(
                              typeValue: typeValue,
                              onDone: onDone,
                              context: context,
                              unit: scanned.unit,
                              productName: scanned.name,
                              variationDouble: scanned.variationDouble);
                        } else {
                          if (filter.length != 1) {
                            getDoublePrice(
                                typeValue: typeValue,
                                onDone: onDone,
                                context: context,
                                unit: scanned.unit,
                                productName: scanned.name,
                                variationDouble: filter);
                          } else {
                            if (filter[0].defaultSellPrice == "0" ||
                                filter[0].defaultSellPrice == "0.00" ||
                                filter[0].defaultSellPrice == "0.0000" ||
                                filter[0].defaultSellPrice == "") {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    content: SellingPriceWidget(
                                      onDone: (data) {
                                        if (typeValue.length <= 2) {
                                          final quantity = (typeValue
                                                  .isNotEmpty)
                                              ? double.tryParse(typeValue) ??
                                                  1.00
                                              : 1.00;
                                          final unitPrice = double.tryParse(
                                                  data['selling_price'] ??
                                                      "0.0") ??
                                              0.0;
                                          sellingUpdateList(
                                            name:
                                                "${scanned.name ?? ""} ${filter[0].name ?? ""}",
                                            quantity: quantity,
                                            unitPrice: unitPrice,
                                            isEdit:
                                                scanned.posSellQuantityEdit ??
                                                    "0",
                                            id: filter[0].productId.toString(),
                                            variantId: filter[0]
                                                .variationId
                                                .toString(),
                                            unit: scanned.unit.toString(),
                                            totalPrice: quantity * unitPrice,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "You are not allow to purchase the product by this quantity.",
                                              backgroundColor: Colors.red);
                                        }
                                        Navigator.of(context).pop();
                                        scannedProduct = [];
                                        onDone();
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              if (typeValue.length <= 2) {
                                final quantity = (typeValue.isNotEmpty)
                                    ? double.tryParse(typeValue) ?? 1.00
                                    : 1.00;
                                final unitPrice = double.tryParse(
                                        filter[0].defaultSellPrice ?? "0.0") ??
                                    0.0;
                                updateList(
                                  name: scanned.name ?? "",
                                  quantity: quantity,
                                  unitPrice: unitPrice,
                                  isEdit: scanned.posSellQuantityEdit ?? "0",
                                  id: scanned.productId.toString(),
                                  variantId: scanned.variationId.toString(),
                                  unit: scanned.unit.toString(),
                                  totalPrice: quantity * unitPrice,
                                );
                              } else {
                                Fluttertoast.showToast(
                                    msg:
                                        "You are not allow to purchase the product by this quantity.",
                                    backgroundColor: Colors.red);
                              }
                            }
                            scannedProduct = [];
                            onDone();
                          }
                        }
                      } else {
                        if (scanned.sellingPrice == "0" ||
                            scanned.sellingPrice == "0.00" ||
                            scanned.sellingPrice == "0.0000" ||
                            scanned.sellingPrice == "") {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                content: SellingPriceWidget(
                                  onDone: (data) {
                                    if (typeValue.length <= 2) {
                                      final quantity = (typeValue.isNotEmpty)
                                          ? double.tryParse(typeValue) ?? 1.00
                                          : 1.00;
                                      final unitPrice = double.tryParse(
                                              data['selling_price'] ?? "0.0") ??
                                          0.0;
                                      sellingUpdateList(
                                        name: scanned.name ?? "",
                                        quantity: quantity,
                                        unitPrice: unitPrice,
                                        isEdit:
                                            scanned.posSellQuantityEdit ?? "0",
                                        id: scanned.productId.toString(),
                                        variantId:
                                            scanned.variationId.toString(),
                                        unit: scanned.unit.toString(),
                                        totalPrice: quantity * unitPrice,
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "You are not allow to purchase the product by this quantity.",
                                          backgroundColor: Colors.red);
                                    }
                                    Navigator.of(context).pop();
                                    scannedProduct = [];
                                    onDone();
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          if (typeValue.length <= 2) {
                            final quantity = (typeValue.isNotEmpty)
                                ? double.tryParse(typeValue) ?? 1.00
                                : 1.00;
                            final unitPrice = double.tryParse(
                                    scanned.sellingPrice.toString()) ??
                                0.0;
                            updateList(
                              name: scanned.name ?? "",
                              quantity: quantity,
                              unitPrice: unitPrice,
                              isEdit: scanned.posSellQuantityEdit ?? "0",
                              id: scanned.productId.toString(),
                              variantId: scanned.variationId.toString(),
                              unit: scanned.unit.toString(),
                              totalPrice: quantity * unitPrice,
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "You are not allow to purchase the product by this quantity.",
                                backgroundColor: Colors.red);
                          }
                        }
                        scannedProduct = [];
                        onDone();
                      }
                    },
                  );
                } else {
                  if (scanned.variationDouble != null &&
                      scanned.variationDouble!.isNotEmpty) {
                    /*if (scanned.variationDouble!
                        .where((element) => element.name == scanned.name)
                        .isEmpty) {
                      scanned.variationDouble!.add(VariationDouble(
                        name: scanned.name ?? "",
                        id: 0,
                        barcode: scanned.barcode ?? "",
                        defaultSellPrice: scanned.sellingPrice ?? "",
                        unit: scanned.unit ?? "",
                        variationId: scanned.variationId.toString(),
                        productId: scanned.productId.toString(),
                      ));
                    }*/
                    List<VariationDouble> filter = scanned.variationDouble!
                        .where((element) => (element.barcode?.split('|') ?? [])
                            .contains(finalScanned))
                        .toList();
                    if (filter.isEmpty) {
                      getDoublePrice(
                          typeValue: typeValue,
                          onDone: onDone,
                          context: context,
                          unit: scanned.unit,
                          productName: scanned.name,
                          variationDouble: scanned.variationDouble);
                    } else {
                      if (filter.length != 1) {
                        getDoublePrice(
                            typeValue: typeValue,
                            onDone: onDone,
                            context: context,
                            unit: scanned.unit,
                            productName: scanned.name,
                            variationDouble: filter);
                      } else {
                        if (filter[0].defaultSellPrice == "0" ||
                            filter[0].defaultSellPrice == "0.00" ||
                            filter[0].defaultSellPrice == "0.0000" ||
                            filter[0].defaultSellPrice == "") {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)),
                                content: SellingPriceWidget(
                                  onDone: (data) {
                                    if (typeValue.length <= 2) {
                                      final quantity = (typeValue.isNotEmpty)
                                          ? double.tryParse(typeValue) ?? 1
                                          : 1.00;
                                      final unitPrice = double.tryParse(
                                              data['selling_price'] ?? "0.0") ??
                                          0.0;
                                      sellingUpdateList(
                                        name:
                                            "${scanned.name ?? ""} ${filter[0].name ?? ""}",
                                        quantity: quantity,
                                        unitPrice: unitPrice,
                                        isEdit: "0",
                                        id: filter[0].productId.toString(),
                                        variantId:
                                            filter[0].variationId.toString(),
                                        unit: scanned.unit.toString(),
                                        totalPrice: quantity * unitPrice,
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "You are not allow to purchase the product by this quantity.",
                                          backgroundColor: Colors.red);
                                    }
                                    Navigator.of(context).pop();
                                    scannedProduct = [];
                                    onDone();
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          if (typeValue.length <= 2) {
                            final quantity = (typeValue.isNotEmpty)
                                ? double.tryParse(typeValue) ?? 1
                                : 1.00;
                            final unitPrice = double.tryParse(
                                    filter[0].defaultSellPrice ?? "0.0") ??
                                0.0;
                            updateList(
                              name: scanned.name ?? "",
                              quantity: quantity,
                              unitPrice: unitPrice,
                              isEdit: scanned.posSellQuantityEdit ?? "0",
                              id: scanned.productId.toString(),
                              variantId: scanned.variationId.toString(),
                              unit: scanned.unit.toString(),
                              totalPrice: quantity * unitPrice,
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "You are not allow to purchase the product by this quantity.",
                                backgroundColor: Colors.red);
                          }
                        }
                        scannedProduct = [];
                        onDone();
                      }
                    }
                  } else {
                    if (scanned.sellingPrice == "0" ||
                        scanned.sellingPrice == "0.00" ||
                        scanned.sellingPrice == "0.0000" ||
                        scanned.sellingPrice == "") {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            content: SellingPriceWidget(
                              onDone: (data) {
                                if (typeValue.length <= 2) {
                                  final quantity = (typeValue.isNotEmpty)
                                      ? double.tryParse(typeValue) ?? 1
                                      : 1.00;
                                  final unitPrice = double.tryParse(
                                          data['selling_price'] ?? "0.0") ??
                                      0.0;
                                  sellingUpdateList(
                                    name: scanned.name ?? "",
                                    quantity: quantity,
                                    unitPrice: unitPrice,
                                    isEdit: scanned.posSellQuantityEdit ?? "0",
                                    id: scanned.productId.toString(),
                                    variantId: scanned.variationId.toString(),
                                    unit: scanned.unit.toString(),
                                    totalPrice: quantity * unitPrice,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "You are not allow to purchase the product by this quantity.",
                                      backgroundColor: Colors.red);
                                }
                                Navigator.of(context).pop();
                                scannedProduct = [];
                                onDone();
                              },
                            ),
                          );
                        },
                      );
                    } else {
                      if (typeValue.length <= 2) {
                        final quantity = (typeValue.isNotEmpty)
                            ? double.tryParse(typeValue) ?? 1
                            : 1.00;
                        final unitPrice =
                            double.tryParse(scanned.sellingPrice.toString()) ??
                                0.0;
                        updateList(
                          name: scanned.name ?? "",
                          quantity: quantity,
                          unitPrice: unitPrice,
                          isEdit: scanned.posSellQuantityEdit ?? "0",
                          id: scanned.productId.toString(),
                          variantId: scanned.variationId.toString(),
                          unit: scanned.unit.toString(),
                          totalPrice: quantity * unitPrice,
                        );
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                "You are not allow to purchase the product by this quantity.",
                            backgroundColor: Colors.red);
                      }
                    }
                    scannedProduct = [];
                    onDone();
                  }
                }
              }
            }
          } else {
            Fluttertoast.showToast(msg: "No products are available");
          }
        }
      } else {
        final char = value.character;
        if (char != null && char.isNotEmpty && char.codeUnitAt(0) >= 32) {
          scanValue += char;
        }
      }
    }
  }

  showDialogueBox(
      {String? msg, required Function() onYes, required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Row(
              children: [
                Expanded(
                    child: Divider(
                  height: 2,
                  color: Colors.black12,
                )),
                SizedBox(
                  width: 15.0,
                ),
                Text(AppStrings.appName),
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                    child: Divider(
                  height: 2,
                  color: Colors.black12,
                )),
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(msg ?? "")
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: onYes,
            child: const Text("Yes"),
          ),
          const SizedBox(
            width: 15.0,
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
        ],
      ),
    );
  }

  void getDoublePrice(
      {List<VariationDouble>? variationDouble,
      String? productName,
      String? unit,
      required String typeValue,
      required Function() onDone,
      required BuildContext context}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 250, // Limit dialog height (adjust as needed)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productName ?? "",
                    style: TextStyle(
                        color: AppColor.blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      // Prevent nested scrolling
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        // 🔧 Adjust based on how many items per row
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 5.0,
                        mainAxisExtent:
                            80.0, // 🔧 Optional fixed height for each card
                      ),
                      itemCount: variationDouble!.length,
                      itemBuilder: (context, index) {
                        final e = variationDouble[index];
                        return InkResponse(
                          onTap: () async {
                            Navigator.of(context).pop();
                            if (e.defaultSellPrice == "0" ||
                                e.defaultSellPrice == "0.00" ||
                                e.defaultSellPrice == "0.0000" ||
                                e.defaultSellPrice!.isEmpty) {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    content: SellingPriceWidget(
                                      onDone: (data) {
                                        if (typeValue.isNotEmpty) {
                                          if (typeValue.length <= 2) {
                                            final quantity =
                                                double.tryParse(typeValue) ??
                                                    1.0;
                                            sellingUpdateList(
                                              name:
                                                  "$productName ${ variationDouble[index].id == null || variationDouble[index].id == 0 ? "" : variationDouble[index].name ?? ""}",
                                              quantity: quantity,
                                              unitPrice: double.parse(
                                                  data['selling_price'] ??
                                                      "0.0"),
                                              isEdit: "0",
                                              id: variationDouble[index]
                                                  .productId
                                                  .toString(),
                                              variantId: variationDouble[index]
                                                  .variationId
                                                  .toString(),
                                              unit:
                                                  variationDouble[index].unit ??
                                                      "",
                                              variationDoubleId:
                                                  variationDouble[index].id,
                                              totalPrice: quantity *
                                                  double.parse(
                                                      data['selling_price'] ??
                                                          "0.0"),
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You are not allow to purchase the product by this quantity.",
                                                backgroundColor: Colors.red);
                                          }
                                          scannedProduct = [];
                                          onDone();
                                        } else {
                                          sellingUpdateList(
                                            name:
                                                "$productName ${variationDouble[index].id == null || variationDouble[index].id == 0 ? "" : variationDouble[index].name ?? ""}",
                                            quantity: 1,
                                            unitPrice: double.parse(
                                                data['selling_price'] ?? "0.0"),
                                            id: variationDouble[index]
                                                .productId
                                                .toString(),
                                            variantId: variationDouble[index]
                                                .variationId
                                                .toString(),
                                            unit: variationDouble[index].unit ??
                                                "",
                                            isEdit: "0",
                                            variationDoubleId:
                                                variationDouble[index].id,
                                            totalPrice: 1 *
                                                double.parse(
                                                    data['selling_price'] ??
                                                        "0.0"),
                                          );
                                          scannedProduct = [];
                                          onDone();
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              if (typeValue.isNotEmpty) {
                                if (typeValue.length <= 2) {
                                  final quantity =
                                      double.tryParse(typeValue) ?? 1.00;
                                  updateList(
                                    name:
                                        "$productName ${variationDouble[index].id == null ||  variationDouble[index].id == 0 ? "" : variationDouble[index].name ?? ""}",
                                    quantity: quantity,
                                    unitPrice: double.parse(
                                        variationDouble[index]
                                                .defaultSellPrice ??
                                            "0.00"),
                                    id: variationDouble[index]
                                        .productId
                                        .toString(),
                                    isEdit: "0",
                                    variantId: variationDouble[index]
                                        .variationId
                                        .toString(),
                                    unit: variationDouble[index].unit ?? "",
                                    variationDoubleId:
                                        variationDouble[index].id,
                                    totalPrice: quantity *
                                        double.parse(variationDouble[index]
                                                .defaultSellPrice ??
                                            "0.00"),
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "You are not allow to purchase the product by this quantity.",
                                      backgroundColor: Colors.red);
                                }
                                scannedProduct = [];
                                onDone();
                              } else {
                                updateList(
                                  name:
                                      "$productName ${variationDouble[index].id == null || variationDouble[index].id == 0 ? "" : variationDouble[index].name ?? ""}",
                                  quantity: 1,
                                  unitPrice: double.parse(
                                      variationDouble[index].defaultSellPrice ??
                                          "0.00"),
                                  id: variationDouble[index]
                                      .productId
                                      .toString(),
                                  isEdit: "0",
                                  variantId: variationDouble[index]
                                      .variationId
                                      .toString(),
                                  unit: variationDouble[index].unit ?? "",
                                  variationDoubleId: variationDouble[index].id,
                                  totalPrice: 1 *
                                      double.parse(variationDouble[index]
                                              .defaultSellPrice ??
                                          "0.00"),
                                );
                                scannedProduct = [];
                                onDone();
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade600,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${e.name.toString()} ${e.unit!.isNotEmpty ? "(${e.unit ?? ""})" : ""}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15.0),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  "U.Price : ${double.parse(e.defaultSellPrice ?? "0.00").toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void getScannedDialog(context, typeValue, Function() onDone) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.all(16),
          contentPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: const Row(
            children: [
              Expanded(child: Divider(color: Colors.black12)),
              SizedBox(width: 15.0),
              Text(AppStrings.appName),
              SizedBox(width: 15.0),
              Expanded(child: Divider(color: Colors.black12)),
            ],
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 250, // Limit dialog height (adjust as needed)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text("Product Variants"),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 2.0,
                        mainAxisSpacing: 2.0,
                        mainAxisExtent: 50, // 👈 fixed height for each item
                      ),
                      itemCount: scannedProduct.length,
                      itemBuilder: (context, index) {
                        final product = scannedProduct[index];
                        final quantity =
                            double.tryParse(typeValue ?? "") ?? 1.00;
                        final price =
                            double.tryParse(product.sellingPrice ?? "0") ?? 0.0;

                        return InkWell(
                          onTap: () {
                            if (product.isTimeLimit != null) {
                              Navigator.of(context).pop();
                              dialogueEngine!.showDialogueBox(
                                  msg: product.isTimeLimit!.timeDescription ??
                                      "");
                            } else {
                              if (product.isAgeLimit != null) {
                                showDialogueBox(
                                    onYes: () {
                                      Navigator.of(context).pop();
                                      if (product.variationDouble != null &&
                                          product.variationDouble!.isNotEmpty) {
                                       /* if (product.variationDouble!
                                            .where((element) =>
                                                element.name == product.name)
                                            .isEmpty) {
                                          product.variationDouble!
                                              .add(VariationDouble(
                                            name: product.name ?? "",
                                            id: 0,
                                            barcode: product.barcode ?? "",
                                            defaultSellPrice:
                                                product.sellingPrice ?? "",
                                            unit: product.unit ?? "",
                                            variationId:
                                                product.variationId.toString(),
                                            productId:
                                                product.productId.toString(),
                                          ));
                                        }*/
                                        Navigator.of(context).pop();
                                        getDoublePrice(
                                            unit: product.unit.toString(),
                                            productName: product.name ?? "",
                                            variationDouble:
                                                product.variationDouble ?? [],
                                            typeValue: typeValue,
                                            onDone: onDone,
                                            context: context);
                                      } else {
                                        Navigator.of(context).pop();
                                        if (product.sellingPrice == "0" ||
                                            product.sellingPrice == "0.00" ||
                                            product.sellingPrice == "0.0000" ||
                                            product.sellingPrice == "") {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0)),
                                                content: SellingPriceWidget(
                                                  onDone: (data) {
                                                    if (typeValue!.length <=
                                                        2) {
                                                      sellingUpdateList(
                                                        name:
                                                            product.name ?? "",
                                                        quantity: quantity,
                                                        unitPrice: double.parse(
                                                            data['selling_price'] ??
                                                                "0.0"),
                                                        id: product.productId
                                                            .toString(),
                                                        isEdit: product
                                                                .posSellQuantityEdit ??
                                                            "0",
                                                        variantId: product
                                                            .variationId
                                                            .toString(),
                                                        unit: product.unit
                                                            .toString(),
                                                        totalPrice: quantity *
                                                            double.parse(data[
                                                                    'selling_price'] ??
                                                                "0.0"),
                                                      );
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "You are not allow to purchase the product by this quantity.",
                                                          backgroundColor:
                                                              Colors.red);
                                                    }
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          if (typeValue!.length <= 2) {
                                            updateList(
                                              name: product.name ?? "",
                                              quantity: quantity,
                                              unitPrice: price,
                                              id: product.productId.toString(),
                                              variantId: product.variationId
                                                  .toString(),
                                              isEdit:
                                                  product.posSellQuantityEdit ??
                                                      "0",
                                              unit: product.unit.toString(),
                                              totalPrice: quantity * price,
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "You are not allow to purchase the product by this quantity.",
                                                backgroundColor: Colors.red);
                                          }
                                        }
                                        scannedProduct = [];
                                        onDone();
                                      }
                                    },
                                    context: context);
                              } else {
                                if (product.variationDouble != null &&
                                    product.variationDouble!.isNotEmpty) {
                                  /*if (product.variationDouble!
                                      .where((element) =>
                                          element.name == product.name)
                                      .isEmpty) {
                                    product.variationDouble!
                                        .add(VariationDouble(
                                      name: product.name ?? "",
                                      id: 0,
                                      barcode: product.barcode ?? "",
                                      defaultSellPrice:
                                          product.sellingPrice ?? "",
                                      unit: product.unit ?? "",
                                      variationId:
                                          product.variationId.toString(),
                                      productId: product.productId.toString(),
                                    ));
                                  }*/
                                  Navigator.of(context).pop();
                                  getDoublePrice(
                                      unit: product.unit.toString(),
                                      productName: product.name ?? "",
                                      variationDouble:
                                          product.variationDouble ?? [],
                                      typeValue: typeValue,
                                      onDone: onDone,
                                      context: context);
                                } else {
                                  Navigator.of(context).pop();
                                  if (product.sellingPrice == "0" ||
                                      product.sellingPrice == "0.00" ||
                                      product.sellingPrice == "0.0000" ||
                                      product.sellingPrice == "") {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0)),
                                          content: SellingPriceWidget(
                                            onDone: (data) {
                                              if (typeValue!.length <= 2) {
                                                sellingUpdateList(
                                                  name: product.name ?? "",
                                                  quantity: quantity,
                                                  unitPrice: double.parse(
                                                      data['selling_price'] ??
                                                          "0.0"),
                                                  id: product.productId
                                                      .toString(),
                                                  variantId: product.variationId
                                                      .toString(),
                                                  isEdit: product
                                                          .posSellQuantityEdit ??
                                                      "0",
                                                  unit: product.unit.toString(),
                                                  totalPrice: quantity *
                                                      double.parse(data[
                                                              'selling_price'] ??
                                                          "0.0"),
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "You are not allow to purchase the product by this quantity.",
                                                    backgroundColor:
                                                        Colors.red);
                                              }
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    if (typeValue!.length <= 2) {
                                      updateList(
                                        name: product.name ?? "",
                                        quantity: quantity,
                                        unitPrice: price,
                                        isEdit:
                                            product.posSellQuantityEdit ?? "0",
                                        id: product.productId.toString(),
                                        variantId:
                                            product.variationId.toString(),
                                        unit: product.unit.toString(),
                                        totalPrice: quantity * price,
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg:
                                              "You are not allow to purchase the product by this quantity.",
                                          backgroundColor: Colors.red);
                                    }
                                  }
                                  scannedProduct = [];
                                  onDone();
                                }
                              }
                            }
                          },
                          child: Container(
                            // Optional: not required when using mainAxisExtent
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade600,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                "${product.name ?? ""}${product.variation != null && product.variation!.isNotEmpty ? " (${product.variation})" : ""}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12.0),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> getProductList(
      {required int categoryId,
      bool isInitial = false,
      BuildContext? context,
      GlobalKey? keyLoader,
      required int page}) async {
    bool result = false;
    prefs = spEngine!.prefs;
    try {
      if (!isInitial) {
        LoadingDialogBox().loading(context!, keyLoader!);
      }
      await httpEngine!
          .get(
              url:
                  "${applicationCore!.appProfile.baseUrl!}${AppStrings.getCategoryProductListUrl}?category_id=$categoryId&location_id=${prefs!.getInt(AppStrings.businessLocations)}&page=$page")
          .then(
        (value) {
          ProductListResponseModel entity =
              ProductListResponseModel.fromJson(value.data);
          if (!isInitial) {
            Navigator.of(keyLoader!.currentContext!, rootNavigator: true).pop();
          }
          totalPage = entity.products!.total ?? 0;
          if (page == 1) {
            pageNo = 1;
            productList = [];
            productList = entity.products!.data ?? [];
          } else {
            productList.addAll(entity.products!.data ?? []);
          }
          result = true;
        },
      );
    } on DioException catch (e) {
      if (!isInitial) {
        Navigator.of(keyLoader!.currentContext!, rootNavigator: true).pop();
      }
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      if (!isInitial) {
        Navigator.of(keyLoader!.currentContext!, rootNavigator: true).pop();
      }
      debugPrint(e.toString());
    }
    return result;
  }

  /*Future<bool> getLocalProductList(
      {required int categoryId,
      bool isInitial = false,
      BuildContext? context,
      GlobalKey? keyLoader,
      required int page}) async {
    bool result = false;
    prefs = spEngine!.prefs;
    try {
      await DatabaseEngine()
          .executeQuery(
              tableName: 'products',
              whereQuery:
                  'location_id=${prefs!.getInt(AppStrings.businessLocations)}')
          .then(
        (value) {
          ProductListReponseModel entity = ProductListReponseModel.fromJson({
            "products": {"data": value}
          });
          if (!isInitial) {
            Navigator.of(keyLoader!.currentContext!, rootNavigator: true).pop();
          }
          productList = [];
          productList = entity.products!.data ?? [];
          result = true;
        },
      );
    } catch (e) {
      if (!isInitial) {
        Navigator.of(keyLoader!.currentContext!, rootNavigator: true).pop();
      }
      debugPrint(e.toString());
    }
    return result;
  }*/

  /*Future<bool> getProductsWithVariants(int categoryId) async {
    bool result = false;
    try {
      final products = await DatabaseEngine().executeQuery(
        tableName: 'products',
        whereQuery: 'category_id = ?',
        whereArgs: [categoryId],
      );
      List<Map<String, dynamic>> output = [];
      for (var p in products) {
        final variants = await DatabaseEngine().executeQuery(
          tableName: 'variations',
          whereQuery: 'product_id = ?',
          whereArgs: [p['product_id']],
        );
        final category = await DatabaseEngine().executeQuery(
          tableName: 'categories',
          whereQuery: 'category_id = ?',
          whereArgs: [p['category_id']],
        );
        output.add({
          ...p,
          'variation_double': variants,
          'is_age_limit': category[0]['age_limit'] != null
              ? {
                  'age': category[0]['age_limit'],
                  'age_limit_description': category[0]['age_description'],
                }
              : null,
          'is_time_limit': category[0]['from_time'] != null
              ? {
                  'from_time': category[0]['from_time'],
                  'to_time': category[0]['to_time'],
                  'time_description': category[0]['time_description'],
                }
              : null
        });
      }
      lp.LocalProductListResponseModel entity =
          lp.LocalProductListResponseModel.fromJson({"data": output});
      productList = [];
      productList = entity.data ?? [];
      result = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }*/
  Future<bool> getProductsWithVariants(int categoryId) async {
    bool result = false;
    prefs = spEngine!.prefs;
    try {
      // 1️⃣ Load products of this category
      final products = await DatabaseEngine().executeQuery(
        tableName: 'products',
        whereQuery:
            'category_id = ? AND location_id = ${prefs!.getInt(AppStrings.businessLocations)}',
        whereArgs: [categoryId],
      );
      debugPrint("Total Product Count ${products.length}");
      if (products.isEmpty) return true;

      // Get all product_ids for batch fetching
      List<int> productIds =
          products.map<int>((p) => p['product_id'] as int).toList();

      // Convert productIds to "?,?,?" for SQL IN clause
      String idsQuery = List.filled(productIds.length, '?').join(',');

      // 2️⃣ Load ALL variations for ALL products (One SQL)
      final variations = await DatabaseEngine().executeRawQuery(
        query:
            "SELECT * FROM variations WHERE product_id IN ($idsQuery) AND location_id=${prefs!.getInt(AppStrings.businessLocations)}",
        arguments: productIds,
      );

      // Group variations by product_id
      Map<int, List<Map<String, dynamic>>> variationMap = {};
      for (var v in variations) {
        int pid = v['product_id'];
        variationMap.putIfAbsent(pid, () => []);
        variationMap[pid]!.add(v);
      }

      // 3️⃣ Load ALL categories for these products (One SQL)
      // Get unique category_ids
      List<int> categoryIds =
          products.map<int>((p) => p['category_id'] as int).toSet().toList();

      String catQuery = List.filled(categoryIds.length, '?').join(',');

      final categories = await DatabaseEngine().executeRawQuery(
        query: "SELECT * FROM categories WHERE category_id IN ($catQuery)",
        arguments: categoryIds,
      );

      // Map category by id for quick access
      Map<int, Map<String, dynamic>> categoryMap = {
        for (var c in categories) c['category_id']: c
      };

      // 4️⃣ Merge product + variations + category (Fast)
      List<Map<String, dynamic>> output = [];

      for (var p in products) {
        final pid = p['product_id'];
        final catId = p['category_id'];

        final category = categoryMap[catId];

        output.add({
          ...p,
          'variation_double': variationMap[pid] ?? [],
          'is_age_limit': category?['age_limit'] != null
              ? {
                  'age': category?['age_limit'],
                  'age_limit_description': category?['age_description'],
                }
              : null,
          'is_time_limit': category?['from_time'] != null
              ? {
                  'from_time': category?['from_time'],
                  'to_time': category?['to_time'],
                  'time_description': category?['time_description'],
                }
              : null,
        });
      }

      // Convert to model
      lp.LocalProductListResponseModel entity =
          lp.LocalProductListResponseModel.fromJson({"data": output});

      productList = entity.data ?? [];
      result = true;
    } catch (e) {
      debugPrint("Error: $e");
    }

    return result;
  }

  Future<bool> cashCloseApi(
      {required Map<String, dynamic> postBody,
      required String cashId,
      required BuildContext context,
      required GlobalKey key}) async {
    bool result = false;
    LoadingDialogBox().loading(context, key);
    prefs = spEngine!.prefs;
    try {
      await httpEngine!
          .post(
              url:
                  "${applicationCore!.appProfile.baseUrl!}${AppStrings.cashDrawerCloseUrl}/$cashId",
              postData: postBody)
          .then(
        (value) {
          Navigator.of(key.currentContext!, rootNavigator: true).pop();
          cashCheck();
          prefs!.setInt(AppStrings.isCash, 0);
          prefs!.setInt(AppStrings.cashId, 0);
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(key.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(msg: e.response!.data['message'] ?? "");
    } catch (e) {
      debugPrint(e.toString());
      result = false;
    }
    return result;
  }

  Future<bool> cashCheck() async {
    bool result = false;
    prefs = spEngine!.prefs;
    try {
      await httpEngine!
          .get(
              url: applicationCore!.appProfile.baseUrl! +
                  AppStrings.initialDataUrl)
          .then(
        (value) async {
          LoginResponseModel entity = LoginResponseModel.fromJson(value.data);
          prefs!.setString(
              AppStrings.locationsList, jsonEncode(entity.locations ?? []));
          await prefs!.setString(AppStrings.denominationList,
              jsonEncode(entity.posSettings!.cashDenominations ?? []));
          // List<Payment> payment = entity.payment ?? [];
          // prefs!.setString(AppStrings.paymentList, jsonEncode(payment));
        },
      );
    } on DioException catch (e) {
      dialogueEngine!.showDialogueBox(msg: e.response!.data['message'] ?? "");
    } catch (e) {
      debugPrint(e.toString());
      result = false;
    }
    return result;
  }

  Future<bool> getHolderOrder(
      {required BuildContext context,
      required GlobalKey keyLoader,
      required String url}) async {
    bool result = false;
    LoadingDialogBox().loading(context, keyLoader);
    try {
      await httpEngine!
          .get(url: applicationCore!.appProfile.baseUrl! + url)
          .then(
        (value) {
          RecallHoldOrderResponseModel entity =
              RecallHoldOrderResponseModel.fromJson(value.data);
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          holderOrder = entity.transactions ?? [];
           result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> getHolderOrderDetails(
      {required BuildContext context,
      required GlobalKey keyLoader,
      required int draftId}) async {
    bool result = false;
    LoadingDialogBox().loading(context, keyLoader);
    try {
      await httpEngine!
          .get(
              url:
                  "${applicationCore!.appProfile.baseUrl!}${AppStrings.recallHoldOrderDetailsUrl}$draftId/edit")
          .then(
        (value) {
          RecallHoldOrderDetailsResponseModel entity =
              RecallHoldOrderDetailsResponseModel.fromJson(value.data);
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          sellerOrder = entity.sellDetails ?? [];
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
    }
    return result;
  }

  Future<void> loadMore(
      BuildContext context, GlobalKey keyLoader, int id) async {
    if (totalPage > productList.length) {
      pageNo++;
      await getProductList(
          categoryId: id, page: pageNo, keyLoader: keyLoader, context: context);
    }
  }

  Future<bool> updateList(
      {required String name,
      required double quantity,
      required double unitPrice,
      required String id,
      required String variantId,
      required String unit,
      required double totalPrice,
      required String isEdit,
      int? variationDoubleId}) async {
    bool result = false;
    if (cartListModel.billNo == null || cartListModel.billNo!.isNotEmpty) {
      cartListModel.billNo = "";
      cartListModel.cashPaid = "0.0";
      cartListModel.balance = "0.0";
      cartListModel.productList!.clear();
      calculation.grandTotal = 0.0;
      calculation.discountAmount = 0.0;
      cartListModel.discountAmount = 0.0;
    }
    List<ProductList> selectedList = cartListModel.productList!
        .where(
          (element) => element.name == name,
        )
        .toList();

    if (selectedList.isEmpty) {
      cartListModel.productList!.addAll([
        ProductList(
            id: id,
            productVariantId: variantId,
            name: name,
            quantity: quantity,
            totalPrice: (totalPrice * 20).ceil() / 20,
            unit: unit,
            isEdit: isEdit,
            unitPrice: unitPrice,
            variationDoubleId: variationDoubleId)
      ]);
      calculation.grandTotal = cartListModel.productList!
          .map((item) => item.totalPrice as double)
          .reduce((a, b) => a + b);
      result = true;
    } else {
      int index = cartListModel.productList!
          .indexWhere((product) => product.name == selectedList[0].name);
      cartListModel.productList![index].isEdit = isEdit;
      cartListModel.productList![index].quantity =
          cartListModel.productList![index].quantity! + quantity;
      cartListModel.productList![index].unitPrice =
          double.parse(unitPrice.toStringAsFixed(2));
      cartListModel.productList![index].totalPrice = double.parse(
          (unitPrice * cartListModel.productList![index].quantity!)
              .toStringAsFixed(2));
      calculation.grandTotal = double.parse(cartListModel.productList!
          .map((item) => item.totalPrice as double)
          .reduce((a, b) => a + b)
          .toStringAsFixed(2));
      result = true;
    }
    return result;
  }

  Future<bool> sellingUpdateList(
      {required String name,
      required double quantity,
      required double unitPrice,
      required String id,
      required String variantId,
      required String unit,
      required double totalPrice,
      required String isEdit,
      int? variationDoubleId}) async {
    bool result = false;
    if (cartListModel.billNo == null || cartListModel.billNo!.isNotEmpty) {
      cartListModel.billNo = "";
      cartListModel.cashPaid = "0.0";
      cartListModel.balance = "0.0";
      cartListModel.productList!.clear();
      calculation.grandTotal = 0.0;
      calculation.discountAmount = 0.0;
      cartListModel.discountAmount = 0.0;
    }
    List<ProductList> selectedList = cartListModel.productList!
        .where(
          (element) =>
              element.name == name &&
              element.unitPrice!.toStringAsFixed(2) ==
                  unitPrice.toStringAsFixed(2),
        )
        .toList();

    if (selectedList.isEmpty) {
      cartListModel.productList!.addAll([
        ProductList(
            id: id,
            productVariantId: variantId,
            name: name,
            quantity: quantity,
            totalPrice: (totalPrice * 20).ceil() / 20,
            unit: unit,
            unitPrice: unitPrice,
            isEdit: isEdit,
            variationDoubleId: variationDoubleId)
      ]);
      calculation.grandTotal = cartListModel.productList!
          .map((item) => item.totalPrice as double)
          .reduce((a, b) => a + b);
      result = true;
    } else {
      int index = cartListModel.productList!
          .indexWhere((product) => product.name == selectedList[0].name);
      cartListModel.productList![index].isEdit = isEdit;
      cartListModel.productList![index].quantity =
          cartListModel.productList![index].quantity! + quantity;
      cartListModel.productList![index].unitPrice =
          double.parse(unitPrice.toStringAsFixed(2));
      cartListModel.productList![index].totalPrice = double.parse(
          (unitPrice * cartListModel.productList![index].quantity!)
              .toStringAsFixed(2));
      calculation.grandTotal = double.parse(cartListModel.productList!
          .map((item) => item.totalPrice as double)
          .reduce((a, b) => a + b)
          .toStringAsFixed(2));
      result = true;
    }
    return result;
  }

  Future<bool> deleteProduct({required String index}) async {
    bool result = false;
    int deleteIndex =
        cartListModel.productList!.indexWhere((element) => element.id == index);
    List<ProductList> selectedList = cartListModel.productList!
        .where(
          (element) => element.id == index,
        )
        .toList();
    if (selectedList.isNotEmpty || selectedList[0].id == index) {
      cartListModel.productList!.removeAt(deleteIndex);
      if (cartListModel.productList!.isNotEmpty) {
        calculation.grandTotal = double.parse(cartListModel.productList!
            .map((item) => item.totalPrice as double)
            .reduce((a, b) => a + b)
            .toStringAsFixed(2));
      } else {
        calculation.grandTotal = 0.0;
        cartListModel.cashPaid = "0.0";
        cartListModel.balance = "0.0";
        cartListModel.discountAmount = 0.0;
        calculation.discountAmount = 0.0;
      }
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  updateXAction(
      {required int index, required int quantity, String? selectedName}) async {
    var dummy = cartListModel.productList!
        .where(
          (element) => element.name == selectedName,
        )
        .toList();
    if (dummy.isNotEmpty) {
      dummy[0].quantity = double.parse(quantity.toString());
      dummy[0].totalPrice =
          double.parse((quantity * dummy[0].unitPrice!).toStringAsFixed(2));
      calculation.grandTotal = double.parse(cartListModel.productList!
          .map((item) => item.totalPrice as double)
          .reduce((a, b) => a + b)
          .toStringAsFixed(2));
    }
  }

  updateProduct({required String name, String? tag}) {
    List<ProductList> selectedList = cartListModel.productList!
        .where(
          (element) => element.name == name,
        )
        .toList();
    int index = cartListModel.productList!
        .indexWhere((product) => product.name == selectedList[0].name);
    if (selectedList.isNotEmpty) {
      if (tag! == "add") {
        cartListModel.productList![index].quantity =
            cartListModel.productList![index].quantity! + 1;
        cartListModel.productList![index].totalPrice = double.parse(
            (cartListModel.productList![index].quantity! *
                    cartListModel.productList![index].unitPrice!)
                .toStringAsFixed(2));
        calculation.grandTotal = double.parse(cartListModel.productList!
            .map((item) => item.totalPrice as double)
            .reduce((a, b) => a + b)
            .toStringAsFixed(2));
      } else {
        cartListModel.productList![index].quantity =
            cartListModel.productList![index].quantity! - 1;
        cartListModel.productList![index].totalPrice = double.parse(
            (cartListModel.productList![index].quantity! *
                    cartListModel.productList![index].unitPrice!)
                .toStringAsFixed(2));
        calculation.grandTotal = double.parse(cartListModel.productList!
            .map((item) => item.totalPrice as double)
            .reduce((a, b) => a + b)
            .toStringAsFixed(2));
      }
    }
  }

  sellingUpdateProduct(
      {required String name,
      required String? tag,
      required double uPrice,
      required String isEdit}) {
    List<ProductList> selectedList = cartListModel.productList!
        .where(
          (element) => element.name == name && element.unitPrice == uPrice,
        )
        .toList();
    int index = cartListModel.productList!.indexWhere((product) =>
        product.name == selectedList[0].name &&
        product.unitPrice == selectedList[0].unitPrice);
    if (selectedList.isNotEmpty) {
      if (tag! == "add") {
        cartListModel.productList![index].isEdit = isEdit;
        cartListModel.productList![index].quantity =
            cartListModel.productList![index].quantity! + 1;
        cartListModel.productList![index].totalPrice = (double.parse(
                        (cartListModel.productList![index].quantity! *
                                cartListModel.productList![index].unitPrice!)
                            .toStringAsFixed(2)) *
                    20)
                .ceil() /
            20;
        calculation.grandTotal = double.parse(cartListModel.productList!
            .map((item) => item.totalPrice as double)
            .reduce((a, b) => a + b)
            .toStringAsFixed(2));
      } else {
        cartListModel.productList![index].isEdit = isEdit;
        cartListModel.productList![index].quantity =
            cartListModel.productList![index].quantity! - 1;
        cartListModel.productList![index].totalPrice = (double.parse(
                        (cartListModel.productList![index].quantity! *
                                cartListModel.productList![index].unitPrice!)
                            .toStringAsFixed(2)) *
                    20)
                .ceil() /
            20;
        calculation.grandTotal = double.parse(cartListModel.productList!
            .map((item) => item.totalPrice as double)
            .reduce((a, b) => a + b)
            .toStringAsFixed(2));
      }
    }
  }

  Future<bool> placeOrder(postData,
      {required BuildContext context,
      required GlobalKey keyLoader,
      required String url}) async {
    bool result = false;
    debugPrint(postData.toString());
    try {
      LoadingDialogBox().loading(context, keyLoader);
      await httpEngine!
          .post(
              url: applicationCore!.appProfile.baseUrl! + url,
              postData: postData)
          .then(
        (value) async {
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          PlaceOrderResponseModel entity =
              PlaceOrderResponseModel.fromJson(value.data);
          if (entity.success == 1) {
            if (entity.receipt != null) {
              cartListModel.billNo = entity.receipt!.invoiceNo ?? "0.0";
            }
            result = true;
          } else {
            dialogueEngine!.showDialogueBox(msg: entity.msg ?? "");
          }
        },
      );
    } on DioException catch (e) {
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> holdOrder(postData,
      {required BuildContext context,
      required GlobalKey keyLoader,
      required String url}) async {
    bool result = false;
    try {
      LoadingDialogBox().loading(context, keyLoader);
      await httpEngine!
          .post(
              url: applicationCore!.appProfile.baseUrl! +
                  // AppStrings.placeOrderUrl,
                  url,
              postData: postData)
          .then(
        (value) async {
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          if (value.data['success'] != null && value.data['success'] == 1) {
            result = true;
          }
        },
      );
    } on DioException catch (e) {
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future updateData(MethodCall event) async {
    String tag = event.method;
    getData(tag, event);
  }

  getData(
    String tag,
    MethodCall event,
  ) {
    switch (tag) {
      case "qr":
        isUpiClear = !isUpiClear;
        break;
    }
  }

  Future<bool> voidOrder(postData,
      {required BuildContext context,
      required GlobalKey keyLoader,
      required String id}) async {
    bool result = false;
    try {
      LoadingDialogBox().loading(context, keyLoader);
      await httpEngine!
          .post(
              url: applicationCore!.appProfile.baseUrl! +
                  AppStrings.recallOrderUpdateUrl +
                  id.toString(),
              postData: postData)
          .then(
        (value) async {
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          if (value.data['success'] != null && value.data['success'] == 1) {
            result = true;
          }
        },
      );
    } on DioException catch (e) {
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<List<dynamic>> getConnectedPrinters() async {
    return await _channel.invokeMethod('getConnectedPrinters');
  }

  Future<bool> requestUsbPermission(String deviceId) async {
    return await _channel
        .invokeMethod('requestUsbPermission', {'deviceId': deviceId});
  }

  Future<bool> printData(String deviceId, List<int> data) async {
    return await _channel.invokeMethod('printData', {
      'deviceId': deviceId,
      'data': data,
    });
  }

  Future<bool> purchaseReport(
      {required BuildContext context, required GlobalKey keyLoader}) async {
    prefs = spEngine!.prefs;
    bool result = false;
    try {
      LoadingDialogBox().loading(context, keyLoader);
      await httpEngine!
          .get(
              url:
                  "${applicationCore!.appProfile.baseUrl!}${AppStrings.purchaseSellReportUrl}?location_id=${prefs!.getInt(AppStrings.businessLocations)}")
          .then(
        (value) {
          ReportResponseModel entity = ReportResponseModel.fromJson(value.data);
          Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
          finalReport.startBill = entity.first ?? "";
          finalReport.endBill = entity.latest ?? "";
          finalReport.totalBill = entity.totalBill.toString();
          finalReport.totalSale = entity.totalSell ?? "";
          finalReport.netSale = entity.netProfit.toString();
          finalReport.summery = mapDepSummery(entity.summery!);
          finalReport.pSummery = mapPaySummery(entity.paymentSummary!);
          result = true;
        },
      );
    } on DioException catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
    }
    return result;
  }

  List<DSummery>? mapDepSummery(List<Summery> list) {
    List<DSummery> depList = [];
    for (var item in list) {
      depList.add(DSummery(
          categoryName: item.categoryName,
          subtotal: item.subtotal,
          totalQtySold: item.totalQtySold));
    }
    return depList;
  }

  Future<void> openCashBox() async {
    return await _channel.invokeMethod('cashBox');
  }

  List<PSummery>? mapPaySummery(List<PaymentSummary> list) {
    List<PSummery> depList = [];
    for (var item in list) {
      depList.add(PSummery(method: item.method, amount: item.amount));
    }
    return depList;
  }

  Future<void> getCashDetails() async {
    prefs = spEngine!.prefs;
    super.setState(ViewState.innerInActive);
    try {
      await httpEngine!
          .get(
              url: applicationCore!.appProfile.baseUrl! +
                  AppStrings.cashDrawerDetailsUrl +
                  prefs!.getInt(AppStrings.cashId).toString())
          // "81")
          .then(
        (value) {
          CashRegisterDetailsResponseModel entity =
              CashRegisterDetailsResponseModel.fromJson(value.data);
          debugPrint(entity.toJson().toString());
          cashRegDetails = entity.registerDetails;
          cashDetails = entity.details;
          super.setState(ViewState.innerActive);
        },
      );
    } on DioException catch (e) {
      dialogueEngine!.showDialogueBox(
          msg: e.response == null ? e.message : e.response!.data['message']);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> orderUpdate(
      {postData,
      required String url,
      BuildContext? context,
      GlobalKey? keyLoader,
      bool isLoad = false}) async {
    // super.setState(ViewState.innerInActive);
    bool result = false;
    try {
      if (isLoad) {
        LoadingDialogBox().loading(context!, keyLoader);
      }
      await httpEngine!
          .post(
              url: applicationCore!.appProfile.baseUrl! + url,
              postData: postData)
          .then(
        (value) async {
          PlaceOrderResponseModel entity =
              PlaceOrderResponseModel.fromJson(value.data);
          if (isLoad) {
            Navigator.of(keyLoader!.currentContext!, rootNavigator: true).pop();
          }
          if (entity.success == 1) {
            if (entity.receipt != null && entity.receipt != "") {
              cartListModel.billNo = entity.receipt!.invoiceNo ?? "0.0";
              lastPurchase = entity.receipt!.transactionDate;
              lastPurchaseList = cartListModel.productList ?? [];
              textUpdate = "Order Completed";
            } else {
              cartListModel.billNo =
                  value.data!['transaction']['invoice_no'] ?? "0.0";
              lastPurchaseList = cartListModel.productList ?? [];
              lastPurchase =
                  value.data['transaction']['transaction_date'] ?? "";
              textUpdate = "Order Completed";
            }
            // super.setState(ViewState.innerActive);
            result = true;
          } else {
            // super.setState(ViewState.innerActive);
            dialogueEngine!.showDialogueBox(msg: entity.msg ?? "");
          }
        },
      );
    } catch (e) {
      if (isLoad) {
        Navigator.of(keyLoader!.currentContext!, rootNavigator: true).pop();
      }
      // Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
      debugPrint(e.toString());
    }
    return result;
  }
}
