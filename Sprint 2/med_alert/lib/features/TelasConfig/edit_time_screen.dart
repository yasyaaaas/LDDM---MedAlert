import 'package:flutter/material.dart';

class EditTimeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _EditTimeScreenState createState() => _EditTimeScreenState();
}

const Color backgroundColor = Color.fromARGB(255, 199, 221, 236);

class _EditTimeScreenState extends State<EditTimeScreen> {
  final _formKey = GlobalKey<FormState>();
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
              'Editar Horário do Remédio',
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
                  controller: _timeController,
                  label: 'Horário (Ex: 08:00)',
                  keyboardType: TextInputType.datetime,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Lógica para salvar o horário alterado
                      print('Novo horário: ${_timeController.text}');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 154, 193, 221),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    'Salvar Alteração',
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
          fontSize: 18.0,
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
          return 'Por favor, insira o horário';
        }
        return null;
      },
    );
  }
}
