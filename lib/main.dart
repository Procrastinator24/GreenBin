import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/sign_in.dart';
import 'screens/home.dart';
import 'screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_firebase_auth/services/firebase_streem.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Uncomment if using Firebase
  runApp(MaterialApp(
    theme: ThemeData(primaryColor: Colors.blueAccent),
    routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        'sign_in': (context) => const SignUpScreen(),
    },
  ));
}



