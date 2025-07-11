import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();
  static final DB instance = DB._();
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
    // await deleteDatabase(join(await getDatabasesPath(), 'agenda.db'));
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
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      firebase_uid TEXT NOT NULL UNIQUE,
      username TEXT NOT NULL UNIQUE,
      fullname TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL,
      birthdate TEXT,
      gender TEXT,
      profile_picture TEXT
    )
  ''';

  String get _location => '''
    CREATE TABLE locations (
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
    CREATE TABLE appointments (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT NOT NULL,
      status INTEGER NOT NULL DEFAULT 1,
      start_hour_date TEXT NOT NULL,
      end_hour_date TEXT NOT NULL,
      appointment_creator_id INTEGER NOT NULL,
      location_id INTEGER NOT NULL,
      FOREIGN KEY (location_id) REFERENCES location(id) ON DELETE RESTRICT,
      FOREIGN KEY (appointment_creator_id) REFERENCES user(id) ON DELETE CASCADE
    )
  ''';

  String get _invitation => '''
    CREATE TABLE invitations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      organizer_user_id INTEGER NOT NULL,
      guest_user_id INTEGER NOT NULL,
      invitation_status INTEGER NOT NULL DEFAULT 0,
      appointment_id INTEGER NOT NULL,
      FOREIGN KEY (organizer_user_id) REFERENCES user(id) ON DELETE CASCADE,
      FOREIGN KEY (guest_user_id) REFERENCES user(id) ON DELETE CASCADE,
      FOREIGN KEY (appointment_id) REFERENCES appointment(id) ON DELETE CASCADE
    )
  ''';
}
