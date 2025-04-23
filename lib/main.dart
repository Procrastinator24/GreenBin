import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/registration_and_login/sign_up_screen.dart';
import 'package:flutter_application_3/screens/registration_and_login/verify_email_screen.dart';
import 'screens/home.dart';
import 'screens/registration_and_login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_3/services/firebase_stream.dart';
import 'package:flutter_application_3/screens/registration_and_login/reset_password_screen.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(const MyApp());
  
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
      primaryColor: Colors.blueAccent),
    routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
    },
    initialRoute: '/home',
  );
  }
}




