import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/home.dart';
import 'package:flutter_application_3/screens/sign_in.dart';
import 'package:flutter_application_3/screens/verify_email_screen.dart';


class FirebaseStream extends StatelessWidget{
  const FirebaseStream({super.key});

  @override
  Widget build(BuildContext context){
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error occurred')
            ),
            );
        } else if (snapshot.hasData) {
          if (snapshot.data!.emailVerified == false) {
            return const VerifyEmailScreen(); // User is signed in but email is not verified
          }
          return const HomeScreen(); // User is signed in
        } else {
          return const SignUpScreen(); // User is not signed in
        }
      },
      );
  }
}