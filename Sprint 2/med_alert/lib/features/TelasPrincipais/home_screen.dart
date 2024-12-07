import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import necessário para usar a câmera
import 'account_screen.dart';
import 'settings_screen.dart';
import 'package:med_alert/shared/dao/remedio_dao.dart'; // Import do DAO
import 'package:med_alert/shared/models/remedio_model.dart'; // Import do modelo de Remédio
import 'package:med_alert/notification_service.dart'; // Import para notificações
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    AccountScreen(userId: 1),
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
class NotificationScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final RemedioDao _remedioDao = RemedioDao();
  List<Remedio> _remedios = [];
  Map<int, bool> _tomados = {};
  List<Remedio> _historico = [];

  @override
  void initState() {
    super.initState();
    NotificationService().init(); // Inicialize o serviço de notificações aqui
    _fetchRemedios();
  }

  Future<void> _fetchRemedios() async {
    // Remover frequências inválidas do banco de dados
    await _remedioDao.deletarFrequenciaInvalida();

    // Selecionar todos os remédios do banco de dados
    List<Remedio> remedios = await _remedioDao.selecionarTodos();

    // Lista para armazenar remédios separados por horário
    List<Remedio> remediosSeparados = [];

    // Separar os remédios de acordo com seus horários
    for (var remedio in remedios) {
      List<String> horarios = remedio.horario?.split(',') ?? [];
      for (var horario in horarios) {
        remediosSeparados.add(
          Remedio(
            id: remedio.id,
            tipo: remedio.tipo,
            nome: remedio.nome,
            horario: horario.trim(),
            dosagem: remedio.dosagem,
            frequencia: remedio.frequencia,
          ),
        );
      }
    }

    // Ordenar os remédios pelos horários
    remediosSeparados.sort((a, b) {
      DateTime? horaA = _parseHorario(a.horario ?? "00:00");
      DateTime? horaB = _parseHorario(b.horario ?? "00:00");
      if (horaA != null && horaB != null) {
        return horaA.compareTo(horaB);
      }
      return 0;
    });

    // Agendar notificações para cada remédio separado
    for (int index = 0; index < remediosSeparados.length; index++) {
      var remedio = remediosSeparados[index];
      await _scheduleNotification(remedio, index); // Passando o índice correto
    }

    // Atualizar o estado com os remédios processados
    setState(() {
      _remedios = remediosSeparados;
    });

    // Ordenar o histórico por horário
    _historico.sort((a, b) {
      DateTime? horaA = _parseHorario(a.horario ?? "00:00");
      DateTime? horaB = _parseHorario(b.horario ?? "00:00");
      if (horaA != null && horaB != null) {
        return horaA.compareTo(horaB);
      }
      return 0;
    });
  }

  DateTime? _parseHorario(String horario) {
    try {
      final parts = horario.split(':');
      if (parts.length == 2) {
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        return DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, hour, minute);
      }
    } catch (e) {
      print('Erro ao converter horário: $horario');
    }
    return null;
  }

  Future<void> _scheduleNotification(Remedio remedio, int index) async {
    DateTime? horario = _parseHorario(remedio.horario ?? "00:00");
    if (horario != null) {
      // Se o horário já passou, agende para o próximo dia
      if (horario.isBefore(DateTime.now())) {
        horario = horario.add(Duration(days: 1));
      }
      await NotificationService().scheduleNotification(
        id: (remedio.id ?? 0) * 1000 +
            index, // ID único baseado no ID do remédio e índice
        title: 'Hora de tomar ${remedio.nome}',
        body: 'Dosagem: ${remedio.dosagem}',
        scheduledTime: horario,
        payload: remedio.nome,
      );
    }
  }

  Future<void> _scanBarcodeAndVerifyMedication(Remedio remedio) async {
    // Abre o scanner de código de barras
    String barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Cor do scanner
      'Cancelar', // Texto do botão cancelar
      true, // Flash ativado ou não
      ScanMode.BARCODE, // Modo de escaneamento
    );

    if (barcode != '-1') {
      // Se não cancelar o escaneamento
      // Verifique no Firebase se o código de barras existe
      FirebaseFirestore.instance
          .collection('remedios')
          .where('codigoDeBarras', isEqualTo: barcode)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          // Se o código de barras encontrado no Firebase
          var doc = querySnapshot.docs[0];
          String nomeNoFirebase = doc['nome'];

          // Comparar o nome do remédio com o nome no banco
          if (nomeNoFirebase == remedio.nome) {
            // Se o nome coincidir, considere como tomado
            _showTakenPopup(remedio);
          } else {
            // Caso o nome não coincida
            _showErrorDialog('Nome do medicamento não corresponde!');
          }
        } else {
          // Se o código de barras não for encontrado
          _showErrorDialog('Código de barras não encontrado!');
        }
      }).catchError((e) {
        _showErrorDialog('Erro ao verificar o código de barras: $e');
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erro'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Exibir o popup de tomada
  Future<void> _showTakenPopup(Remedio remedio) async {
  bool? taken = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Você tomou o medicamento?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(remedio.nome),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _scanBarcodeAndVerifyMedication(remedio);
                Navigator.of(context).pop();
              },
              child: Text('Escanear código de barras'),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Central de Notificações',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
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
                children: _remedios.isEmpty
                    ? [
                        Container(
                          width: double.infinity,
                          height: 80,
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              'Nenhum remédio cadastrado',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ]
                    : _remedios.map((remedio) {
                        return GestureDetector(
                          onTap: () => _showTakenPopup(remedio),
                          child: Container(
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
                                  Text(remedio.horario ?? 'Sem horário',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.black)),
                                  Text(remedio.nome,
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
              ),
            ),
            SizedBox(height: 40),
            Text('Histórico de Notificações',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
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
                children: _historico.isEmpty
                    ? [
                        Container(
                          width: double.infinity,
                          height: 80,
                          color: Colors.white,
                          child: Center(
                            child: Text(
                              'Nenhum histórico de notificações',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ]
                    : _historico.map((remedio) {
                        bool taken = _tomados[remedio.id!] ?? false;
                        return Container(
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            color: taken ? Colors.green : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          margin: EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer, size: 24),
                                Text(remedio.horario ?? 'Sem horário',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black)),
                                Text(remedio.nome,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black)),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
