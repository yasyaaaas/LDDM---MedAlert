import 'package:flutter/material.dart';
import 'package:med_alert/shared/models/remedio_model.dart';

class ListarRemediosScreen extends StatefulWidget {
  const ListarRemediosScreen ({Key? key}) : super(key: key);

  @override
  _ListarRemediosScreenState createState() => _ListarRemediosScreenState();
}

class _ListarRemediosScreenState extends State<ListarRemediosScreen>{
  List<Remedio> remedios = [
    Remedio(id: 1, nome: 'Ibuprofeno', tipo: 'Inflamação'),
    Remedio(id: 2, nome: 'Novalgina', tipo: 'Dores Leves'),
    Remedio(id: 3, nome: 'Codeina', tipo: 'Dores Fortes'),
    Remedio(id: 4, nome: 'Paracetamol', tipo: 'Dores Leves'),
    Remedio(id: 5, nome: 'Ibuprofeno', tipo: 'Inflamação'),
  ];


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Remedios'),
      ),
      body: ListView.builder(
        itemCount: remedios.length,
        itemBuilder: (context, index){
          Remedio remedio = remedios[index];
          return ListTile(
            title: Text(remedio.nome),
            subtitle: Text(remedio.tipo),
            onTap: () {},
          );
        },
      ),
    );
  }
}
