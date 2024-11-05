import 'package:med_alert/shared/dao/sql.dart';
import 'package:med_alert/shared/models/remedio_model.dart';
import 'package:med_alert/shared/services/connection_sqlite_service.dart';
import 'package:sqflite/sqflite.dart';

class RemedioDao {
  ConnectionSqliteService _connection = ConnectionSqliteService.instance;

  Future<Database> _getDatabase() async {
    return await _connection.db;
  }

  Future<Remedio> adicionar(Remedio remedio) async {
    try {
      Database db = await _getDatabase();
      int idRetornado = await db.rawInsert(ConnectionSQL.adicionarRemedio(remedio));
      remedio.id = idRetornado;
      return remedio;
    } catch (error) {
      throw Exception();
    }
  } 

  Future<bool> atualizar(Remedio remedio) async {
    try {
      Database db = await _getDatabase();
    int linhasAfetadas = await db.rawUpdate(ConnectionSQL.atualizarRemedio(remedio));
    if (linhasAfetadas > 0){
      return true;
    }
    return false;
    } catch (error) {
      throw Exception();
    }
  }

  Future<List<Remedio>> selecionarTodos(Remedio remedio) async {
    try {
      Database db = await _getDatabase();
      List<Map> linhas = await db.rawQuery(ConnectionSQL.selecionarTodosOsRemedios());
    	List<Remedio> remedios = Remedio.fromSQLiteList(linhas);
      return remedios;
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> deletar(Remedio remedio) async {
    try {
      Database db = await _getDatabase();
      int linhasAfetadas = await db.rawDelete(ConnectionSQL.deletarRemedio(remedio));
      if (linhasAfetadas > 0 ) {
        return true;
      }
      return false;
    } catch (error) {
      throw Exception();
    }
  }
}