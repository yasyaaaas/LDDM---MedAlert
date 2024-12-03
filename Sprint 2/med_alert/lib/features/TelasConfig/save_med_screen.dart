// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:med_alert/shared/dao/remedio_dao.dart';
import 'package:med_alert/shared/models/remedio_model.dart';

class SaveMedScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SaveMedScreenState createState() => _SaveMedScreenState();
}

const Color backgroundColor = Colors.white;

class _SaveMedScreenState extends State<SaveMedScreen> {
  final RemedioDao _remedioDao =
      RemedioDao(); // Instância do DAO para acessar o banco de dados
  List<Remedio> _medications = []; // Lista para armazenar os medicamentos

  @override
  void initState() {
    super.initState();
    _fetchMedications(); // Busca os medicamentos ao inicializar a tela
  }

  Future<void> _fetchMedications() async {
    // Busca os medicamentos no banco de dados
    await _remedioDao.deletarFrequenciaInvalida(); // Exclui registros inválidos
    List<Remedio> medications = await _remedioDao.selecionarTodos();
    setState(() {
      _medications =
          medications; // Atualiza o estado com a lista de medicamentos
    });
  }

  Future<void> _deleteMedication(int id) async {
    await _remedioDao.deletar(Remedio(
        id: id, nome: '', tipo: '', dosagem: '', frequencia: 0, horario: null));
    _fetchMedications(); // Atualiza a lista após deletar
  }

  void _editMedication(Remedio med) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SaveMedScreenForm(remedio: med), // Tela de formulário para edição
      ),
    ).then((_) {
      _fetchMedications(); // Atualiza a lista após a edição
    });
  }

  void _addMedication() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SaveMedScreenForm(), // Tela de formulário para adição
      ),
    ).then((_) {
      _fetchMedications(); // Atualiza a lista após adicionar
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
        title: Text(
          'Medicamentos Salvos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23.0,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addMedication, // Navega para o formulário de adição
          ),
        ],
      ),
      body: _medications.isEmpty
          ? Center(child: Text("Nenhum medicamento cadastrado."))
          : ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _medications.length,
              itemBuilder: (context, index) {
                final med = _medications[index];
                return ListTile(
                  leading: IconTheme(
                    data: IconThemeData(
                      size: 30, // Aumenta o tamanho do ícone de medicamento
                      color: Colors.red,
                    ),
                    child: Icon(Icons.medication),
                  ),
                  title: Text(
                    med.nome,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold), // Aumenta o tamanho do título
                  ),
                  subtitle: Text(
                    "Dosagem: ${med.dosagem}, Frequência: ${med.frequencia} vezes ao dia, Horário: ${med.horario ?? 'N/A'}",
                    style: TextStyle(
                        fontSize: 18), // Aumenta o tamanho do subtítulo
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit,
                            color: Colors.blue,
                            size: 26), // Ajusta o ícone de edição
                        onPressed: () => _editMedication(med),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete,
                            color: Colors.red,
                            size: 26), // Ajusta o ícone de exclusão
                        onPressed: () async {
                          bool confirm = await _showDeleteConfirmation();
                          if (confirm) {
                            _deleteMedication(med.id!);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmação de Exclusão'),
            content:
                Text('Tem certeza de que deseja excluir este medicamento?'),
            actions: [
              TextButton(
                child: Text('Cancelar'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: Text('Excluir'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ) ??
        false;
  }
}

// Formulário para adicionar ou editar medicamentos
class SaveMedScreenForm extends StatefulWidget {
  final Remedio? remedio;

  SaveMedScreenForm({this.remedio});

  @override
  // ignore: library_private_types_in_public_api
  _SaveMedScreenFormState createState() => _SaveMedScreenFormState();
}

class _SaveMedScreenFormState extends State<SaveMedScreenForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final List<TextEditingController> _timeControllers = [];
  final RemedioDao _remedioDao = RemedioDao();

  // ignore: unused_field
  int _frequencia = 0;

  @override
  void initState() {
    super.initState();
    if (widget.remedio != null) {
      _nameController.text = widget.remedio!.nome;
      _doseController.text = widget.remedio!.dosagem;
      _frequencyController.text = widget.remedio!.frequencia?.toString() ?? '';
      _updateHorarioFields(widget.remedio!.frequencia ?? 0);
      for (int i = 0; i < _timeControllers.length; i++) {
        _timeControllers[i].text = widget.remedio!.horario ?? '';
      }
    }
  }

  void _updateHorarioFields(int frequencia) {
    setState(() {
      _frequencia = frequencia;
      _timeControllers.clear();
      for (int i = 0; i < frequencia; i++) {
        _timeControllers.add(TextEditingController());
      }
    });
  }

  Future<void> _saveMedication() async {
    if (_formKey.currentState!.validate()) {
      List<String> horarios =
          _timeControllers.map((controller) => controller.text).toList();

      Remedio novoRemedio = Remedio(
        id: widget.remedio?.id,
        nome: _nameController.text,
        tipo: "Medicamento",
        dosagem: _doseController.text,
        frequencia: int.tryParse(_frequencyController.text),
        horario: horarios.join(','),
      );

      if (widget.remedio == null) {
        await _remedioDao.adicionar(novoRemedio);
      } else {
        await _remedioDao.atualizar(novoRemedio);
      }
      Navigator.of(context).pop();
    }
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
        title: Text(
          widget.remedio == null ? 'Adicionar Novo Remédio' : 'Editar Remédio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 23.0,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                    int frequencia = int.tryParse(value) ?? 0;
                    _updateHorarioFields(frequencia);
                  },
                ),
                SizedBox(height: 20),
                ...List.generate(
                  _timeControllers.length,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: buildTextField(
                      controller: _timeControllers[index],
                      label: 'Horário ${index + 1} (Ex: 08:00)',
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveMedication,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  ),
                  child: Text(
                    widget.remedio == null
                        ? 'Adicionar Remédio'
                        : 'Salvar Alterações',
                    style: TextStyle(fontSize: 20),
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
        labelStyle: TextStyle(fontSize: 21),
      ),
      style: TextStyle(fontSize: 21),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, preencha este campo';
        }
        return null;
      },
    );
  }
}
