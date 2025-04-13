import 'package:flutter/material.dart';
import '../services/snack_bar.dart';
import 'package:email_validator/email_validator.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final ValueNotifier<bool> _termsAccepted = ValueNotifier<bool>(false);
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController nameTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  bool isChecked = true;
  TextEditingController passwordTextRepeatInputController =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    passwordTextRepeatInputController.dispose();

    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> signUp() async {
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (passwordTextInputController.text !=
        passwordTextRepeatInputController.text) {
      SnackBarService.showSnackBar(
        context,
        'Пароли должны совпадать',
        true,
      );
      return;
    }

    // try {
    //   await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: emailTextInputController.text.trim(),
    //     password: passwordTextInputController.text.trim(),
    //   );
    // } on FirebaseAuthException catch (e) {
    //   print(e.code);

    //   if (e.code == 'email-already-in-use') {
    //     SnackBarService.showSnackBar(
    //       context,
    //       'Такой Email уже используется, повторите попытку с использованием другого Email',
    //       true,
    //     );
    //     return;
    //   } else {
    //     SnackBarService.showSnackBar(
    //       context,
    //       'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
    //       true,
    //     );
    //   }
    // }

    navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Регистрация'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                controller: nameTextInputController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Имя',
                  
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                keyboardType: TextInputType.text,
                autocorrect: true,
                controller: emailTextInputController,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Введите правильный Email'
                        : null,
                decoration:  InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Введите Email',
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                controller: passwordTextInputController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 8
                    ? 'Минимум 8 символов, одна заглавная буква, одна цифра.'
                    : null,
                decoration: InputDecoration(
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  helperText: "Минимум 8 символов, одна заглавная буква, одна цифра.",
                  hintText: 'Пароль',
                  suffix: InkWell(
                    onTap: togglePasswordView,
                    child: Icon(
                      isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                autocorrect: false,
                controller: passwordTextRepeatInputController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Минимум 6 символов'
                    : null,
                decoration: InputDecoration(
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  hintText: 'Повторите пароль',
                  suffix: InkWell(
                    onTap: togglePasswordView,
                    child: Icon(
                      isHiddenPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: _termsAccepted,
                      builder: (context, value, child) {
                        return Checkbox(
                          value: value,
                          onChanged: (bool? newValue) {
                            _termsAccepted.value = newValue ?? false;
                          },
                        );
                      },
                    ),
                    Text('Принять условия соглашения'),
                  ],),
              ValueListenableBuilder<bool>(
                valueListenable: _termsAccepted, 
                builder: (context, value, child){
                  return ElevatedButton(
                        onPressed: value ? () => signUp : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: value ? Colors.blue : Colors.grey,
                          foregroundColor: value ? Colors.white : Colors.grey,
                          minimumSize: Size(180, 50)
                        ),
                        child: const Center(child: Text('Зарегистрироваться',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                          ),
                        )),
                        );
                      }
              ),
              
              const SizedBox(height: 1),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Войти',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}