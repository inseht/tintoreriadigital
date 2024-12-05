import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class BdModel {
  static Future<Database> inicializarBD() async {
    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    var dbPath = await databaseFactory.getDatabasesPath();
    var path = join(dbPath, 'tintoreria.db');

    var db = await databaseFactory.openDatabase(path);

    await db.execute('PRAGMA foreign_keys = ON');
    
    try {
      await db.execute(''' 
        CREATE TABLE IF NOT EXISTS Notas (
          idNota INTEGER NOT NULL PRIMARY KEY,
          nombreCliente TEXT NOT NULL,
          telefonoCliente TEXT NOT NULL,
          fechaRecibido DATE NOT NULL,
          fechaEstimada DATE NOT NULL,
          importe FLOAT NOT NULL,
          estadoPago TEXT NOT NULL,
          prioridad INTEGER NOT NULL,
          observaciones TEXT,
          estado TEXT NOT NULL,
          abono FLOAT NOT NULL DEFAULT 0.0
        )
      ''');

      await db.execute(''' 
        CREATE TABLE IF NOT EXISTS Prendas (
          idPrenda INTEGER NOT NULL PRIMARY KEY,
          tipo TEXT NOT NULL,
          servicio TEXT NOT NULL,
          precioUnitario FLOAT NOT NULL, 
          cantidad INTEGER NOT NULL,
          color TEXT NOT NULL,
          idNota INTEGER NOT NULL,
          FOREIGN KEY (idNota) REFERENCES Notas(idNota) ON DELETE CASCADE
        )
      ''');

      await db.execute(''' 
        CREATE TABLE IF NOT EXISTS Proveedores (
          idProveedor INTEGER NOT NULL PRIMARY KEY,
          nombreProveedor TEXT NOT NULL,
          razonProveedor TEXT,
          contactoProveedor1 TEXT NOT NULL,
          contactoProveedor2 TEXT
        )
      ''');

    } catch (e) {
      print('Error al inicializar la base de datos: $e');
    }


    return db;
  }

  static Future<void> crearNotaConPrendas(Map<String, dynamic> nota, List<Map<String, dynamic>> prendas) async {
    final db = await inicializarBD();
    final dateFormat = DateFormat('dd/MM/yyyy');

    try {
      final notaConFechas = {
        ...nota,
        'fechaRecibido': dateFormat.format(nota['fechaRecibido']),
        'fechaEstimada': dateFormat.format(nota['fechaEstimada']),
      };

print('Insertando nota: $notaConFechas');
int idNota = await db.insert('Notas', notaConFechas);
print('Nota insertada con id: $idNota');

for (var prenda in prendas) {
  prenda['idNota'] = idNota;
  print('Insertando prenda: $prenda');
  await db.insert('Prendas', prenda);
}

    } catch (e) {
      print('Error al crear la nota con prendas: $e');
    } finally {
      await db.close();
    }
  }

static Future<List<Map<String, dynamic>>> obtenerNotasConPrendas() async {
  final db = await inicializarBD();
  
  // Mide el tiempo que toma ejecutar la consulta
  final stopwatch = Stopwatch()..start();

  final result = await db.rawQuery('''
    SELECT n.idNota, n.nombreCliente, n.importe, n.estado, n.fechaRecibido, p.tipo, p.servicio, p.color
    FROM notas AS n
    LEFT JOIN prendas AS p ON n.idNota = p.idNota
  ''');

  stopwatch.stop();
  print('Consulta realizada en: ${stopwatch.elapsedMilliseconds}ms');
  
  return result;
}


  static Future<List<Map<String, dynamic>>> obtenerPrendas() async {
    final db = await inicializarBD();
    final List<Map<String, dynamic>> prendas = await db.query('Prendas');
    await db.close();
    return prendas;
  }

  static Future<List<Map<String, dynamic>>> obtenerNotas() async {
    final db = await inicializarBD();
    final List<Map<String, dynamic>> notas = await db.query('Notas');
    final dateFormat = DateFormat('dd/MM/yyyy');
    final List<Map<String, dynamic>> notasConFechas = notas.map((nota) {
      return {
        ...nota,
        'fechaRecibido': dateFormat.parse(nota['fechaRecibido'] as String),
        'fechaEstimada': dateFormat.parse(nota['fechaEstimada'] as String),
      };
    }).toList();
    await db.close();
    return notasConFechas;
  }

  static Future<Map<String, List<Map<String, dynamic>>>> obtenerDatosDeTodasLasTablas() async {
    final db = await inicializarBD();
    final proveedores = await db.query('Proveedores');
    final prendas = await db.query('Prendas');
    final notas = await db.query('Notas');
    await db.close();

    return {
      'Proveedores': proveedores,
      'Prendas': prendas,
      'Notas': notas,
    };
  }

  static Future<void> actualizarProveedor(int idProveedor, Map<String, dynamic> proveedorActualizado) async {
    final db = await inicializarBD();
    await db.update(
      'Proveedores',
      proveedorActualizado,
      where: 'idProveedor = ?',
      whereArgs: [idProveedor],
    );
    await db.close();
  }

  static Future<void> eliminarProveedor(int idProveedor) async {
    final db = await inicializarBD();
    await db.delete(
      'Proveedores',
      where: 'idProveedor = ?',
      whereArgs: [idProveedor],
    );
    await db.close();
  }

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

  static Future<List<Map<String, dynamic>>> obtenerNotasConPrioridad1() async {
    final db = await inicializarBD();
    try {
      final List<Map<String, dynamic>> notas = await db.query(
        'Notas',
        where: 'prioridad = ?',
        whereArgs: [1],
      );
      return notas;
    } catch (e) {
      print('Error al obtener notas con prioridad 1: $e');
      return [];
    } finally {
      await db.close();
    }
  }

  static Future<Map<DateTime, List<Map<String, dynamic>>>> fetchEventos() async {
    final List<Map<String, dynamic>> notas = await obtenerNotas();

    final Map<DateTime, List<Map<String, dynamic>>> eventos = {};

    for (final nota in notas) {
      final fechaRecibido = nota['fechaRecibido'] as DateTime;

      if (eventos[fechaRecibido] == null) {
        eventos[fechaRecibido] = [];
      }
      eventos[fechaRecibido]!.add(nota);
    }

    return eventos;
  }

  static Future<void> agregarPrenda(Map<String, dynamic> prenda) async {
    final db = await inicializarBD();
    try {
      await db.insert('Prendas', prenda);
      print('Prenda agregada con éxito');
    } catch (e) {
      print('Error al agregar prenda: $e');
    } finally {
      await db.close();
    }
  }

  static Future<void> eliminarNota(int idNota) async {
    final db = await inicializarBD();
    await db.delete('Prendas', where: 'idNota = ?', whereArgs: [idNota]);  // Elimina prendas asociadas
    await db.delete('Notas', where: 'idNota = ?', whereArgs: [idNota]);  // Elimina la nota
  }

  static Future<void> actualizarNota(int idNota, Map<String, dynamic> nuevaNota) async {
    final db = await inicializarBD();
    await db.update('Notas', nuevaNota, where: 'idNota = ?', whereArgs: [idNota]);
  }

  static Future<void> actualizarPrenda(int idPrenda, Map<String, dynamic> nuevaPrenda) async {
    final db = await inicializarBD();
    await db.update('Prendas', nuevaPrenda, where: 'idPrenda = ?', whereArgs: [idPrenda]);
  }

  
}
