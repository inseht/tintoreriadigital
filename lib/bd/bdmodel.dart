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

static Future<void> insertarNotaYAsignarPrendas(Map<String, dynamic> nota, List<Map<String, dynamic>> prendas) async {
  final db = await inicializarBD();
  final dateFormat = DateFormat('dd/MM/yyyy');

  await db.transaction((txn) async {
    try {
      final notaConFechas = {
        ...nota,
        'fechaRecibido': dateFormat.format(nota['fechaRecibido'] as DateTime),
        'fechaEstimada': dateFormat.format(nota['fechaEstimada'] as DateTime),
      };

      print('Insertando nota: $notaConFechas');
      int idNota = await txn.insert('Notas', notaConFechas);
      print('Nota insertada con id: $idNota');

      // Asignar las prendas a la nota insertada
      for (var prenda in prendas) {
        prenda['idNota'] = idNota;
        print('Insertando prenda: $prenda');
        await txn.insert('Prendas', prenda);
      }
    } catch (e) {
      print('Error en la transacción: $e');
      throw e;
    }
  });
}

  static Future<List<Map<String, dynamic>>> obtenerNotasFiltradas(String filtro) async {
    final db = await inicializarBD();
    final List<Map<String, dynamic>> notas = await db.query(
      'Notas',
      where: 'nombreCliente LIKE ? OR telefonoCliente LIKE ? OR estado LIKE ?',
      whereArgs: ['%$filtro%', '%$filtro%', '%$filtro%'],
    );
    await db.close();
    return notas;
  }

  // Método para obtener proveedores filtrados por texto
  static Future<List<Map<String, dynamic>>> obtenerProveedoresFiltrados(String filtro) async {
    final db = await inicializarBD();
    final List<Map<String, dynamic>> proveedores = await db.query(
      'Proveedores',
      where: 'nombreProveedor LIKE ? OR razonProveedor LIKE ? OR contactoProveedor1 LIKE ?',
      whereArgs: ['%$filtro%', '%$filtro%', '%$filtro%'],
    );
    await db.close();
    return proveedores;
  }

  static Future<void> insertarNotaYPrendasConTransaccion(Map<String, dynamic> nota, List<Map<String, dynamic>> prendas) async {
  final db = await inicializarBD();

  final dateFormat = DateFormat('dd/MM/yyyy');

  await db.transaction((txn) async {
    try {
      final notaConFechas = {
        ...nota,
        'fechaRecibido': dateFormat.format(nota['fechaRecibido']),
        'fechaEstimada': dateFormat.format(nota['fechaEstimada']),
      };

      print('Insertando nota: $notaConFechas');
      int idNota = await txn.insert('Notas', notaConFechas);
      print('Nota insertada con id: $idNota');

      for (var prenda in prendas) {
        prenda['idNota'] = idNota;
        print('Insertando prenda: $prenda'); // <-- Aquí verifica que las prendas tengan los datos correctos
        await txn.insert('Prendas', prenda);
      }
    } catch (e) {
      print('Error en la transacción: $e');
      throw e;
    }
  });
}

static Future<void> imprimirPrendas() async {
  final db = await inicializarBD();
  final prendas = await db.query('Prendas');
  print('Prendas en la base de datos: $prendas');
}

static Future<int> crearNotaConPrendas(Map<String, dynamic> nota, List<Map<String, dynamic>> prendas) async {
  final db = await inicializarBD();
  
  // Insertar la nota y obtener el idNota
  final idNota = await db.insert('Notas', nota);

  // Insertar las prendas asociadas a esta nota, asegurándose de asignar el idNota
  for (final prenda in prendas) {
    await db.insert('Prendas', {...prenda, 'idNota': idNota});
  }

  return idNota;  // Devolver el idNota generado
}

static Future<void> asignarPrendasNoAsignadasALaUltimaNota() async {
  final db = await inicializarBD();
  try {
    final idNota = await obtenerUltimaNotaId();
    if (idNota == null) {
      print('No hay notas disponibles para asignar prendas.');
      return;
    }

    final prendasSinAsignar = await obtenerPrendasNoAsignadas();
    print('Prendas sin asignar antes de la actualización: $prendasSinAsignar');

    if (prendasSinAsignar.isNotEmpty) {
      for (var prenda in prendasSinAsignar) {
        await db.update(
          'Prendas',
          {'idNota': idNota},
          where: 'idPrenda = ?',
          whereArgs: [prenda['idPrenda']],
        );
        print('Prenda ${prenda['idPrenda']} asignada a la nota $idNota');
      }
    } else {
      print('No hay prendas sin asignar.');
    }
  } catch (e) {
    print('Error al asignar prendas no asignadas: $e');
  }
}


static Future<void> verificarAsignacion() async {
  final db = await inicializarBD();
  final prendas = await db.query('Prendas', where: 'idNota IS NOT NULL');
  print('Prendas asignadas a notas: $prendas');
}


static Future<void> insertarPrenda(Map<String, dynamic> prenda) async {
  final db = await BdModel.inicializarBD();
  try {
    await db.insert('Prendas', prenda);
    print('Prenda insertada: $prenda');
  } catch (e) {
    print('Error al insertar prenda: $e');
  }
}


static Future<List<Map<String, dynamic>>> obtenerPrendasSinNota() async {
  final db = await inicializarBD();
  final prendas = await db.query('Prendas', where: 'idNota IS NULL');
  print('Prendas sin asignar: $prendas');
  return prendas;
}


static Future<void> verificarPrendasNoAsignadas() async {
  final db = await inicializarBD();
  final prendas = await db.query('Prendas', where: 'idNota IS NULL');
  print('Prendas sin asignar actualmente: $prendas');
}

static Future<List<Map<String, dynamic>>> obtenerPrendasNoAsignadas() async {
  final db = await inicializarBD();
  final prendas = await db.query(
    'Prendas',
    where: 'idNota IS NULL',
  );
  return prendas;
}


static Future<int?> obtenerUltimaNotaId() async {
  final db = await inicializarBD();
  try {
    final result = await db.rawQuery('SELECT MAX(idNota) as maxId FROM Notas');
    if (result.isNotEmpty && result.first['maxId'] != null) {
      return result.first['maxId'] as int;
    } else {
      print('No se encontró ninguna nota en la tabla Notas.');
      return null;
    }
  } catch (e) {
    print('Error al obtener la última nota: $e');
    return null;
  } finally {
    await db.close();
  }
}


static Future<void> asignarPrendasANota(int idNota, List<Map<String, dynamic>> prendas) async {
  final db = await inicializarBD();
  for (final prenda in prendas) {
    print('Actualizando prenda con id: ${prenda['idPrenda']} para asignarla a la nota: $idNota');
    await db.update(
      'Prendas',
      {'idNota': idNota},
      where: 'idPrenda = ?',
      whereArgs: [prenda['idPrenda']],
    );
  }
}

static Future<List<Map<String, dynamic>>> obtenerNotasConPrendas() async {
  final db = await inicializarBD();
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
    await db.delete('Prendas', where: 'idNota = ?', whereArgs: [idNota]); 
    await db.delete('Notas', where: 'idNota = ?', whereArgs: [idNota]); 
  }

  static Future<void> actualizarNota(int idNota, Map<String, dynamic> nuevaNota) async {
    final db = await inicializarBD();
    await db.update('Notas', nuevaNota, where: 'idNota = ?', whereArgs: [idNota]);
  }

static Future<void> actualizarPrenda(int idPrenda, Map<String, dynamic> datos) async {
  final db = await inicializarBD();
  await db.update('Prendas', datos, where: 'idPrenda = ?', whereArgs: [idPrenda]);
}
  
}
