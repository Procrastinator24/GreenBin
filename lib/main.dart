import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/sign_in.dart';
import 'screens/home.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.blueAccent),
    routes: {
        '/': (context) => const Home_screen(),
        '/login': (context) => const Login_screen(),
        'sign_in': (context) => const SignUpScreen(),
    },
  ));
}



