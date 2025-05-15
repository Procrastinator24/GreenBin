import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_3/features/main/presentation/screens/main_page_screen_base.dart';
import 'package:flutter_application_3/core/utils/snack_bar.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>{
  bool _isHiddenPassword = true;

  bool _isValidEmail = false;
  bool _isValidPassword = false;
  bool _isTouchedEmail = false;
  bool _isTouchedPassword = false;

  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   emailTextInputController.addListener(_validateInputEmail);
  //   passwordTextInputController.addListener(_validateInputPassword);
  // }

  bool _validateInputPassword(String password){
      if ( password.length >= 8 && password.startsWith(RegExp(r'[A-Z]')) == true && password.contains(RegExp(r'[0-9]')) == true){
        return true;
      }
      return false;
  }

  bool _validateInputEmail(String value){
    return EmailValidator.validate(value);
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
      final auth = FirebaseAuth.instance;
      await auth.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
    
      // Получаем AuthBloc из контекста
      final authBloc = context.read<AuthBloc>();
    
      // Обновляем состояние AuthBloc
      authBloc.add(AuthLoggedIn(auth.currentUser!.uid));
      
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => MainPageBase()),
      );
    } on FirebaseAuthException catch (e) {
      SnackBarService.showSnackBar(
          context,
          '$e',
          true,
        );
      
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
    // navigator.pushNamedAndRemoveUntil(
    //   '/home',
    //   (Route<dynamic> route) => false,
    // );
  }

  Color _getFillColorEmail() {
    if (!_isTouchedEmail) return Colors.grey.shade100;
    return _isValidEmail ? Colors.green.shade50 : Colors.red.shade50;
  }

  Color _getFillColorPassword() {
    if (!_isTouchedPassword) return Colors.grey.shade100;
    return _isValidPassword ? Colors.green.shade50 : Colors.red.shade50;
  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            icon: const Icon(Icons.arrow_back,)
            ),
          title: const Text("Вход")
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                // Блок ввода Email
                TextFormField(
                  onChanged: (value){
                    setState(() {
                      _isValidEmail = _validateInputEmail(value);
                      _isTouchedEmail = true;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  controller: emailTextInputController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                      ? 'Некорректный адрес'
                      : null,
                  decoration: InputDecoration(
                    fillColor: _getFillColorEmail(),
                    filled: true,
                    labelText: 'Email',
                    hintText: 'Введите ваш email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    
                  ),
                ),
                const SizedBox(height: 12),
                
                // Блок ввода пароля
                TextFormField(
                  onChanged: (value){
                    setState(() {
                      _isValidPassword = _validateInputPassword(value);
                      _isTouchedPassword = true;
                    });
                  },
                  autocorrect: false,
                  controller: passwordTextInputController,
                  obscureText: _isHiddenPassword,
                  validator: (value) => value != null && value.length < 8 || value?.startsWith(RegExp(r'[A-Z]')) == false || value?.contains(RegExp(r'[0-9]')) == false
                    ? 'Минимум 8 символов, одна заглавная буква, одна цифра.'
                    : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: _getFillColorPassword(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Пароль',
                    suffix: InkWell(
                      onTap: togglePasswordView,
                      child: Icon(
                        _isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                        color: Colors.grey,
                      )
                    )
                  ),
                ),
                const SizedBox(height: 30),

                TextButton(
                  onPressed: () =>
                    Navigator.of(context).pushNamed('/reset_password'),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: 
                      Text('Забыли пароль?', 
                      style: TextStyle(
                        color: Color(0xff005e63),
                        fontSize: 16),),
                  ),

                ),
                // Кнопка ВОЙТИ 
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    shape: RoundedRectangleBorder(      // форма кнопки
                          borderRadius: BorderRadius.circular(16),
                    ),

                    backgroundColor: _isValidEmail && _isValidPassword ? Color(0xff00858c) : Color(0xffedf1f2),
                    foregroundColor: _isValidEmail && _isValidPassword ? Colors.white : Color(0xff7d7f80)
                  ),
                  child: const Center(child: Text('Войти', style: TextStyle(fontSize: 20),),)
                ),
                const SizedBox(height: 5),

                TextButton(
                  onPressed: () => Navigator.of(context).pushNamed('/signup'), 
                  child: const Text(
                    'Зарегистрироваться',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff00858c),
                    ),
                  )
                ),
                
                
                  
              ],
            )
          ),
        )
      ),
    );
  }
}