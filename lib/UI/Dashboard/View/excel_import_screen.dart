import 'dart:isolate';
import 'package:gmart/Constant/app_strings.dart';
import 'package:gmart/Core/Engine/database_engine.dart';
import 'package:gmart/Core/application_base.dart';
import 'package:gmart/UI/Dashboard/ViewModel/excel_isolate_services.dart';
import 'package:sqflite/sqflite.dart';

class ExcelImportScreen extends StatefulWidget {
  const ExcelImportScreen({super.key});

  @override
  State<ExcelImportScreen> createState() => _ExcelImportScreenState();
}

class _ExcelImportScreenState extends State<ExcelImportScreen> {
  SharedPreferences? prefs;
  final ValueNotifier<String> loadingText =
      ValueNotifier<String>('Preparing import...');

  final ValueNotifier<double> progress =
      ValueNotifier<double>(0.0); // 0.0 → 1.0
  String updateText = "Please wait\nData is importing to local";

  @override
  void initState() {
    super.initState();
    startPage(); // ✅ NO TIMER
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (_, value, __) {
                return SizedBox(
                  height: 80,
                  width: 80,
                  child: CircularProgressIndicator(
                    value: value == 0 ? null : value, // indeterminate at start
                    strokeWidth: 6,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<String>(
              valueListenable: loadingText,
              builder: (_, value, __) {
                return Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                );
              },
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<double>(
              valueListenable: progress,
              builder: (_, value, __) {
                return Text(
                  '${(value * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 14),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> startPage() async {
    prefs = spEngine!.prefs;
    await Future.delayed(const Duration(seconds: 2));
    final bool isUpdate = prefs!.getBool(AppStrings.isUpdate) ?? false;

    if (isUpdate) {
      _goDashboard();
      return;
    }

    final bool success = await initLocalData();

    if (!mounted) return;

    if (success) {
      setState(() {
        updateText = "Your data is imported to local";
      });

      await prefs!.setBool(AppStrings.isUpdate, true);

      _goDashboard();
    }
  }

  Future<bool> initLocalData() async {
    final prefs = spEngine!.prefs;
    final filePath = prefs!.getString(AppStrings.excelPath);

    if (filePath == null || filePath.isEmpty) {
      return false;
    }
    Database database = await DatabaseEngine().initLocalDataBase();
    // 🔥 HEAVY WORK IN BACKGROUND ISOLATE
    return await importAllSheets(excelPath: filePath, db: database);
  }

  void _goDashboard() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      "/Dashboard",
      (route) => false,
    );
  }

  /// 🔥 PUBLIC METHOD (CALL THIS)
  Future<bool> importAllSheets({
    required String excelPath,
    required Database db,
  }) async {
    // 🟦 CATEGORY (20%)
    loadingText.value = '⏳ Importing Categories...';
    final categoryOk = await _runSheetImport(
      excelPath: excelPath,
      sheetName: 'Worksheet',
      db: db,
      mapper: categoryMapper,
      tableName: 'categories',
      start: 0.0,
      end: 0.2,
    );
    if (!categoryOk) return false;
    // 🟩 PRODUCT (50%)
    loadingText.value = '⏳ Importing Products...';
    final productOk = await _runSheetImport(
      excelPath: excelPath,
      sheetName: 'Worksheet 1',
      db: db,
      mapper: productMapper,
      tableName: 'products',
      start: 0.2,
      end: 0.7,
    );
    if (!productOk) return false;
    // 🟨 VARIATION (30%)
    loadingText.value = '⏳ Importing Variations...';
    final variantOk = await _runSheetImport(
      excelPath: excelPath,
      sheetName: 'Worksheet 2',
      db: db,
      mapper: variantMapper,
      tableName: 'variations',
      start: 0.7,
      end: 1.0,
    );
    if (!variantOk) return false;
    debugPrint('✅ ALL SHEETS IMPORTED SUCCESSFULLY');
    loadingText.value = '✅ Import completed';
    progress.value = 1.0;
    return true;
  }

  Future<bool> _runSheetImport({
    required String excelPath,
    required String sheetName,
    required Database db,
    required Map<String, dynamic>? Function(List<dynamic>) mapper,
    required String tableName,
    required double start,
    required double end,
  }) async {
    debugPrint('⏳ Importing $sheetName...');

    final receivePort = ReceivePort();
    final completer = Completer<bool>();
    int processedChunks = 0;
    const int estimatedChunks = 30; // smooth animation

    await Isolate.spawn(
      excelSheetIsolate,
      receivePort.sendPort,
    );

    SendPort? isolateSendPort;

    receivePort.listen((message) async {
      try {
        // 🔁 HANDSHAKE
        if (message is SendPort) {
          isolateSendPort = message;
          isolateSendPort!.send({
            'filePath': excelPath,
            'sheetName': sheetName,
            'chunkSize': 200,
          });
          return;
        }

        // 📦 DATA CHUNK
        if (message is List<List<dynamic>>) {
          final rows =
              message.map(mapper).whereType<Map<String, dynamic>>().toList();

          if (rows.isNotEmpty) {
            await _batchInsert(rows, db, tableName);
          }
          processedChunks++;

          final sheetProgress =
              processedChunks / estimatedChunks;

          progress.value =
              start + ((end - start) * sheetProgress.clamp(0, 1));
          return;
        }

        // ✅ DONE
        if (message == 'DONE') {
          progress.value = end;
          receivePort.close();
          completer.complete(true);
        }
      } catch (e) {
        debugPrint('❌ $sheetName failed: $e');
        receivePort.close();
        completer.complete(false);
      }
    });

    return completer.future;
  }

  Future<void> _batchInsert(
    List<Map<String, dynamic>> rows,
    Database db,
    String tableName,
  ) async {
    final now = DateTime.now().toIso8601String();
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final row in rows) {
        batch.insert(
          tableName,
          {
            ...row,
            'created_at': now,
            'updated_at': now,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      await batch.commit(noResult: true);
    });
  }

  Map<String, dynamic>? categoryMapper(List<dynamic> r) {
    final id = int.tryParse('${r[0] ?? 0}') ?? 0;
    // if (id == 0) return null;
    final category = '${r[1] ?? ''}'.trim();
    if (category.isEmpty || category == 'null') return null;

    final code = '${r[2] ?? ''}';
    final parent = int.tryParse('${r[3] ?? 0}') ?? 0;
    final business = int.tryParse('${r[4] ?? 0}') ?? 0;

    final ageLimit = r[5]?.toString();
    final ageDes = r[6]?.toString();
    final fromTime = r[7]?.toString();
    final toTime = r[8]?.toString();
    final timeDes = r[9]?.toString();

    return {
      'category_id': id,
      'category': category,
      'code': code,
      'parent_id': parent,
      'business_id': business,
      'age_limit': ageLimit,
      'age_description': ageDes,
      'from_time': fromTime,
      'to_time': toTime,
      'time_description': timeDes,
    };
  }

  Map<String, dynamic>? productMapper(List<dynamic> r) {
    final productId = int.tryParse('${r[0] ?? 0}') ?? 0;
    // if (productId == 0) return null;

    final name = '${r[1] ?? ''}'.trim();
    if (name.isEmpty || name == 'null') return null;

    final variationId = int.tryParse('${r[2] ?? 0}') ?? 0;
    if (variationId == 0) return null; // UNIQUE

    final businessId = int.tryParse('${r[3] ?? 0}') ?? 0;
    final type = '${r[4] ?? ''}';
    final unit = '${r[5] ?? ''}';
    final categoryId = int.tryParse('${r[6] ?? 0}') ?? 0;
    final posEdit = int.tryParse('${r[7] ?? 0}') ?? 0;
    final barcode = '${r[8] ?? ''}';
    final locationId = int.tryParse('${r[9] ?? 1}') ?? 1;

    final defaultPrice = double.tryParse('${r[10] ?? 0}') ?? 0;
    final sellingPrice = double.tryParse('${r[11] ?? 0}') ?? 0;

    return {
      'product_id': productId,
      'name': name,
      'variation_id': variationId,
      'business_id': businessId,
      'type': type,
      'unit': unit,
      'category_id': categoryId,
      'pos_edit': posEdit,
      'barcode': barcode,
      'location_id': locationId,
      'default_selling_price': defaultPrice.toStringAsFixed(2),
      'selling_price_inc_tax': sellingPrice.toStringAsFixed(2),
    };
  }

  Map<String, dynamic>? variantMapper(List<dynamic> r) {
    final id = int.tryParse('${r[0] ?? 0}') ?? 0;
    if (id == 0) return null;

    final name = '${r[1] ?? ''}'.trim();
    if (name.isEmpty || name == 'null') return null;

    final productId = int.tryParse('${r[2] ?? 1}') ?? 1;
    if (productId == 0) return null;

    final barcode = '${r[3] ?? ''}';

    final defaultPrice = double.tryParse('${r[4] ?? 0}') ?? 0;

    final sellingPrice = double.tryParse('${r[5] ?? 0}') ?? 0;

    final unit = '${r[6] ?? ''}';

    final variantId = int.tryParse('${r[7] ?? 0}') ?? 0;
    if (variantId == 0) return null;

    final locationId = int.tryParse('${r[8] ?? 1}') ?? 1;

    return {
      'variation_double_id': id,
      'name': name,
      'product_id': productId,
      'barcode': barcode,
      'default_selling_price': defaultPrice.toStringAsFixed(2),
      'selling_price_inc_tax': sellingPrice.toStringAsFixed(2),
      'unit': unit,
      'variation_id': variantId,
      'location_id': locationId,
    };
  }
}
