class Usuario {
  int? id;
  String nome;
  String email;
  String senha;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha
  });

  factory Usuario.fromSQLite(Map map){
    return Usuario(
      id: map['id'], 
      nome: map['nome'],
      email: map['email'],
      senha: map['senha']
      );
  }

  static List<Usuario> fromSQLiteList(List<Map> listMap){
    List<Usuario> usuario = [];
    for (Map item in listMap) {
      usuario.add(Usuario.fromSQLite(item));
    }
    return usuario;
  }
}