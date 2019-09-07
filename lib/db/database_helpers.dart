import 'dart:io';
import 'package:mana_app/db/entities/event.dart' as prefix0;
import 'package:mana_app/db/entities/mana.dart' as prefix1;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/event.dart';
import 'entities/mana.dart';

class DatabaseHelper{

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "ManaDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableMana (
                _id INTEGER PRIMARY KEY,
                $columnDate INT NOT NULL,
                $columnStartMana INTEGER NOT NULL,
                $columnCurrentMana INTEGER NOT NULL
              )
              ''');
    await db.execute('''
              CREATE TABLE $tableEvent (
                _id INTEGER PRIMARY KEY,
                $columnManaId INT NOT NULL,
                $columnAmount INT NOT NULL,
                $columnDescription INTEGER NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insertMana(Mana mana) async {
    Database db = await database;
    int id = await db.insert(tableMana, mana.toMap());
    return id;
  }

  Future<Mana> queryMana(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableMana,
        columns: [prefix1.columnId, columnDate, columnStartMana, columnCurrentMana],
        where: '_id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Mana.fromMap(maps.first);
    }
    return null;
  }

  void updateMana(Mana mana, int amount) async{
    Database db = await database;
    mana.currentMana = mana.currentMana + amount;
    db.update(prefix1.tableMana, mana.toMap());
  }

  Future<int> insertEvent(Mana mana, Event event) async {
    Database db = await database;
    int id = await db.insert(prefix0.tableEvent, event.toMap());

    updateMana(mana, event.amount);

    return id;
  }

  Future<Event> queryEvent(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(prefix0.tableEvent,
        columns: [prefix0.columnId, prefix0.columnManaId, prefix0.columnAmount, prefix0.columnDescription],
        where: '$Mana.columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Event.fromMap(maps.first);
    }
    return null;
  }

// TODO: queryAll()
// TODO: delete(int id)
// TODO: update(Word word)
}

