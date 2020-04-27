import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'package:qrscanner/src/models/scan_model.dart';
export 'package:qrscanner/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get dataBase async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Scans('
          'id INTEGER PRIMARY KEY,'
          'type TEXT,'
          'value TEXT'
          ')');
    });
  }

  nuevoScanRaw(ScanModel nuevoScan) async {
    final db = await dataBase;

    final res = await db.rawInsert("INSERT INTO Scans (id, type, value) "
        "VALUES (${nuevoScan.id}, '${nuevoScan.type}', '${nuevoScan.value}')");

    return res;
  }

  nuevoScan(ScanModel nuevoScan) async {
    final db = await dataBase;

    final res = await db.insert('Scans', nuevoScan.toJson());

    return res;
  }

  Future<ScanModel> getScanId(int id) async {
    final db = await dataBase;

    final res = await db.query('Scans', where: 'id = ?', whereArgs: [id]);
    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await dataBase;

    final res = await db.query('Scans');
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<ScanModel>> getAllScansByType(String type) async {
    final db = await dataBase;

    final res = await db.query('Scans', where: 'type=?', whereArgs: [type]);
    List<ScanModel> list =
        res.isNotEmpty ? res.map((c) => ScanModel.fromJson(c)).toList() : [];
    return list;
  }

  Future<int> updateScans(ScanModel nuevoScan) async {
    final db = await dataBase;

    final res = await db.update('Scans', nuevoScan.toJson(),
        where: 'id=?', whereArgs: [nuevoScan.id]);

    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await dataBase;

    final res = await db.delete('Scans', where: 'id=?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteScanType(String type) async {
    final db = await dataBase;

    final res = await db.delete('Scans', where: 'type=?', whereArgs: [type]);
    return res;
  }

  Future<int> deleteAll() async {
    final db = await dataBase;

    final res = await db.delete('Scans');
    return res;
  }
}
