class Remedio {
  int? id;
  String nome;
  String tipo;

  Remedio({
    this.id,
    required this.nome,
    required this.tipo
  });

  factory Remedio.fromSQLite(Map map){
    return Remedio(
      id: map['id'], 
      nome: map['nome'],
      tipo: map['tipo']
      );
  }

  static List<Remedio> fromSQLiteList(List<Map> listMap){
    List<Remedio> remedio = [];
    for (Map item in listMap) {
      remedio.add(Remedio.fromSQLite(item));
    }
    return remedio;
  }
}