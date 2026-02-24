import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final _dbName = "e_note.db";
  static final _dbVersion = 1;

  // ------------------- Login -------------------
  static final _loginTblName = 'Login';
  static final loginId = 'LoginId';
  static final loginEmail = 'LoginEmail';
  static final loginPassword = 'LoginPassword';

  // ------------------- Register -------------------
  static final regTblName = 'Register';
  static final regId = 'RegId';
  static final regFirstName = 'RegFirstName';
  static final regLastName = 'RegLastName';
  static final regEmail = 'RegEmail';
  static final regPass = 'RegPass';
  static final regConfirmPass = 'RegConfirmPass';

  // ------------------- Add Note -------------------
  static final noteTblName = 'AddNote';
  static final noteId = 'NoteId';
  static final noteImg = 'NoteImg';
  static final noteTitle = 'NoteTitle';
  static final noteSubTitle = 'NoteSubTitle';
  static final noteDescription = 'NoteDescription';

  DBHelper._privateconstructor();
  static final DBHelper instance = DBHelper._privateconstructor();

  Database? _db;

  Future<Database> get database async => _db ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory directoryPath = await getApplicationDocumentsDirectory();
    String finalpath = join(directoryPath.path, _dbName);
    print("DB Path: $finalpath");
    return await openDatabase(
      finalpath,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Login Table
    await db.execute('''
      CREATE TABLE $_loginTblName(
        $loginId INTEGER PRIMARY KEY AUTOINCREMENT,
        $loginEmail TEXT NOT NULL,
        $loginPassword TEXT NOT NULL
      )
    ''');

    // Register Table
    await db.execute('''
      CREATE TABLE $regTblName(
        $regId INTEGER PRIMARY KEY AUTOINCREMENT,
        $regFirstName TEXT NOT NULL,
        $regLastName TEXT NOT NULL,
        $regEmail TEXT NOT NULL UNIQUE,
        $regPass TEXT NOT NULL,
        $regConfirmPass TEXT NOT NULL
      )
    ''');

    // Note Table
    await db.execute('''
      CREATE TABLE $noteTblName(
        $noteId INTEGER PRIMARY KEY AUTOINCREMENT,
        $noteImg TEXT NOT NULL,
        $noteTitle TEXT NOT NULL,
        $noteSubTitle TEXT NOT NULL,
        $noteDescription TEXT NOT NULL
      )
    ''');
  }

  // ------------------- Login Methods -------------------
  Future<int> insertLoginData(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_loginTblName, row);
  }

  Future<List<Map<String, dynamic>>> viewLoginData() async {
    Database db = await instance.database;
    return await db.query(_loginTblName);
  }

  Future<bool> validateUser(String email, String password) async {
    Database db = await instance.database;
    var result = await db.query(
      regTblName,
      where: '$regEmail = ? AND $regPass = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty;
  }

  // ------------------- Register Methods -------------------
  Future<int> insertRegisterData(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(regTblName, row);
  }

  Future<List<Map<String, dynamic>>> viewRegisterData() async {
    Database db = await instance.database;
    return await db.query(regTblName);
  }

  // ------------------- Note Methods -------------------
  Future<int> insertNoteData(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(noteTblName, row);
  }

  Future<List<Map<String, dynamic>>> viewNoteData() async {
    Database db = await instance.database;
    return await db.query(noteTblName);
  }

  Future<int> updateNoteData(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[noteId]; // row must contain NoteId
    return await db.update(
      noteTblName,
      row,
      where: '$noteId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNoteData(int id) async {
    Database db = await instance.database;
    return await db.delete(
      noteTblName,
      where: '$noteId = ?',
      whereArgs: [id],
    );
  }

  Future<bool> checkUserExists(String email) async {
    final db = await database;
    var result = await db.query('Register',
        where: 'RegEmail = ?', whereArgs: [email]);
    return result.isNotEmpty;
  }

}
