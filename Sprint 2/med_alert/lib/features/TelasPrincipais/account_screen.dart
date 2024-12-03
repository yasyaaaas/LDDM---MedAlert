import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_alert/shared/dao/usuario_dao.dart';
import 'package:med_alert/shared/models/usuario_model.dart';

const Color backgroundColor = Colors.white;

class AccountScreen extends StatefulWidget {
  final int userId; // ID do usuário logado, passado ao abrir a tela

  AccountScreen({required this.userId});

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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final UsuarioDao _usuarioDao = UsuarioDao(); // Instância do DAO

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Carrega os dados do usuário ao abrir a tela
  }

  Future<void> _loadUserData() async {
    try {
      // Busca o usuário pelo ID
      Usuario? usuario = await _usuarioDao.getUsuarioById(widget.userId);

      if (usuario != null) {
        // Preenche os controladores com os dados do usuário
        setState(() {
          _nameController.text = usuario.nome;
          _emailController.text = usuario.email;
        });
      }
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
    }
  }

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
                        radius: 70, // Aumentei o tamanho do ícone
                        backgroundImage: _profileImage != null
                            ? FileImage(File(_profileImage!.path))
                            : null,
                        child: _profileImage == null
                            ? Icon(Icons.person, size: 70) // Aumentei o tamanho do ícone
                            : null,
                      ),
                    ),
                    SizedBox(height: 20), // Aumentei o espaçamento
                    Icon(Icons.camera_alt, size: 30), // Aumentei o tamanho do ícone da câmera
                    Text(
                      _nameController.text.isNotEmpty
                          ? 'Olá, ${_nameController.text}'
                          : 'Carregando...',
                      style: TextStyle(
                          fontSize: 24, // Aumentei o tamanho da fonte
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30), // Aumentei o espaçamento entre o ícone e o formulário

              // Formulário de alterações
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        labelStyle: TextStyle(fontSize: 18), // Aumentei o tamanho da fonte do label
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding interno maior
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Bordas arredondadas
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple, width: 2), // Cor da borda ao focar
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      style: TextStyle(fontSize: 28), // Aumentei o tamanho da fonte do texto
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20), // Aumentei o espaçamento entre os campos

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Altere seu e-mail',
                        labelStyle: TextStyle(fontSize: 18), // Aumentei o tamanho da fonte do label
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding interno maior
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Bordas arredondadas
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple, width: 2), // Cor da borda ao focar
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      style: TextStyle(fontSize: 28), // Aumentei o tamanho da fonte do texto
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!value.contains('@')) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20), // Aumentei o espaçamento entre os campos

                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Altere sua senha',
                        labelStyle: TextStyle(fontSize: 18), // Aumentei o tamanho da fonte do label
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding interno maior
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Bordas arredondadas
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple, width: 2), // Cor da borda ao focar
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(fontSize: 28), // Aumentei o tamanho da fonte do texto
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (value.length <= 6) {
                          return 'A senha deve ter mais de 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20), // Aumentei o espaçamento entre os campos

                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirme sua senha',
                        labelStyle: TextStyle(fontSize: 18), // Aumentei o tamanho da fonte do label
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding interno maior
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30), // Bordas arredondadas
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurple, width: 2), // Cor da borda ao focar
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      obscureText: true,
                      style: TextStyle(fontSize: 28), // Aumentei o tamanho da fonte do texto
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (value != _passwordController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 40), // Aumentei o espaçamento entre o último campo e o botão

                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Lógica para salvar as informações
                          print('Nome: ${_nameController.text}');
                          print('E-mail: ${_emailController.text}');
                          // Adicione lógica para alterar a senha
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple, // Cor de fundo do botão
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40), // Maior padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Bordas arredondadas no botão
                        ),
                      ),
                      child: Text(
                        'Salvar Alterações',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
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
