import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class BdModel {
  static Future<Database> inicializarBD() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var dbPath = await databaseFactory.getDatabasesPath();
    var path = join(dbPath, 'tintoreria.db');

    // Abre la base de datos
    var db = await databaseFactory.openDatabase(path);

    // Crea las tablas si no existen
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

    final proveedoresExistentes = await db.query('Proveedores');
    if (proveedoresExistentes.isEmpty) {
      await db.insert('Proveedores', {
        'nombreProveedor': 'Proveedor ABC',
        'razonProveedor': 'Textiles SA',
        'contactoProveedor1': 'contacto1@proveedor.com',
        'contactoProveedor2': 'contacto2@proveedor.com',
      });
    }

    return db;
  }

// static Future<void> borrarDatosProveedores() async {
//   final db = await inicializarBD();
//   await db.delete('Proveedores');
//   await db.execute('DELETE FROM sqlite_sequence WHERE name="Proveedores"');
//   await db.close();
// }


  // Método para obtener todos los proveedores
  static Future<List<Map<String, dynamic>>> obtenerProveedores() async {
    final db = await inicializarBD();
    final List<Map<String, dynamic>> proveedores = await db.query('Proveedores');
    await db.close();
    return proveedores;
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
}
