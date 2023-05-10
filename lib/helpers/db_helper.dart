import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

import '../models/task.dart';

class DBHelper {
  static Future<sql.Database?> database() async {
    try {
      final dbPath = await sql.getDatabasesPath();
      return sql.openDatabase(path.join(dbPath, 'tasks.db'), version: 1,
          onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT, date STRING, startTime STRING, endTime STRING, remind INTEGER, repeat STRING, color INTEGER, isCompleted INTEGER)');
      });
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    return await db!.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> query(String table) async {
    final db = await DBHelper.database();
    return await db!.query(table);
  }

  static Future<int> delete(String table, Task task) async {
    final db = await DBHelper.database();
    return await db!.delete(table, where: 'id=?', whereArgs: [task.id]);
  }

  static Future<int> update(String table, int id) async {
    final db = await DBHelper.database();
    return await db!.rawUpdate('''
    UPDATE $table 
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }
}
