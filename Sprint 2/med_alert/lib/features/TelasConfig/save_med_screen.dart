import 'package:flutter/material.dart';
import 'package:med_alert/shared/dao/remedio_dao.dart';
import 'package:med_alert/shared/models/remedio_model.dart';

class EditTimeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _EditTimeScreenState createState() => _EditTimeScreenState();
}

const Color backgroundColor = Colors.white;

class _EditTimeScreenState extends State<EditTimeScreen> {
  final RemedioDao _remedioDao = RemedioDao(); // Instância do DAO para acessar o banco de dados
  List<Remedio> _medications = []; // Lista para armazenar os medicamentos

  @override
  void initState() {
    super.initState();
    _fetchMedications(); // Busca os medicamentos ao inicializar a tela
  }

  Future<void> _fetchMedications() async {
    // Busca os medicamentos no banco de dados
    List<Remedio> medications = await _remedioDao.selecionarTodos();
    setState(() {
      _medications = medications; // Atualiza o estado com a lista de medicamentos
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 154, 193, 221),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Text(
              'Medicamentos Cadastrados',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23.0,
                color: Colors.black,
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            children: _medications.isEmpty
                ? [Text("Nenhum medicamento cadastrado.", style: TextStyle(fontSize: 18))]
                : _medications.map((med) => _medicationItem(med)).toList(),
          ),
        ),
      ),
    );
  }

  // Método que cria o widget de um medicamento
  Widget _medicationItem(Remedio med) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(Icons.medication, size: 24, color: Colors.red),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(med.nome, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)), 
                Text(
                  "Dosagem: ${med.dosagem} - Frequência: ${med.frequencia} vezes ao dia - Horário: ${med.horario ?? 'N/A'}",
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
