import 'package:flutter/material.dart';
import 'package:qrscanner/src/bloc/scans_bloc.dart';
import 'package:qrscanner/src/models/scan_model.dart';
import 'package:qrscanner/src/pages/directions_page.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrscanner/src/utils/utils.dart';

import 'maps_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBlock = new ScansBlock();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete_forever,
              color: Colors.white,
            ),
            onPressed: () =>
                scansBlock.borrarScanType(currentIndex == 0 ? 'geo' : 'web'),
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: _bottomNavitationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).textSelectionColor,
      ),
    );
  }

  Widget _bottomNavitationBar() {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Maps')),
          BottomNavigationBarItem(
              icon: Icon(Icons.brightness_5), title: Text('Directions')),
        ]);
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapsPage();
      case 1:
        return DirectionsPage();
      default:
        return MapsPage();
    }
  }

  _scanQR(BuildContext context) async {
    String data = '';
    ScanResult result;
    try {
      result = await BarcodeScanner.scan();
      data = result.rawContent;
    } catch (e) {
      print(e.toString());
    }

    if (data.length > 0) {
      final scan = ScanModel(value: data);
      scansBlock.agregarScan(scan);
      openScan(context, scan);
    }
  }
}
