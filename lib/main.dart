import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/main/presentation/screens/main_page_screen_base.dart';
import 'package:flutter_application_3/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:flutter_application_3/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_3/features/user/presentation/screens/account_screen.dart';
import 'package:flutter_application_3/features/user/presentation/screens/user_data_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/main/presentation/screens/home.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_3/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:flutter_application_3/features/main/presentation/screens/main_page_screen.dart';
import 'features/user/presentation/bloc/user_bloc.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()..add(AuthCheckRequested())),
          BlocProvider(create: (context) => UserBloc(
            authBloc: context.read<AuthBloc>()),),
      ], 
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
        primaryColor: Colors.blueAccent),
      onGenerateRoute: (settings){
        switch (settings.name) {
          case '/user_account':
            return MaterialPageRoute(builder: (context) => AccountScreen()); // Страница пользователя в NavigationBar
          case '/user_data_screen':
            return MaterialPageRoute(builder: (context) => UserDataScreen()); // Страница смены данных пользователя
          case '/home':
            return MaterialPageRoute(builder: (context) => HomeScreen()); // Начальное окно
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen()); // Страница входа
          case '/signup':
            return MaterialPageRoute(builder: (context) => SignUpScreen()); // Страница регистрации
          case '/reset_password':
            return MaterialPageRoute(builder: (context) => ResetPasswordScreen()); // Страница сброса пароля
          case '/change_password_screen':
            return MaterialPageRoute(builder: (context) => ResetPasswordScreen()); // Страница смены пароля
          case '/verify_email':
            return MaterialPageRoute(builder: (context) => VerifyEmailScreen()); // Страница проверки подтверждения Email
          case '/main_page':
            return MaterialPageRoute(builder: (context) => MainScreen()); // Главный экран
          case '/main_base':
            return MaterialPageRoute(builder: (context) => MainPageBase()); // Навигационная панель
          case '/user_data':
            return MaterialPageRoute(builder: (context) => UserDataScreen()); //Настройки пользователя
          default:
            return MaterialPageRoute(builder: (context) => MainPageBase());
        }
      },
      // routes: {
      //     // '/': (context) => const FirebaseStream(),
      //     '/user_account': (context) => AccountScreen(), // Страница пользователя в NavigationBar
      //     '/user_data_screen': (context) => UserDataScreen(), // Страница смены данных пользователя
      //     '/home': (context) =>  HomeScreen(), // Начальное окно
      //     '/login': (context) =>  LoginScreen(), // Страница входа
      //     '/signup': (context) =>  SignUpScreen(), // Страница регистрации
      //     '/reset_password': (context) =>  ResetPasswordScreen(), // Страницп сброса пароля
      //     '/change_password_screen': (context) =>  ResetPasswordScreen(), // Страница смены пароля
      //     '/verify_email': (context) =>  VerifyEmailScreen(), // Страница проверки Email
      //     '/main_page': (context) =>  MainScreen(), // Главный экран
      //     '/main_base': (context) =>  MainPageBase(), // Навигационная панель
      //     '/user_data': (context) =>  UserDataScreen(), //Настройки пользователя
      // },
      // initialRoute: '/home',
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return  MainPageBase();
          } else if (state is AuthUnauthenticated){
            return const HomeScreen();
          }
          return  const Scaffold(body: Center(child: CircularProgressIndicator(),));
        },
      ),
      )
    );
  }
}




