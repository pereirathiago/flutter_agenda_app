import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqlite_api.dart';

class DB {
  DB._();
  static final DB _instance = DB._();
  static Database? _database;

  get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'agenda.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    final db = await database;
    await db.execute(_user);
    await db.execute(_location);
    await db.execute(_appointment);
  }

  String get _user => '''
    CREATE TABLE user(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      fullname TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      birthdate TEXT NOT NULL,
      gender TEXT NOT NULL,
      profile_picture TEXT NOT NULL
    )
  ''';
  String get _appointment => '''
    CREATE TABLE appointment(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      tittle TEXT NOT NULL,
      description TEXT NOT NULL,
      status INTEGER NOT NULL,
      start_hour_date DATETIME NOT NULL,
      end_hour_date DATETIME NOT NULL,
      appointment_creator INTEGER NOT NULL,
      location_id INTEGER NOT NULL,
      FOREIGN KEY (location_id) REFERENCES location(id),
      appointment_creator INTEGER NOT NULL,
      FOREIGN KEY (appointment_creator) REFERENCES user(id),
    )
  ''';

  String get _location => '''
    CREATE TABLE location(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      zip_code TEXT NOT NULL,
      address TEXT NOT NULL,
      no_number INTEGER NOT NULL,
      number TEXT NOT NULL,
      city TEXT NOT NULL,
      state TEXT NOT NULL,
      neighborhood TEXT NOT NULL,
      user_id INTEGER NOT NULL,
      FOREIGN KEY (user_id) REFERENCES user(id)
    )
  ''';

  String get _invitation => '''
    CREATE TABLE invitation(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      organizer_user INTEGER NOT NULL,
      id_guest_user INTEGER NOT NULL,
      invitation_status INTEGER NOT NULL,
      appointment_id INTEGER NOT NULL,
      FOREIGN KEY (organizer_user) REFERENCES user(id),
      FOREIGN KEY (id_guest_user) REFERENCES user(id),
      FOREIGN KEY (appointment_id) REFERENCES appointment(id)
    )
  ''';

  
}
