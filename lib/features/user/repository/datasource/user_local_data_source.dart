import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pessoas/features/user/model/user_persistence_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(UserPersistenceModel user);
  Future<void> deleteUser(String uuid);
  Future<List<UserPersistenceModel>> getAllUsers();
  Future<bool> exists(String uuid);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  UserLocalDataSourceImpl._(this._database);

  final Database _database;

  static const String _dbName = 'pessoas_users.db';
  static const int _dbVersion = 1;
  static const String _table = 'users';

  static Future<UserLocalDataSourceImpl> create() async {
    final directory = await getApplicationDocumentsDirectory();
    final databasePath = p.join(directory.path, _dbName);
    final database = await openDatabase(
      databasePath,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_table (
            login_uuid TEXT PRIMARY KEY,
            gender TEXT,
            name_title TEXT,
            name_first TEXT,
            name_last TEXT,
            location_street_number INTEGER,
            location_street_name TEXT,
            location_city TEXT,
            location_state TEXT,
            location_country TEXT,
            location_postcode TEXT,
            location_coordinates_latitude TEXT,
            location_coordinates_longitude TEXT,
            location_timezone_offset TEXT,
            location_timezone_description TEXT,
            email TEXT,
            login_username TEXT,
            login_password TEXT,
            login_salt TEXT,
            login_md5 TEXT,
            login_sha1 TEXT,
            login_sha256 TEXT,
            dob_date TEXT,
            dob_age INTEGER,
            registered_date TEXT,
            registered_age INTEGER,
            phone TEXT,
            cell TEXT,
            id_name TEXT,
            id_value TEXT,
            picture_large TEXT,
            picture_medium TEXT,
            picture_thumbnail TEXT,
            nat TEXT
          )
        ''');
      },
    );
    return UserLocalDataSourceImpl._(database);
  }

  @override
  Future<void> saveUser(UserPersistenceModel user) async {
    await _database.insert(
      _table,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteUser(String uuid) async {
    await _database.delete(
      _table,
      where: 'login_uuid = ?',
      whereArgs: [uuid],
    );
  }

  @override
  Future<List<UserPersistenceModel>> getAllUsers() async {
    final rows = await _database.query(
      _table,
      orderBy: 'name_first COLLATE NOCASE ASC',
    );
    return rows.map(UserPersistenceModel.fromMap).toList();
  }

  @override
  Future<bool> exists(String uuid) async {
    final rows = await _database.query(
      _table,
      columns: const ['login_uuid'],
      where: 'login_uuid = ?',
      whereArgs: [uuid],
      limit: 1,
    );
    return rows.isNotEmpty;
  }
}
