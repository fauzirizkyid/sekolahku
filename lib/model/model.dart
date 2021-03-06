import 'package:sqflite/sqflite.dart';

class Model {
  Future<void> onConfigure(Database db) async {
    print('[db] configure version ${await db.getVersion()}');
  }

  Future<void> onOpen(Database db, int version) async {
    print('[db] open version ${await db.getVersion()}');
  }

  Future<void> onCreate(Database db, int version) async {
    print('[db] create version ${version.toString()}');
    String sqlStudent = '''
      CREATE TABLE IF NOT EXISTS Siswa (
        id_siswa INTEGER PRIMARY KEY NOT NULL,
        first_name TEXT(20),
        last_name TEXT(20),
        gender TEXT(6),
        grade TEXT(3),
        address TEXT(45),
        mobile_phone TEXT(13),
        hobbies TEXT,
        created_at TEXT,
        updated_at TEXT
      );
    ''';

    String sqlTeacher = '''
      CREATE TABLE IF NOT EXISTS Guru (
        id_guru INTEGER PRIMARY KEY NOT NULL,
        first_name TEXT(20),
        last_name TEXT(20),
        gender TEXT(6),
        address TEXT(45),
        mobile_phone TEXT(13),
        lessons TEXT,
        birth_date TEXT(45),
        created_at TEXT,
        updated_at TEXT
      );
    ''';

    String sqlUser = '''
      CREATE TABLE IF NOT EXISTS User (
        id_user INTEGER PRIMARY KEY NOT NULL,
        first_name TEXT(20),
        last_name TEXT(20),
        gender TEXT(6),
        address TEXT(45),
        mobile_phone TEXT(13),
        username TEXT,
        password TEXT(45),
        created_at TEXT,
        updated_at TEXT
      );
    ''';
    await db.execute(sqlStudent);
    await db.execute(sqlTeacher);
    await db.execute(sqlUser);
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('[db] oldVersion $oldVersion');
    print('[db] newVersion $newVersion');
    if (newVersion > oldVersion) {
      // ignore: todo
      // TODO: place migration script here
    }
  }

  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    print('[db] oldVersion $oldVersion');
    print('[db] newVersion $newVersion');
    if (newVersion < oldVersion) {
      // ignore: todo
      // TODO: place migration script here
    }
  }
}