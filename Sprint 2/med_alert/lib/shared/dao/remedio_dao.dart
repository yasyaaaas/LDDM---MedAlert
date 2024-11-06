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
    print('Erro ao adicionar remédio: $error');
    throw Exception('Erro ao adicionar remédio: $error');
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

  Future<List<Remedio>> selecionarTodos() async {
  try {
    Database db = await _getDatabase();
    List<Map<String, dynamic>> linhas = await db.rawQuery(ConnectionSQL.selecionarTodosOsRemedios());

    for (var linha in linhas) {
      print('Linha do banco de dados: $linha'); // Adicione isso para ver o conteúdo de cada linha
    }
    
    // Converter a lista de mapas para uma lista de objetos Remedio
    List<Remedio> remedios = linhas.map((linha) => Remedio.fromSQLite(linha)).toList();
    return remedios;
  } catch (error) {
    print('Erro ao selecionar remédios: $error');
    throw Exception('Erro ao selecionar remédios: $error');
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