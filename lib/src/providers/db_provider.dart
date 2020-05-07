import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
export 'package:qrreaderapp/src/models/scan_model.dart';

class DBProvider {
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Scans ('
          ' id INTEGER PRIMARY KEY,'
          ' tipo TEXT,'
          ' valor TEXT'
          ')'
        );
      }
    );
  }

  //Metodos para CREAR registros
  nuevoScanRaw(ScanModel nuevoScan) async {

    final db = await database;
    final result = await db.rawInsert(
      "INSERT Into Scans (id, tipo, valor) "
      "VALUES (${nuevoScan.id},'${nuevoScan.tipo}','${nuevoScan.valor}')"
    );
    return result;
  }

  nuevoScan( ScanModel nuevoScan) async{
    final db = await database;
    final result = await db.insert('Scans', nuevoScan.toJson());
    return result;
  }

  // Metodos para obtener info SELECT
  Future<ScanModel> getScanId(int id) async {
    final db = await database;
    final result = await db.query('Scans',where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? ScanModel.fromJson(result.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async {
    final db = await database;
    final result = await db.query('Scans');
    
    List<ScanModel> list = result.isNotEmpty 
                                  ? result.map((scan) => ScanModel.fromJson(scan)).toList()
                                  :[];
    return list;
  }

  Future<List<ScanModel>> getAllScansByType(String tipo) async {
    final db = await database;
    final result = await db.rawQuery("SELECT * FROM Scans WHERE tipo = '$tipo'");
    
    List<ScanModel> list = result.isNotEmpty 
                                  ? result.map((scan) => ScanModel.fromJson(scan)).toList()
                                  :[];
    return list;
  }

  //Actualizar registros
  Future<int> updateScan(ScanModel nuevoScan) async{
    final db = await database;
    final result = await db.update('Scans', nuevoScan.toJson(), where: 'id = ?', whereArgs: [nuevoScan.id]);
    return result;
  }

  //Borrar registros
  Future<int> deleteScan(int id) async{
    final db = await database;
    final result = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return result;
  }
  Future<int> deleteAll() async{
    final db = await database;
    final result = await db.rawDelete('DELETE FROM Scans');
    return result;
  }
  
}
