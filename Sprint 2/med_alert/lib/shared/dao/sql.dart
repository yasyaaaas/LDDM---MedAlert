import 'package:med_alert/shared/models/remedio_model.dart';
import 'package:med_alert/shared/models/usuario_model.dart';

class ConnectionSQL {
  static const CREATE_DATABASE = '''
  CREATE TABLE `remedios` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `nome`  INTEGER,
  `tipo` INTEGER
  );

  CREATE TABLE `usuarios` (
  `id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `nome`  INTEGER,
  `sobrenome`  INTEGER
  `data` DATE
  `email` INTEGER
  `senha` INTEGER
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

  static String selecionarTodosOsUsuarios() {
    return 'select * from usuarios;';
  }

  static String adicionarUsuario(Usuario usuario) {
    return '''
    insert into usuarios (nome, sobrenome, data, email, senha)
    values ('${usuario.nome}', '${usuario.sobrenome}'), '${usuario.data}'), '${usuario.email}'), '${usuario.senha}');
    ''';
  }

  static String atualizarUsuario(Usuario usuario) {
    return '''
    update usuario
    set nome = '${usuario.id}',
    set tipo = '${usuario.id}'
    where id = ${usuario.id};
    ''';
  }

  static String deletarUsuario(Usuario usuario){
    return 'delete from usuarios where id = ${usuario.id};';
  }

}