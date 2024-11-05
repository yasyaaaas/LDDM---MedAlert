import 'package:flutter/material.dart';
import 'package:med_alert/features/ListarRemedios/listarRemedios_screen.dart';
import 'features/SingupLogin/splash_screen.dart';
import 'features/TelasPrincipais/home_screen.dart';
import 'features/SingupLogin/login_screen.dart';
import 'features/SingupLogin/signup_screen.dart';
import 'features/TelasPrincipais/account_screen.dart';
import 'features/TelasPrincipais/settings_screen.dart';
//import 'shared/features/TelasPrincipais/camera_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MED.ALERT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFF04184B), // Cor de fundo azul escuro
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white)), // Textos em branco
      ),
      home: ListarRemediosScreen(),
      initialRoute: '/home',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/account': (context) => AccountScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

