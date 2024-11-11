import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BdModel {
  static Database? _db;

  static Future<Database> inicializarBD() async {
    if (_db != null) return _db!;

    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDocDir.path, 'tintoreria.db');

    _db = await databaseFactory.openDatabase(dbPath, options: OpenDatabaseOptions(
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Cliente (
            idCliente INTEGER PRIMARY KEY AUTOINCREMENT,
            nombreCliente TEXT NOT NULL,
            telefonoCliente TEXT
          )
        ''');
        
        await db.execute('''
          CREATE TABLE IF NOT EXISTS DetallesPedido (
            idDetalles INTEGER PRIMARY KEY AUTOINCREMENT,
            idNota INTEGER,
            tipoPrenda TEXT,
            colorPrenda TEXT,
            cantidad INTEGER,
            precioUnitario REAL
          )
        ''');
        
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Notas (
            idNota INTEGER PRIMARY KEY AUTOINCREMENT,
            nombreCliente TEXT NOT NULL,
            telefonoCliente TEXT NOT NULL,
            fechaRecibido TEXT NOT NULL,
            fechaEstimada TEXT NOT NULL,
            importe REAL NOT NULL,
            estadoPago REAL NOT NULL,
            prioridad TEXT NOT NULL,
            observaciones TEXT,
            estado TEXT
          )
        ''');
        
        await db.execute('''
          CREATE TABLE IF NOT EXISTS Proveedores (
            idProveedor INTEGER PRIMARY KEY AUTOINCREMENT,
            nombreProveedor TEXT NOT NULL,
            razonProveedor TEXT,
            contactoProveedor1 TEXT NOT NULL,
            contactoProveedor2 TEXT
          )
        ''');
      },
    ));
    return _db!;
  }

  // Métodos de obtención y agregar datos
  static Future<List<Map<String, dynamic>>> obtenerProveedores() async {
    final db = await inicializarBD();
    return await db.query('Proveedores');
  }

  static Future<void> agregarProveedor(Map<String, dynamic> proveedor) async {
    final db = await inicializarBD();
    await db.insert('Proveedores', proveedor);
  }

  static Future<List<Map<String, dynamic>>> obtenerClientes() async {
    final db = await inicializarBD();
    return await db.query('Cliente');
  }

  static Future<void> agregarCliente(Map<String, dynamic> cliente) async {
    final db = await inicializarBD();
    await db.insert('Cliente', cliente);
  }

  static Future<List<Map<String, dynamic>>> obtenerNotas() async {
    final db = await inicializarBD();
    return await db.query('Notas');
  }

  static Future<void> crearNota(Map<String, dynamic> notas) async {
    final db = await inicializarBD();
    await db.insert('Notas', notas);
  }

  static Future<void> cerrarBD() async {
    final db = await inicializarBD();
    await db.close();
    _db = null;
  }
}
