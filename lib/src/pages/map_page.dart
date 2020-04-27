import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrscanner/src/models/scan_model.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final map = new MapController();

  String tipoMapa = 'dark';

  @override
  Widget build(BuildContext context) {
    final ScanModel scan = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(title: Text('Coordenadas QR'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.my_location),
          onPressed: () => map.move(scan.getLatLong(), 17),
        )
      ]),
      body: _crearMap(scan),
      floatingActionButton: _crearFloatingButton(context),
    );
  }

  Widget _crearMap(ScanModel scan) {
    return FlutterMap(
      mapController: map,
      options: MapOptions(center: scan.getLatLong(), zoom: 17),
      layers: [_crearMapa(), _crearMarcadores(scan)],
    );
  }

  _crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/v4/'
            '{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1IjoiZnJhbmMzNjMiLCJhIjoiY2s5aG9xM2c3MTEwbjNrbzJjc2Q4NWNkaiJ9.SWrLvn9BrQu988VMBiPaDg',
          'id': 'mapbox.$tipoMapa'
        });
  }

  _crearMarcadores(ScanModel scan) {
    return MarkerLayerOptions(markers: <Marker>[
      Marker(
          width: 100,
          height: 100,
          point: scan.getLatLong(),
          builder: (context) => Container(
              child: Icon(Icons.location_on,
                  size: 50, color: Theme.of(context).textSelectionColor)))
    ]);
  }

  Widget _crearFloatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          switch (tipoMapa) {
            case 'streets':
              tipoMapa = 'dark';
              break;
            case 'dark':
              tipoMapa = 'light';
              break;
            case 'light':
              tipoMapa = 'outdoors';
              break;
            case 'outdoors':
              tipoMapa = 'satellite';
              break;
            case 'satellite':
              tipoMapa = 'streets';
              break;
            default:
              tipoMapa = 'dark';
          }
        });
      },
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).textSelectionColor,
    );
  }
}
