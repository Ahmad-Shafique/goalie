import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:goalie/models/basicGoal.dart';


final basicGoalsTable = "basicGoalsTable";
final dbName = 'goalie.db';

class SQLiteBasicGoalDatabaseService {
  static final SQLiteBasicGoalDatabaseService _instance = SQLiteBasicGoalDatabaseService._internal();
  Future<Database> database;

  factory SQLiteBasicGoalDatabaseService() {
    return _instance;
  }

  SQLiteBasicGoalDatabaseService._internal()
  {

  }



  initDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), dbName),

      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE $basicGoalsTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            goalName TEXT,
            startTime TEXT,
            endTime TEXT,
            lastUpdated TEXT,
            active INTEGER,
            completed INTEGER
            )
          ''',
        );
      },


      version: 1,
    );
  }

  Future<int> insertOrReplaceBasicGoal(BasicGoal goal) async {
    //print("String object generated: "+ goal.toSQLiteInsertMap().toString());

    Database db = await database;
    int id = await db.insert(
      basicGoalsTable,
      goal.toSQLiteInsertMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }


  Future<BasicGoal> getBasicGoal(int id) async {
    Database db = await database;
    List<Map> data = await db.query(basicGoalsTable,
        where: 'id = ?',
        whereArgs: [id]);
    if (data.length > 0) {
      return BasicGoal.fromSQLiteMap(data.first);
    }
    return null;
  }


  Future<List<BasicGoal>> getAllBasicGoals() async {

    final Database db = await database;


    final List<Map<String, dynamic>> maps = await db.query(basicGoalsTable);


    return List.generate(maps.length, (i) {
      return BasicGoal.fromSQLiteMap(maps[i]);
    });
  }

  Future<void> updateBasicGoal(BasicGoal basicGoal) async {

    final db = await database;

    await db.update(
      basicGoalsTable,
      basicGoal.toSQLiteInsertMap(),
      where: "id = ?",
      whereArgs: [basicGoal.id],
    );
  }

  Future<void> deleteBasicGoal(int id) async {
    final db = await database;
    await db.delete(
      basicGoalsTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }

}
