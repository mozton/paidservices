import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:namer_app/screens/manage_services.dart'; // Cambia el path según la ubicación de `Service`


class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'services.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE services (
            bill INTEGER PRIMARY KEY AUTOINCREMENT,
            provider TEXT NOT NULL,
            amount REAL NOT NULL,
            dueDate TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertService(Service service) async {
  final db = await database;
  return await db.insert(
    'services',
    service.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Service>> getServices() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('services');
  return List.generate(maps.length, (i) {
    return Service.fromMap(maps[i]);
  });
}


  Future<int> deleteService(int id) async {
  final db = await database;
  return await db.delete(
    'services',
    where: 'id = ?',
    whereArgs: [id],
  );
}
Future<int> updateService(Service service) async {
  final db = await database;
  return await db.update(
    'services',
    service.toMap(),
    where: 'id = ?',
    whereArgs: [service.bill],
  );
}

}
