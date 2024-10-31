import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'tintoreria.db');

    return await openDatabase(
      path,
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
            cantidad INTEGER,
            precioUnitario FLOAT,
            FOREIGN KEY (idNota) REFERENCES Notas (idNota)
          )
        ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS Notas (
            idNota INTEGER PRIMARY KEY AUTOINCREMENT,
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
            idProveedor INTEGER PRIMARY KEY AUTOINCREMENT,
            nombreProveedor TEXT NOT NULL,
            razonProveedor TEXT,
            contactoProveedor1 TEXT NOT NULL,
            contactoProveedor2 TEXT
          )
        ''');

        await _migrateClientTable(db);
        await _migrateDetallesPedidoTable(db);
      },
    );
  }

  Future<void> _migrateClientTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Cliente_temp (
        idCliente INTEGER PRIMARY KEY AUTOINCREMENT,
        nombreCliente TEXT NOT NULL,
        telefonoCliente TEXT,
        FOREIGN KEY (nombreCliente) REFERENCES Notas (nombreCliente),
        FOREIGN KEY (telefonoCliente) REFERENCES Notas (telefonoCliente)
      )
    ''');

    await db.execute('''
      INSERT INTO Cliente_temp (idCliente, nombreCliente, telefonoCliente)
      SELECT idCliente, nombreCliente, telefonoCliente FROM Cliente
    ''');

    await db.execute('DROP TABLE Cliente');
    await db.execute('ALTER TABLE Cliente_temp RENAME TO Cliente');
  }

  Future<void> _migrateDetallesPedidoTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS DetallesPedido_temp (
        idDetalles INTEGER PRIMARY KEY AUTOINCREMENT,
        idNota INTEGER,
        tipoPrenda TEXT,
        cantidad INTEGER,
        precioUnitario FLOAT,
        FOREIGN KEY (idNota) REFERENCES Notas (idNota)
      )
    ''');

    await db.execute('''
      INSERT INTO DetallesPedido_temp (idDetalles, idNota, tipoPrenda, cantidad, precioUnitario)
      SELECT idDetalles, idNota, tipoPrenda, cantidad, precioUnitario FROM DetallesPedido
    ''');

    await db.execute('DROP TABLE DetallesPedido');
    await db.execute('ALTER TABLE DetallesPedido_temp RENAME TO DetallesPedido');
  }
}
