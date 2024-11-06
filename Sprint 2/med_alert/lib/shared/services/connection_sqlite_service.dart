// ignore_for_file: depend_on_referenced_packages, constant_identifier_names, unused_element

import 'dart:async';

import 'package:med_alert/shared/dao/sql.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class ConnectionSqliteService {
  ConnectionSqliteService._();

  static final ConnectionSqliteService _instance = ConnectionSqliteService._();
  static const DATABASE_NAME = 'MedAlertDB';
  static const DATABASE_VERSION = 1;

  Database? _db;

  static ConnectionSqliteService get instance => _instance;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, DATABASE_NAME);

    return await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(ConnectionSQL.CREATE_DATABASE);
  }
}


  FutureOr<void> _onCreate(Database db, int version) async {
  await db.execute(ConnectionSQL.CREATE_DATABASE);
}

