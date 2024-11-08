import 'package:sqflite_common_ffi/sqflite_ffi.dart';


Future main() async {
  sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;
  var db = await databaseFactory.openDatabase(inMemoryDatabasePath);
  await db.execute('''
  CREATE TABLE Product (
      id INTEGER PRIMARY KEY,
      title TEXT
  )
  ''');
  await db.insert('Product', <String, Object?>{'title': 'Product 1'});
  await db.insert('Product', <String, Object?>{'title': 'Product 1'});

  // var result = await db.query('Product');
  // print(result);

  await db.close();
}