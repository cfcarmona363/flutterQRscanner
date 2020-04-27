import 'package:flutter/material.dart';
import 'package:qrscanner/src/bloc/scans_bloc.dart';
import 'package:qrscanner/src/models/scan_model.dart';
import 'package:qrscanner/src/utils/utils.dart';

class MapsPage extends StatelessWidget {
  final scansBlock = ScansBlock();

  @override
  Widget build(BuildContext context) {
    scansBlock.obtenerScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scansBlock.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> scans) {
        if (!scans.hasData) return Center(child: CircularProgressIndicator());
        return scans.data.length == 0
            ? Center(child: Text('There are no saved maps.'))
            : ListView.builder(
                itemCount: scans.data.length,
                itemBuilder: (context, i) => Dismissible(
                      key: UniqueKey(),
                      background: Container(color: Colors.red),
                      onDismissed: (direction) =>
                          scansBlock.borrarScan(scans.data[i].id),
                      child: ListTile(
                        onTap: () => openScan(context, scans.data[i]),
                        leading: Icon(
                          Icons.location_on,
                          color: Theme.of(context).textSelectionColor,
                          size: 25,
                        ),
                        title: Text(scans.data[i].value),
                        subtitle: Text(
                            '${scans.data[i].id.toString()} - ${scans.data[i].type.toString()}'),
                        trailing: Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey,
                        ),
                      ),
                    ));
      },
    );
  }
}
