import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/mainPageScreens/main_page_screen_base.dart';
import 'package:flutter_application_3/screens/registration_and_login/sign_up_screen.dart';
import 'package:flutter_application_3/screens/registration_and_login/verify_email_screen.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/BLoC.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/auth_bloc.dart';
import 'package:flutter_application_3/screens/userScreens/account_screen.dart';
import 'package:flutter_application_3/screens/userScreens/user_data_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home.dart';
import 'screens/registration_and_login/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_3/screens/registration_and_login/reset_password_screen.dart';
import 'package:flutter_application_3/screens/mainPageScreens/main_page_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()..add(AuthCheckRequested())),
        BlocProvider(create: (context) => UserBloc(
          authBloc: context.read<AuthBloc>()),),
    ], 
    child: const MyApp(),
    )
  );
  
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    
    theme: ThemeData(
      useMaterial3: true,
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      }),
      primaryColor: Colors.blueAccent),
    routes: {
        // '/': (context) => const FirebaseStream(),
        '/user_account': (context) => AccountScreen(),
        '/home': (context) =>  HomeScreen(), // Начальное окно
        '/login': (context) =>  LoginScreen(), // Страница входа
        '/signup': (context) =>  SignUpScreen(), // Страница регистрации
        '/reset_password': (context) =>  ResetPasswordScreen(), // Страницп сброса пароля
        '/verify_email': (context) =>  VerifyEmailScreen(), // Страница проверки Email
        '/main_page': (context) =>  MainScreen(), // Главный экран
        '/main_base': (context) =>  MainPageBase(), // Навигационная панель
        '/user_data': (context) =>  UserDataScreen(), //Настройки пользователя
    },
    // initialRoute: '/home',
    home: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const MainPageBase();
        } else if (state is AuthUnauthenticated){
          return const HomeScreen();
        }
        return  const Scaffold(body: Center(child: CircularProgressIndicator(),));
      },
    ),
  );
  }
}




