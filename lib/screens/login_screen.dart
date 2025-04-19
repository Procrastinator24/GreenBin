import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_3/services/snack_bar.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{
  bool _isHiddenPassword = true;

  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  Future<void> login() async {
    final navigator = Navigator.of(context);
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
      navigator.pushNamed('/home');
    } on FirebaseAuthException catch (e) {
      print(e.code);
      
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        SnackBarService.showSnackBar(
          context,
          'Неправильный email или пароль. Попробуйте еще раз',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Произошла ошибка. Попробуйте еще раз',
          true,
        );
        return;
      }
    } catch (e) {
      print(e);
    }
    navigator.pushNamedAndRemoveUntil(
      '/home',
      (Route<dynamic> route) => false,
    );
  }


  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Войти")
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Блок ввода Email
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  controller: emailTextInputController,
                  validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                      ? 'Введите корректный email'
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Введите ваш email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    
                  ),
                ),
                const SizedBox(height: 30),
                
                // Блок ввода пароля
                TextFormField(
                  autocorrect: false,
                  controller: passwordTextInputController,
                  obscureText: _isHiddenPassword,
                  validator: (value) => value != null && value.length < 8 || value?.startsWith(RegExp(r'[A-Z]')) == false || value?.contains(RegExp(r'[0-9]')) == false
                    ? 'Минимум 8 символов, одна заглавная буква, одна цифра.'
                    : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Введите пароль',
                    suffix: InkWell(
                      onTap: togglePasswordView,
                      child: Icon(
                        _isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                        color: Colors.black,
                      )
                    )
                  ),
                ),
                const SizedBox(height: 30),

                // Конпа ВОЙТИ 
                ElevatedButton(
                  onPressed: login, 
                  child: const Center(child: Text('Войти'),)
                ),
                const SizedBox(height: 30),

                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/signup'), 
                  child: const Text(
                    'Регистрация',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  )
                ),
                
                TextButton(
                  onPressed: () =>
                    Navigator.of(context).pushNamed('/reset_password'),
                  child: const Text('Сбросить пароль'),
                ),
                  
              ],
            )
          ),
        )
      ),
    );
  }
}