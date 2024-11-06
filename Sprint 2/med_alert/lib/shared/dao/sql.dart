// ignore_for_file: constant_identifier_names

import 'package:med_alert/shared/models/remedio_model.dart';
import 'package:med_alert/shared/models/usuario_model.dart';

class ConnectionSQL {
  static const String CREATE_DATABASE = '''
  CREATE TABLE Remedios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    tipo TEXT NOT NULL,
    dosagem TEXT NOT NULL,
    frequencia INTEGER,
    horario TEXT
  );

  CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nome TEXT NOT NULL,
    sobrenome TEXT NOT NULL,
    data DATE,
    email TEXT NOT NULL,
    senha TEXT NOT NULL
  );
''';


  static String selecionarTodosOsRemedios() {
    return 'SELECT * FROM remedios;';
  }

  static String adicionarRemedio(Remedio remedio) {
    return '''
      INSERT INTO Remedios (nome, tipo, dosagem, frequencia, horario)
      VALUES ("${remedio.nome}", "${remedio.tipo}", "${remedio.dosagem}", "${remedio.frequencia}", "${remedio.horario}")
    ''';
  }

  static String atualizarRemedio(Remedio remedio) {
    return '''
      UPDATE Remedios SET nome = "${remedio.nome}", tipo = "${remedio.tipo}", dosagem = "${remedio.dosagem}", 
      frequencia = ${remedio.frequencia}, horario = ${remedio.horario} WHERE id = ${remedio.id}
    ''';
  }

  static String deletarRemedio(Remedio remedio){
    return 'DELETE from Remedios WHERE id = ${remedio.id};';
  }

  static String selecionarTodosOsUsuarios() {
    return 'select * from usuarios;';
  }

  static String adicionarUsuario(Usuario usuario) {
  return '''
    INSERT INTO usuarios (nome, sobrenome, data, email, senha)
    VALUES ('${usuario.nome}', '${usuario.sobrenome}', '${usuario.data}', '${usuario.email}', '${usuario.senha}');
  ''';
}


  static String atualizarUsuario(Usuario usuario) {
  return '''
    UPDATE usuarios
    SET nome = '${usuario.nome}',
        sobrenome = '${usuario.sobrenome}',
        data = '${usuario.data}',
        email = '${usuario.email}',
        senha = '${usuario.senha}'
    WHERE id = ${usuario.id};
  ''';
}


  static String deletarUsuario(Usuario usuario){
    return 'delete from usuarios where id = ${usuario.id};';
  }

}