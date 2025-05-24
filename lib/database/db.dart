import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();
  static final DB instance = DB._();
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'agenda.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_user);
    await db.execute(_location);
    await db.execute(_appointment);
    await db.execute(_invitation);
  }

  String get _user => '''
    CREATE TABLE user(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL,
      fullname TEXT NOT NULL,
      email TEXT NOT NULL,
      password TEXT NOT NULL,
      birthdate TEXT,
      gender TEXT,
      profile_picture TEXT
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
      FOREIGN KEY (user_id) REFERENCES user(id) ON DELETE CASCADE
    )
  ''';

  String get _appointment => '''
    CREATE TABLE appointment(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      status INTEGER NOT NULL DEFAULT 1,
      start_hour_date TEXT NOT NULL,
      end_hour_date TEXT NOT NULL,
      appointment_creator INTEGER NOT NULL,
      location_id INTEGER NOT NULL,
      FOREIGN KEY (location_id) REFERENCES location(id) ON DELETE RESTRICT,
      FOREIGN KEY (appointment_creator) REFERENCES user(id) ON DELETE CASCADE
    )
  ''';

  String get _invitation => '''
    CREATE TABLE invitation(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      organizer_user_id INTEGER NOT NULL,
      guest_user_id INTEGER NOT NULL,
      invitation_status INTEGER NOT NULL DEFAULT 0,
      appointment_id INTEGER NOT NULL,
      FOREIGN KEY (organizer_user) REFERENCES user(id) ON DELETE CASCADE,
      FOREIGN KEY (id_guest_user) REFERENCES user(id) ON DELETE CASCADE,
      FOREIGN KEY (appointment_id) REFERENCES appointment(id) ON DELETE CASCADE
    )
  ''';
}
