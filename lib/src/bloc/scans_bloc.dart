import 'dart:async';

import 'package:qrscanner/src/bloc/validators.dart';
import 'package:qrscanner/src/providers/db_provider.dart';

class ScansBlock with Validators {
  static final ScansBlock _singleton = new ScansBlock._internal();

  factory ScansBlock() {
    return _singleton;
  }

  ScansBlock._internal() {
    obtenerScans();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get scansStream =>
      _scansController.stream.transform(validarGeo);
  Stream<List<ScanModel>> get scansStreamWeb =>
      _scansController.stream.transform(validarWeb);

  dispose() {
    _scansController?.close();
  }

  obtenerScans() async {
    _scansController.sink.add(await DBProvider.db.getAllScans());
  }

  agregarScan(ScanModel scan) async {
    await DBProvider.db.nuevoScan(scan);
    obtenerScans();
  }

  borrarScan(int id) async {
    await DBProvider.db.deleteScan(id);
    obtenerScans();
  }

  borrarScanType(String type) async {
    await DBProvider.db.deleteScanType(type);
    obtenerScans();
  }

  borrarTodosScans() async {
    await DBProvider.db.deleteAll();
    obtenerScans();
  }
}
