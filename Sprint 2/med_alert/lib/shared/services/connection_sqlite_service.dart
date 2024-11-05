import 'dart:async';

import 'package:med_alert/shared/dao/sql.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class ConnectionSqliteService {
  ConnectionSqliteService._();

  static ConnectionSqliteService? _instance;

  static ConnectionSqliteService get instance {
    _instance ??= ConnectionSqliteService._(); //Instancia a classe 
    return _instance!; //Retorna se ja tiver sido criada
  }

  static const DATABASE_NAME = 'contatos';
  static const DATABASE_VERSION = 1;
  Database? _db;

  Future<Database> get db => openDatabase();

  Future<Database> openDatabase() async{
    sqfliteFfiInit();
    String databasePath = await databaseFactoryFfi.getDatabasesPath();
    String path = join(databasePath, DATABASE_NAME);
    DatabaseFactory databaseFactory = databaseFactoryFfi;

    if (_db == null) {
      _db = await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
        onCreate: _onCreate,
        version: DATABASE_VERSION, 
        ));
    }
    return _db!;
  }

  FutureOr<void> _onCreate(Database db, int version){
    db.transaction((reference) async{
      reference.execute(ConnectionSQL.CREATE_DATABASE);
    });
  }
}