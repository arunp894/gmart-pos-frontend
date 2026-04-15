import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:gmart/Core/AppModel/database_tables.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseEngine {
  SharedPreferences? prefs;

  DatabaseEngine() {
    initLocalDataBase();
  }

  Future<Database> initLocalDataBase() async {
    var databasesPath = await getDatabasesPath();
    String path = "$databasesPath/pos.db";
    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        await createTables(db);
      },
    );
  }

  createTables(Database db) async {
    for (final table in DatabaseTables.allTables) {
      try {
        await db.execute(table);
        debugPrint('✅ Executed: ${table.split('(')[0]}');
      } catch (e) {
        debugPrint('❌ Error creating table: $e');
      }
    }
  }

  unitDataImport({required Sheet? sheetData}) async {
    Database db = await initLocalDataBase();
    if (sheetData != null) {
      for (int i = 1; i < sheetData.maxRows; i++) {
        final row = sheetData.row(i);
        final unit = row[1]?.value.toString() ?? '';
        final unitValue = row[2]?.value.toString() ?? '';
        if (unit != "null") {
          await db.insert(
              'units',
              {
                'unit': unit,
                'unit_value': unitValue,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': "",
              },
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }
      debugPrint('✅ Excel data inserted to database');
    }
  }

  sellingTaxDataImport({required Sheet? sheetData}) async {
    Database db = await initLocalDataBase();
    if (sheetData != null) {
      for (int i = 1; i < sheetData.maxRows; i++) {
        final row = sheetData.row(i);
        final sellingTaxName = row[1]?.value.toString() ?? '';
        if (sellingTaxName != "null") {
          await db.insert(
              'selling_tax',
              {
                'selling_tax_name': sellingTaxName,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': "",
              },
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }
      debugPrint('✅ Excel data inserted to database');
    }
  }

  productTypeDataImport({required Sheet? sheetData}) async {
    Database db = await initLocalDataBase();
    if (sheetData != null) {
      for (int i = 1; i < sheetData.maxRows; i++) {
        final row = sheetData.row(i);
        final productType = row[1]?.value.toString() ?? '';
        if (productType != "null") {
          await db.insert(
              'product_types',
              {
                'product_type': productType,
                'created_at': DateTime.now().toIso8601String(),
                'updated_at': "",
              },
              conflictAlgorithm: ConflictAlgorithm.ignore);
        }
      }
      debugPrint('✅ Excel data inserted to database');
    }
  }

  Future<List<Map<String, dynamic>>> getTableValues(
      {required String tableName}) async {
    Database db = await initLocalDataBase();
    final List<Map<String, dynamic>> result = await db.query(tableName);
    debugPrint("Total count : ${result.length}");
    return result;
  }

  Future<List<Map<String, dynamic>>> executeQuery({
    required String tableName,
    String? whereQuery,
    List<Object?>? whereArgs,
  }) async {
    Database db = await initLocalDataBase();
    final List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: whereQuery,
      // limit: 15,
      whereArgs: whereArgs,
    );
    debugPrint("Total count from $tableName: ${result.length}");
    return result;
  }

  Future<List<Map<String, dynamic>>> executeRawQuery({
    required String query,
    List<Object?>? arguments,
  }) async {
    Database db = await initLocalDataBase();
    final result = await db.rawQuery(query, arguments);
    debugPrint("Query Result Count: ${result.length}");
    return result;
  }

  /*Future<List<Map<String, dynamic>>> searchProductBySku(String keyword) async {
    final List<Map<String, dynamic>> results = await executeRawQuery(
        query: StoreProcedure.getScannedProduct(), arguments: ["%$keyword%"]);
    return results;
  }

  Future<List<Map<String, dynamic>>> searchProductByName(String keyword) async {
    final List<Map<String, dynamic>> results = await executeRawQuery(
        query: StoreProcedure.getSearchProduct(), arguments: ["%$keyword%"]);
    return results;
  }*/

  Future<String> generateBillNo(Database db) async {
    // Get today's date in yyyy-MM-dd
    final today = DateTime.now();
    final dateStr = "${today.year.toString().padLeft(4, '0')}"
        "${today.month.toString().padLeft(2, '0')}"
        "${today.day.toString().padLeft(2, '0')}";
    const prefix = 'GM';

    // Count today's orders
    final result = await db.rawQuery('''
    SELECT COUNT(*) as count FROM orders 
    WHERE DATE(created_at) = DATE(?)
  ''', [today.toIso8601String()]);

    int todayCount = Sqflite.firstIntValue(result) ?? 0;

    // Increment for current bill
    final nextNumber = todayCount + 1;
    final paddedNumber = nextNumber.toString().padLeft(4, '0');

    // Final bill number
    final billNo = '$prefix$dateStr$paddedNumber';
    return billNo;
  }

  Future<String> placeOrder(
      {required List<Map<String, dynamic>> cartItems,
      required List<Map<String, dynamic>> payments,
      required String discountPrice,
      required String discountType,
      required String totalAmount,
      required String status}) async {
    String result = '';
    Database db = await initLocalDataBase();
    try {
      final billNo = await generateBillNo(db);
      await db.insert('orders', {
        'bill_no': billNo,
        'ordered_products': jsonEncode(cartItems),
        'total_amount': totalAmount,
        'discount_type': discountType,
        'discount_amount': discountPrice,
        'payment_type': jsonEncode(payments),
        'status': status,
        'created_at': DateTime.now().toIso8601String(),
      });
      result = billNo;
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> updateQuery(
      {required String tableName,
      required Map<String, dynamic> postData,
      required int updateId}) async {
    bool result = false;
    Database db = await initLocalDataBase();
    try {
      await db.update(
        tableName,
        postData,
        where: 'id = ?',
        whereArgs: [updateId],
      );
      result = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> insertQuery(
      {required String tableName,
      required Map<String, dynamic> postData}) async {
    bool result = false;
    Database db = await initLocalDataBase();
    try {
      await db.insert(tableName, postData,
          conflictAlgorithm: ConflictAlgorithm.ignore);
      result = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> changeOrder(
      {required int orderId,
      required List<Map<String, dynamic>> cartItems,
      required List<Map<String, dynamic>> payments,
      required String discountPrice,
      required String discountType,
      required String totalAmount,
      required String status}) async {
    bool result = false;
    Database db = await initLocalDataBase();
    try {
      final orderData = {
        'ordered_products': jsonEncode(cartItems),
        'total_amount': totalAmount,
        'discount_type': discountType,
        'discount_amount': discountPrice,
        'payment_type': jsonEncode(payments),
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };
      await db.update(
        'orders',
        orderData,
        where: 'id = ?',
        whereArgs: [orderId],
      );
      result = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> updateOrder(
      {required int orderId, required Map<String, String> postData}) async {
    bool result = false;
    Database db = await initLocalDataBase();
    try {
      await db.update(
        'orders',
        postData,
        where: 'id = ?',
        whereArgs: [orderId],
      );
      result = true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return result;
  }

  Future<bool> categoryDataImport({required Sheet? sheetData,required Database db}) async {
    // Database db = await initLocalDataBase();
    const int chunkSize = 200;
    List<Map<String, dynamic>> buffer = [];
    bool result = false;
    if (sheetData == null) {
      result = false;
    }

    try {
      List<Map<String, dynamic>> categories = [];

      for (int i = 1; i < sheetData!.maxRows; i++) {
        final row = sheetData.row(i);

        final id = int.tryParse(row[0]?.value.toString() ?? '0') ?? 0;
        if (id == 0) continue;

        final category = row[1]?.value.toString() ?? '';
        if (category.isEmpty || category == "null") continue;

        final code = row[2]?.value.toString() ?? '';
        final parent = int.tryParse(row[3]?.value.toString() ?? '0') ?? 0;
        final business = int.tryParse(row[4]?.value.toString() ?? '0') ?? 0;
        final ageLimit = row[5]?.value?.toString();
        final ageDes = row[6]?.value?.toString();
        final fromTime = row[7]?.value?.toString();
        final toTime = row[8]?.value?.toString();
        final timeDes = row[9]?.value?.toString();

        categories.add({
          'category_id': id,
          'category': category,
          'code': code,
          'parent_id': parent,
          'business_id': business,
          'age_limit': ageLimit,
          'age_description': ageDes,
          'from_time': fromTime,
          'to_time': toTime,
          'time_description': timeDes
        });
        // 🔥 When buffer is full → UPSERT
        if (buffer.length == chunkSize) {
          await _upsertCategoryChunk(buffer, db);
          buffer.clear();

          // 🧠 Allow UI to repaint
          await Future.delayed(Duration(milliseconds: 1));
        }
      }

      // 🔥 UPSERT
      /*await db.transaction((txn) async {
        final batch = txn.batch();

        for (var row in categories) {
          // INSERT (ignore if exists)
          batch.insert(
            'categories',
            {
              ...row,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': "",
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );

          // UPDATE (if exists)
          batch.update(
            'categories',
            {
              ...row,
              'updated_at': DateTime.now().toIso8601String(),
            },
            where: 'category_id = ?',
            whereArgs: [row['category_id']],
          );
        }

        await batch.commit(noResult: true);
      });*/
      // 🔥 Insert remaining rows
      if (buffer.isNotEmpty) {
        await _upsertCategoryChunk(buffer, db);
      }
      result = true;
      debugPrint("✅ Category upsert completed");
    } catch (e) {
      debugPrint("❌ Category import error: $e");
      throw Exception(e.toString());
    }
    return result;
  }

  Future<void> _upsertCategoryChunk(
      List<Map<String, dynamic>> rows,
      Database db,
      ) async {
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final row in rows) {
        // INSERT (ignore)
        batch.insert(
          'categories',
          {
            ...row,
            'created_at': now,
            'updated_at': "",
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        // UPDATE (existing)
        batch.update(
          'categories',
          {
            ...row,
            'updated_at': now,
          },
          where: 'category_id = ?',
          whereArgs: [row['category_id']],
        );
      }

      await batch.commit(noResult: true);
    });
  }


  Future<bool> variantDataImport({required Sheet? sheetData,required Database db}) async {
    bool result = false;
    // Database db = await initLocalDataBase();
    try {
      if (sheetData == null) {
        result = false;
      }
      const int chunkSize = 200;
      List<Map<String, dynamic>> buffer = [];
      List<Map<String, dynamic>> variations = [];

      // Prepare data from Excel
      for (int i = 1; i < sheetData!.maxRows; i++) {
        final row = sheetData.row(i);

        final id = int.tryParse(row[0]?.value.toString() ?? '0') ?? 0;
        final name = row[1]?.value.toString() ?? '';
        final productId = int.tryParse(row[2]?.value.toString() ?? '1') ?? 1;
        final barcode = row[3]?.value.toString() ?? '';
        final defaultPrice =
            double.tryParse(row[4]?.value.toString() ?? '0') ?? 0;
        final sellingPrice =
            double.tryParse(row[5]?.value.toString() ?? '0') ?? 0;
        final unit = row[6]?.value.toString() ?? '';
        final variantId = int.tryParse(row[7]?.value.toString() ?? '0') ?? 0;
        final locationId = int.tryParse(row[8]?.value.toString() ?? '1') ?? 1;

        if (name.isEmpty || name == "null") continue;

        variations.add({
          'variation_double_id': id,
          'name': name,
          'product_id': productId,
          'barcode': barcode,
          'default_selling_price': defaultPrice.toStringAsFixed(2),
          'selling_price_inc_tax': sellingPrice.toStringAsFixed(2),
          'unit': unit,
          'variation_id': variantId,
          'location_id': locationId,
        });
        // 🔥 Commit chunk
        if (buffer.length == chunkSize) {
          await _upsertVariantChunk(buffer, db);
          buffer.clear();

          // 🧠 Yield to UI thread
          await Future.delayed(Duration(milliseconds: 1));
        }
      }

      // Insert/Update in a single transaction + batch
      /*await db.transaction((txn) async {
        final batch = txn.batch();

        for (var row in variations) {
          // INSERT (ignore if exists)
          batch.insert(
            'variations',
            {
              ...row,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': "",
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );

          // UPDATE if exists
          batch.update(
            'variations',
            {
              ...row,
              'updated_at': DateTime.now().toIso8601String(),
            },
            where: 'variation_double_id = ?',
            whereArgs: [row['variation_double_id']],
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        await batch.commit(noResult: true);
      });*/
      // 🔥 Insert remaining rows
      if (buffer.isNotEmpty) {
        await _upsertVariantChunk(buffer, db);
      }
      result = true;
      debugPrint('✅ Variant insert/update completed');
    } catch (e, stack) {
      debugPrint('❌ variantDataImport error: $e');
      debugPrint(stack.toString());
      throw Exception('Variant import failed: $e');
    }
    return result;
  }

  Future<void> _upsertVariantChunk(
      List<Map<String, dynamic>> rows,
      Database db,
      ) async {
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final row in rows) {
        // INSERT (ignore)
        batch.insert(
          'variations',
          {
            ...row,
            'created_at': now,
            'updated_at': "",
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        // UPDATE (existing)
        batch.update(
          'variations',
          {
            ...row,
            'updated_at': now,
          },
          where: 'variation_double_id = ?',
          whereArgs: [row['variation_double_id']],
        );
      }

      await batch.commit(noResult: true);
    });
  }


  Future<bool> productDataImport({required Sheet? sheetData,required Database db}) async {
    bool result = false;
    // Database db = await initLocalDataBase();
    if (sheetData == null) {
      result = false;
    }

    try {
      const int chunkSize = 200;
      List<Map<String, dynamic>> buffer = [];
      List<Map<String, dynamic>> products = [];

      // READ EXCEL ROWS
      for (int i = 1; i < sheetData!.maxRows; i++) {
        final row = sheetData.row(i);

        final productId = int.tryParse(row[0]?.value.toString() ?? '0') ?? 0;
        if (productId == 0) continue;

        final name = row[1]?.value.toString() ?? '';
        if (name.isEmpty || name == "null") continue;

        final variationId = int.tryParse(row[2]?.value.toString() ?? '0') ?? 0;
        if (variationId == 0) continue; // because variation_id is UNIQUE

        final businessId = int.tryParse(row[3]?.value.toString() ?? '0') ?? 0;
        final type = row[4]?.value.toString() ?? '';
        final unit = row[5]?.value.toString() ?? '';
        final categoryId = int.tryParse(row[6]?.value.toString() ?? '0') ?? 0;
        final posEdit = int.tryParse(row[7]?.value.toString() ?? '0') ?? 0;
        final barcode = row[8]?.value.toString() ?? '';
        final locationId = int.tryParse(row[9]?.value.toString() ?? '1') ?? 1;

        final defaultPrice =
            double.tryParse(row[10]?.value.toString() ?? '0') ?? 0;
        final sellingPrice =
            double.tryParse(row[11]?.value.toString() ?? '0') ?? 0;

        products.add({
          'product_id': productId,
          'name': name,
          'variation_id': variationId, // UNIQUE KEY
          'business_id': businessId,
          'type': type,
          'unit': unit,
          'category_id': categoryId,
          'pos_edit': posEdit,
          'barcode': barcode,
          'location_id': locationId,
          'default_selling_price': defaultPrice.toStringAsFixed(2),
          'selling_price_inc_tax': sellingPrice.toStringAsFixed(2),
        });
        // 🔥 Commit chunk
        if (buffer.length == chunkSize) {
          await _upsertProductChunk(buffer, db);
          buffer.clear();

          // 🧠 Let UI breathe
          await Future.delayed(Duration(milliseconds: 1));
        }
      }

      // UPSERT USING variation_id
      /*await db.transaction((txn) async {
        final batch = txn.batch();

        for (var row in products) {
          batch.insert(
            'products',
            {
              ...row,
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            },
            conflictAlgorithm: ConflictAlgorithm.replace, // REAL UPSERT
          );
        }

        await batch.commit(noResult: true);
      });*/
      // 🔥 Insert remaining rows
      if (buffer.isNotEmpty) {
        await _upsertProductChunk(buffer, db);
      }
      result = true;
      debugPrint('✅ Product import (UPSERT) completed successfully');
    } catch (e) {
      debugPrint("❌ Import error: $e");
      throw Exception(e.toString());
    }
    return result;
  }
  Future<void> _upsertProductChunk(
      List<Map<String, dynamic>> rows,
      Database db,
      ) async {
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      final batch = txn.batch();

      for (final row in rows) {
        batch.insert(
          'products',
          {
            ...row,
            'created_at': now,
            'updated_at': now,
          },
          conflictAlgorithm: ConflictAlgorithm.replace, // TRUE UPSERT
        );
      }

      await batch.commit(noResult: true);
    });
  }

}
