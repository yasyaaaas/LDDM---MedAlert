import 'package:flutter/material.dart';
import 'SingupLogin/splash_screen.dart';
import 'TelasPrincipais/home_screen.dart';
import 'SingupLogin/login_screen.dart';
import 'SingupLogin/signup_screen.dart';
import 'TelasPrincipais/account_screen.dart';
import 'TelasPrincipais/settings_screen.dart';

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
      initialRoute: '/splash',
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

