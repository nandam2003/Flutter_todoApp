import 'dart:io';
import 'package:flutter_application_1/data/task_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  String tableName = 'myTable';
  String columnid = 'id';
  String columntodo = 'todo';
  String columnisDone = 'isDone';

  DataBaseHelper._createInstance();

  static final DataBaseHelper _dataBaseHelper =
      DataBaseHelper._createInstance();

  factory DataBaseHelper() {
    return _dataBaseHelper;
  }

  late Database _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'todo_list.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableName (
            $columnid INTEGER PRIMARY KEY AUTOINCREMENT,
            $columntodo TEXT NOT NULL,
            $columnisDone INTEGER
            )
          ''');
  }

  Future<int> insert(Task task) async {
    return await _db.insert(
      tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> query() async {
    return await _db.query(tableName, orderBy: "$columnid DESC");
  }

  Future<List<Task>> listOfTodoClass() async {
    List<Map<String, dynamic>> listOfMap = await query();
    List<Task> listOfTask = [];
    for (int i = 0; i < listOfMap.length; i++) {
      listOfTask.add(Task.formMap(listOfMap[i]));
    }
    return listOfTask;
  }

  Future<int> update(Task task) async {
    int id = task.id;
    return await _db
        .update(tableName, task.toMap(), where: '$columnid=?', whereArgs: [id]);
  }

  Future<int> delete(Task task) async {
    return await _db
        .delete(tableName, where: '$columnid=?', whereArgs: [task.id]);
  }
}
