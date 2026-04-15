import 'dart:isolate';
import 'dart:io';
import 'package:excel/excel.dart';

/// 🔥 Generic isolate to read any sheet row-by-row
@pragma('vm:entry-point')
void excelSheetIsolate(SendPort mainSendPort) async {
  final isolateReceivePort = ReceivePort();
  mainSendPort.send(isolateReceivePort.sendPort);

  await for (final message in isolateReceivePort) {
    final String filePath = message['filePath'];
    final String sheetName = message['sheetName'];
    final int chunkSize = message['chunkSize'];

    final bytes = await File(filePath).readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    final Sheet? sheet = excel.tables[sheetName];

    if (sheet == null) {
      mainSendPort.send('DONE');
      continue;
    }

    List<List<dynamic>> buffer = [];

    for (int i = 1; i < sheet.maxRows; i++) {
      final row = sheet.row(i);
      buffer.add(row.map((e) => e?.value).toList());

      if (buffer.length == chunkSize) {
        mainSendPort.send(buffer);
        buffer = [];
      }
    }

    if (buffer.isNotEmpty) {
      mainSendPort.send(buffer);
    }

    mainSendPort.send('DONE');
  }
}
