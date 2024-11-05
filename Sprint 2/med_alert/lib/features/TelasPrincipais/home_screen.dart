import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import necessário para usar a câmera
import 'account_screen.dart';
import 'settings_screen.dart';

const Color backgroundColor = Colors.white;

class HomeScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ImagePicker _picker =
      ImagePicker(); // Instância do ImagePicker para a câmera

  static List<Widget> _widgetOptions = <Widget>[
    NotificationScreen(), // Criar uma nova tela para as notificações
    AccountScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Função para abrir a câmera
  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Adicionar a lógica para salvar ou exibir a foto
      print('Imagem capturada: ${photo.path}');
    }
  }

  // Lista com os títulos correspondentes às páginas
  static List<String> _titles = [
    'Med.Alert', // Título da página inicial
    'Configurações de Conta', // Título da página de conta
    'Configurações Gerais' // Título da página de configurações
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            _titles[_selectedIndex],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 23.0,
              color: Colors.black, 
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 154, 193, 221),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: backgroundColor,
        child: _widgetOptions
            .elementAt(_selectedIndex), // Mostrar apenas o body da tela atual
      ),
      floatingActionButton: _selectedIndex ==
              0 // Mostrar botão flutuante apenas na tela de notificações
          ? FloatingActionButton(
              onPressed: _openCamera,
              child: Icon(Icons.camera_alt),
            )
          : null, // Não exibir o botão nas outras telas
      bottomNavigationBar: SizedBox(
        height: 80,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Conta',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Configurações',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFF04184B),
          onTap: _onItemTapped,
          selectedFontSize: 18,
          unselectedFontSize: 14,
          iconSize: 30,
        ),
      ),
    );
  }
}

// Criar uma nova classe para a tela de Notificações
class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Central de Notificações',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _notificationIcon('Ibuprofeno', '08:00'),
                  _notificationIcon('Paracetamol', '09:30'),
                  _notificationIcon('Amoxicilina', '11:15'),
                  _notificationIcon('Losartana', '13:45'),
                  _notificationIcon('Metformina', '16:00'),
                  _notificationIcon('Aspirina', '18:30'),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text('Histórico de Notificações',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _historyIcon(true, 'Simvastatina', '08:00'),
                  _historyIcon(false, 'Omeprazol', '09:30'),
                  _historyIcon(true, 'Loratadina', '11:15'),
                  _historyIcon(false, 'Fluoxetina', '13:45'),
                  _historyIcon(true, 'Sertralina', '16:00'),
                  _historyIcon(false, 'Dipirona', '18:30'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationIcon(String medicationName, String time) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.timer, size: 24),
            Text(time, style: TextStyle(fontSize: 16, color: Colors.black)),
            Text(medicationName,
                style: TextStyle(fontSize: 18, color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _historyIcon(bool isActive, String medicationName, String time) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(bottom: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle,
                color: isActive ? Colors.white : Colors.black54, size: 28),
            Text(time, style: TextStyle(fontSize: 16, color: Colors.black)),
            Text(medicationName,
                style: TextStyle(fontSize: 18, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
