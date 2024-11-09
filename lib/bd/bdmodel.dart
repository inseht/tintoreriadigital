import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class BdModel {
  static Future<Database> inicializarBD() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var dbPath = await databaseFactory.getDatabasesPath();
    var path = join(dbPath, 'tintoreria.db');

    var db = await databaseFactory.openDatabase(path);

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Cliente (
        idCliente INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        nombreCliente TEXT NOT NULL,
        telefonoCliente TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS DetallesPedido (
        idDetalles INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        idNota INTEGER,
        tipoPrenda TEXT,
        cantidad INTEGER,
        precioUnitario FLOAT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Notas (
        idNota INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        nombreCliente TEXT NOT NULL,
        telefonoCliente TEXT NOT NULL,
        fechaRecibido DATE NOT NULL,
        fechaEstimada DATE NOT NULL,
        importe FLOAT NOT NULL,
        estadoPago FLOAT NOT NULL,
        prioridad TEXT NOT NULL,
        observaciones TEXT,
        estado TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS Proveedores (
        idProveedor INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        nombreProveedor TEXT NOT NULL,
        razonProveedor TEXT,
        contactoProveedor1 TEXT NOT NULL,
        contactoProveedor2 TEXT
      )
    ''');


      await db.insert('Proveedores', {
    'nombreProveedor': 'Proveedor ABC',
    'razonProveedor': 'Textiles SA',
    'contactoProveedor1': 'contacto1@proveedor.com',
    'contactoProveedor2': 'contacto2@proveedor.com',
  });

    return db;
  }

  // Método para obtener todos los proveedores
  static Future<List<Map<String, dynamic>>> obtenerProveedores() async {
    final db = await inicializarBD();
    final List<Map<String, dynamic>> proveedores = await db.query('Proveedores');
    await db.close();
    return proveedores;
  }

  // Método para agregar un proveedor
  static Future<void> agregarProveedor(Map<String, dynamic> proveedor) async {
    final db = await inicializarBD();
    await db.insert('Proveedores', proveedor);
    await db.close();
  }

  // Método para obtener todos los clientes (por ejemplo)
  static Future<List<Map<String, dynamic>>> obtenerClientes() async {
    final db = await inicializarBD();
    final List<Map<String, dynamic>> clientes = await db.query('Cliente');
    await db.close();
    return clientes;
  }

  // Método para agregar un cliente (por ejemplo)
  static Future<void> agregarCliente(Map<String, dynamic> cliente) async {
    final db = await inicializarBD();
    await db.insert('Cliente', cliente);
    await db.close();
  }
}
