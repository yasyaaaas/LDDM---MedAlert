import 'package:flutter/material.dart';
import 'package:med_alert/shared/dao/remedio_dao.dart';
import 'package:med_alert/shared/models/remedio_model.dart';

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

  final List<TextEditingController> _timeControllers = [];
  final RemedioDao _remedioDao = RemedioDao();

  int _frequencia = 0;

  void _updateHorarioFields(int frequencia) {
    setState(() {
      _frequencia = frequencia;
      _timeControllers.clear();
      for (int i = 0; i < frequencia; i++) {
        _timeControllers.add(TextEditingController());
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    _frequencyController.dispose();
    for (var controller in _timeControllers) {
      controller.dispose();
    }
    super.dispose();
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
                  onChanged: (value) {
                    final freq = int.tryParse(value) ?? 0;
                    _updateHorarioFields(freq);
                  },
                ),
                SizedBox(height: 20),
                ..._timeControllers.asMap().entries.map((entry) {
                  final index = entry.key + 1;
                  final controller = entry.value;
                  return Column(
                    children: [
                      buildTextField(
                        controller: controller,
                        label: 'Horário $index (Ex: 08:00)',
                        keyboardType: TextInputType.datetime,
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }).toList(),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        // Cria uma lista de horários concatenados
                        final horarios = _timeControllers
                            .map((controller) => controller.text)
                            .join(',');

                        // Cria a instância do remédio
                        Remedio novoRemedio = Remedio(
                          nome: _nameController.text,
                          tipo: "Medicamento",
                          dosagem: _doseController.text,
                          frequencia: _frequencia,
                          horario: horarios,
                        );

                        // Salva no banco de dados
                        await _remedioDao.adicionar(novoRemedio);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Remédio adicionado com sucesso!')),
                        );

                        // Limpa os campos
                        _nameController.clear();
                        _doseController.clear();
                        _frequencyController.clear();
                        _updateHorarioFields(0);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro ao adicionar o remédio: $e')),
                        );
                      }
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
    Function(String)? onChanged,
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
      onChanged: onChanged,
    );
  }
}
