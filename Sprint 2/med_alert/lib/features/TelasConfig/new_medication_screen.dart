import 'package:flutter/material.dart';

class NewMedicationScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _NewMedicationScreenState createState() => _NewMedicationScreenState();
}

const Color backgroundColor = Colors.white;

class _NewMedicationScreenState extends State<NewMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

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
              'Adicionar Novo Remédio',
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTextField(
                  controller: _nameController,
                  label: 'Nome do Remédio',
                ),
                SizedBox(height: 20),
                buildTextField(
                  controller: _doseController,
                  label: 'Dosagem (mg)',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                buildTextField(
                  controller: _frequencyController,
                  label: 'Frequência (vezes ao dia)',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                buildTextField(
                  controller: _timeController,
                  label: 'Horário (Ex: 08:00)',
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Lógica para salvar o novo remédio
                      print('Remédio: ${_nameController.text}');
                      print('Dosagem: ${_doseController.text}mg');
                      print('Frequência: ${_frequencyController.text} vezes ao dia');
                      print('Horário: ${_timeController.text}');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 154, 193, 221),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    'Adicionar Remédio',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always, 
        labelStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2.0),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      ),
      style: TextStyle(fontSize: 20, color: Colors.black),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira $label'.toLowerCase();
        }
        return null;
      },
    );
  }
}
