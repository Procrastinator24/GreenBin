import 'package:flutter/material.dart';
import 'screens/home.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.blueAccent),
    routes: {
        '/': (context) => const Home_screen(),
        '/login': (context) => const Login_screen()
    },
  ));
}



