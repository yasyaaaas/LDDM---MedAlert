import 'package:flutter/material.dart';

class EditTimeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _EditTimeScreenState createState() => _EditTimeScreenState();
}

const Color backgroundColor = Colors.white;

class _EditTimeScreenState extends State<EditTimeScreen> {

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
                children: [
                  _medicationItem('Ibuprofeno', 'Analgésico e anti-inflamatório.', Icons.medication),
                  _medicationItem('Paracetamol', 'Analgésico e antipirético.', Icons.medication),
                  _medicationItem('Amoxicilina', 'Antibiótico.', Icons.medication),
                  _medicationItem('Losartana', 'Antihipertensivo.', Icons.medication),
                  _medicationItem('Metformina', 'Antidiabético.', Icons.medication),
                  _medicationItem('Aspirina', 'Analgésico, antipirético e anti-inflamatório.', Icons.medication),
                  _medicationItem('Simvastatina', 'Hipolipemiante.', Icons.medication),
                  _medicationItem('Omeprazol', 'Inibidor da bomba de prótons.', Icons.medication),
                  _medicationItem('Loratadina', 'Antihistamínico.', Icons.medication),
                  _medicationItem('Fluoxetina', 'Antidepressivo.', Icons.medication),
                  _medicationItem('Sertralina', 'Antidepressivo.', Icons.medication),
                  _medicationItem('Dipirona', 'Analgésico e antipirético.', Icons.medication),
                ],
              ),

        ),
      ),
    );
  }

  Widget _medicationItem(String name, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.red,),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)), 
                Text(description, style: TextStyle(fontSize: 20, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }

}