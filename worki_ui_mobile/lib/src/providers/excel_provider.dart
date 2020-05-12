import 'dart:io';
import 'package:path/path.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:worki_ui/src/models/worker_model.dart';

class ExcelProvider {
  
  Future<OpenResult> generateExcel(List<Worker> workers) async{
    var decoder = Excel.createExcel();
    for (var table in decoder.tables.keys) {
      print(table);
      print(decoder.tables[table].maxCols);
      print(decoder.tables[table].maxRows);
      for (var row in decoder.tables[table].rows) {
        print("$row");
      }
    }

    var sheet = 'Sheet1';

    decoder
    ..updateCell(sheet, CellIndex.indexByString("A1"), "Nombre", verticalAlign: VerticalAlign.Middle,horizontalAlign: HorizontalAlign.Center)
    ..updateCell(sheet, CellIndex.indexByString("B1"), "Documento", verticalAlign: VerticalAlign.Middle,horizontalAlign: HorizontalAlign.Center)
    ..updateCell(sheet, CellIndex.indexByString("C1"), "Telefono", verticalAlign: VerticalAlign.Middle,horizontalAlign: HorizontalAlign.Center)
    ..updateCell(sheet, CellIndex.indexByString("D1"), "Trabajo", verticalAlign: VerticalAlign.Middle,horizontalAlign: HorizontalAlign.Center)
    ..updateCell(sheet, CellIndex.indexByString("E1"), "Pago", verticalAlign: VerticalAlign.Middle,horizontalAlign: HorizontalAlign.Center);
    int rowIndex = 1;
    double total = 0;
    for(Worker w in workers){
      decoder.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 0,rowIndex: rowIndex), w.name);
      decoder.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 1,rowIndex: rowIndex), w.cardId);
      decoder.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 2,rowIndex: rowIndex), w.phone.toString());
      decoder.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 3,rowIndex: rowIndex), w.getReportJobs());
      decoder.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 4,rowIndex: rowIndex), w.reportSalary.toInt().toString());
      total+=w.reportSalary;

      rowIndex++;
    }
    decoder.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 3,rowIndex: rowIndex), "TOTAL");
    decoder.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 4,rowIndex: rowIndex), total.toInt().toString());
    final path = await _localPath;
    // Save the file
    print('SAVING');
    print(path);
    decoder.encode().then((onValue) {
      File(join("$path/excel.xlsx"))
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
    });

    print('OPNENING');
    return await openFile('$path/excel.xlsx');
  }

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
  
    return directory.path;
  }

  
  Future<OpenResult> openFile(String path) async {
    String _openResult = 'Unknown';
    print('OPEN'+path);
    final filePath = path;
    final result = await OpenFile.open(filePath);
    return result;
  }

}