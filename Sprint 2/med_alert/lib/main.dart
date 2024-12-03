// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:med_alert/features/ListarRemedios/test_screen.dart';
import 'package:med_alert/notification_service.dart';
import 'package:med_alert/shared/dao/remedio_dao.dart';
import 'package:med_alert/shared/models/remedio_model.dart';
import 'features/SingupLogin/splash_screen.dart';
import 'features/TelasPrincipais/home_screen.dart';
import 'features/SingupLogin/login_screen.dart';
import 'features/SingupLogin/signup_screen.dart';
import 'features/TelasPrincipais/account_screen.dart';
import 'features/TelasPrincipais/settings_screen.dart';
import 'package:permission_handler/permission_handler.dart';

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await requestExactAlarmPermission();
  runApp(MyApp());
}*/

Future<void> requestExactAlarmPermission() async {
  PermissionStatus status = await Permission.notification.request();

  if (status.isGranted) {
    print("Permissão concedida!");
  } else {
    print("Permissão não concedida.");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await requestExactAlarmPermission();

  Future.delayed(Duration(seconds: 10), () {
    NotificationService().scheduleNotification(
      id: 1,
      title: 'Teste de Notificação',
      body: 'Esta é uma notificação de teste.',
      scheduledTime: DateTime.now().add(Duration(seconds: 10)),
      payload: 'teste_payload',
    );
  });

  runApp(MyApp());
}

/*void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();

  // Teste de notificação (agendar uma notificação 10 segundos no futuro)
  Future.delayed(Duration(seconds: 10), () {
    NotificationService().scheduleNotification(
      id: 1,
      title: 'Teste de Notificação',
      body: 'Esta é uma notificação de teste.',
      scheduledTime: DateTime.now().add(Duration(seconds: 10)), // 10 segundos no futuro
      payload: 'teste_payload',
    );
  });

  

  runApp(MyApp());
}*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MED.ALERT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF04184B), // Cor de fundo azul escuro
        textTheme: TextTheme(
            bodyMedium: TextStyle(color: Colors.white)), // Textos em branco
      ),
      // home: ListarRemediosScreen(),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/account': (context) => AccountScreen(userId: 1),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}
