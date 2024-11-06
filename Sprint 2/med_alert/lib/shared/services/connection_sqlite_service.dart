// ignore_for_file: depend_on_referenced_packages, constant_identifier_names, unused_element

import 'dart:async';
import 'package:med_alert/shared/dao/sql.dart';
import 'package:sqflite/sqflite.dart';
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
    try {
      _db = await _initDatabase();
    } catch (e) {
      print("Erro ao abrir o banco de dados: $e");
      throw Exception("Erro ao abrir o banco de dados.");
    }
    return _db!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, DATABASE_NAME);

    return await openDatabase(
      path,
      version: DATABASE_VERSION,
      onCreate: _onCreate,
      onOpen: (db) {
        print("Banco de dados aberto com sucesso.");
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute(ConnectionSQL.CREATE_TABLE_REMEDIO);
      await db.execute(ConnectionSQL.CREATE_TABLE_USUARIO);
      // Adicione outros comandos CREATE TABLE, se necessário
    } catch (e) {
      print("Erro ao criar tabelas: $e");
      throw Exception("Erro ao criar tabelas no banco de dados.");
    }
  }
}
