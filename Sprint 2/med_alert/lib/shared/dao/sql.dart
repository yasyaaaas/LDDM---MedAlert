import 'package:med_alert/shared/models/remedio_model.dart';

class ConnectionSQL {
  static final CREATE_DATABASE = '''
  CREATE TABLE `remedios` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `nome`  INTEGER,
  `tipo` INTEGER
  );
''';

static String selecionarTodosOsRemedios() {
  return 'select * from remedios;';
}

static String adicionarRemedio(Remedio remedio) {
  return '''
  insert into remedios (nome, tipo)
  values ('${remedio.nome}', '${remedio.tipo}');
  ''';
}

static String atualizarRemedio(Remedio remedio) {
  return '''
  update remedio
  set nome = '${remedio.id}',
  set tipo = '${remedio.id}'
  where id = ${remedio.id};
  ''';
}

static String deletarRemedio(Remedio remedio){
  return 'delete from remedios where id = ${remedio.id};';
}

}