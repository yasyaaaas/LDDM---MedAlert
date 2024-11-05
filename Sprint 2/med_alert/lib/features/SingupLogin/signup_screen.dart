import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form( 
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', width: 100, height: 100),
                SizedBox(height: 20),
                Text(
                  'Cadastro',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nome é obrigatório';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Sobrenome',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Sobrenome é obrigatório';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Data de nascimento é obrigatória';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email é obrigatório';
                    }
                    if (!value.contains('@')) {
                      return 'Digite um email válido!';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Senha é obrigatória';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter no mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    labelStyle: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  obscureText: true,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirmação de senha é obrigatória';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Se todos os campos forem válidos
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32), 
                  ),
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Já tem um cadastro? Entre aqui!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
