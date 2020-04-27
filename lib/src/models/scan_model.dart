import 'package:latlong/latlong.dart';

class ScanModel {
  int id;
  String type;
  String value;

  ScanModel({
    this.id,
    this.type,
    this.value,
  }) {
    this.type = this.value.contains('geo:') ? 'geo' : 'web';
  }

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
      };

  LatLng getLatLong() {
    final latLog = value.substring(4).split(',');
    final lat = double.parse(latLog[0]);
    final long = double.parse(latLog[1]);

    return LatLng(lat, long);
  }
}
