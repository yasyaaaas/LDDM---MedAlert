import 'dart:io'; // Import necessário para usar File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const Color backgroundColor = Colors.white;

class AccountScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Função para abrir a câmera
  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _profileImage = photo; // Salvar a imagem tirada como foto de perfil
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              // Ícone de pessoa
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _openCamera,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 60)
                            : null,
                      ),
                    ),
                    SizedBox(height: 10),
                    Icon(Icons.camera_alt, size: 24),
                    Text('Equipe Med.Alert', style: TextStyle(fontSize: 20, color: Colors.deepPurple,  fontWeight: FontWeight.bold )),
                  ],
                ),
              ),
              SizedBox(height: 20),
              
              // Formulário de alterações
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Nome'),
                      style: TextStyle(fontSize: 26), 
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Altere seu e-mail'),
                      style: TextStyle(fontSize: 26), 
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!value.contains('@')) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Altere sua senha'),
                      obscureText: true,
                      style: TextStyle(fontSize: 26), 
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (value.length <= 6) {
                          return 'A senha deve ter mais de 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(labelText: 'Confirme sua senha'),
                      obscureText: true,
                      style: TextStyle(fontSize: 26), 
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (value != _passwordController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Lógica para salvar as informações
                          print('Nome: ${_nameController.text}');
                          print('E-mail: ${_emailController.text}');
                          // Adicione lógica para alterar a senha
                        }
                      },
                      child: Text('Salvar Alterações', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
