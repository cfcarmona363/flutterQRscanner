import 'dart:async';

import 'package:qrscanner/src/models/scan_model.dart';

class Validators {
  final validarGeo =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
          handleData: (scans, sink) {
    final geoScans = scans.where((s) => s.type == 'geo').toList();
    sink.add(geoScans);
  });
  final validarWeb =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
          handleData: (scans, sink) {
    final webScans = scans.where((s) => s.type == 'web').toList();
    sink.add(webScans);
  });
}
