import 'package:flutter/material.dart';
import 'package:taller_1/navigator/MainTanScreen.dart';
import 'package:taller_1/screens/LoginScreen.dart';
import 'package:taller_1/screens/RegisterScreen.dart';
import 'package:taller_1/screens/WelcomeScreen.dart';


void main() {
  runApp(const TallerIApp());
}

class TallerIApp extends StatelessWidget {
  const TallerIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/tabs': (context) =>
            const MainTabScreen(), 
      },
    );
  }
}
