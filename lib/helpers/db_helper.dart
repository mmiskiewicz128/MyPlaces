import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBHepler {
  static const String placeTebleName = 'MyPlaces';

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();

    return await sql.openDatabase(path.join(dbPath, 'MyPlaces.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $placeTebleName (ID TEXT PRIMARY KEY, Title TEXT, Image TEXT, PlaceType INT, Location VARCHAR(100))');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> values) async {
    final sqlDatabase = await database();
    await sqlDatabase.insert(table, values,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> delete(String table, String id) async{
     final sqlDatabase = await database();
     await sqlDatabase.rawDelete("DELETE FROM $table WHERE ID = \'$id\'");
  }

  static Future<List<Map<String, Object>>> getData(String table) async {
    final sqlDatabase = await database();
    return await sqlDatabase.query(table);
  }
}
