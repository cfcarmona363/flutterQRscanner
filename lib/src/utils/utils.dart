import 'package:flutter/material.dart';

import 'package:qrscanner/src/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

openScan(BuildContext context, ScanModel scan) async {
  if (scan.type == 'web') {
    if (await canLaunch(scan.value)) {
      await launch(scan.value);
    } else {
      AlertDialog();
    }
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}
