import 'package:flutter/material.dart';
import '../../services/snack_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final ValueNotifier<bool> _termsAccepted = ValueNotifier<bool>(false);
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  bool isHiddenPassword = true;
  bool _isEmailValid = false;
  bool isChecked = true;

  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController nameTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  TextEditingController passwordTextRepeatInputController = TextEditingController();

  final formKey = GlobalKey<FormState>();


  // Очистка текстовых контроллеров
  @override
  void dispose() {
    nameTextInputController.dispose();
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    passwordTextRepeatInputController.dispose();

    super.dispose();
  }

  // Меняем замазанность пароля
  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  //Функция регистрации через Firebase
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

    //Пытаемся создать пользователя в firebase и сохранить в firestore
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
      await _saveUserData(
        userId: userCredential.user!.uid,
        email: emailTextInputController.text.trim(),
        name: nameTextInputController.text.trim(),
      );


      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }

    } on FirebaseAuthException catch (e) {
      print("$e.code Барабулька блять");

      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(
          context,
          'Такой Email уже используется, повторите попытку с использованием другого Email',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
      }
    }

    navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  //Ассинхронный метод для сохранения данных пользователя
  Future<void> _saveUserData({
      required String userId,
      required String email,
      required String name,
    }) async {
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back, // add custom icons also
            ),
          ),
          title: const Text('Регистрация'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [

                // Поле Ввода Имени
                TextFormField(
                  keyboardType: TextInputType.name,
                  autocorrect: false,
                  controller: nameTextInputController,
                  validator: (value){
                    if (value == null || value.isEmpty){
                      return 'Введите ваше имя';
                    }
                    if (value.length < 2){
                      return 'Имя слишком короткое';
                    }
                    return null;
                  }, 
                  decoration: InputDecoration(
                    label: Text('Имя'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Имя',
                    
                  ),
                ),
                const SizedBox(height: 30),

                // Поле Email
                TextFormField(
                  keyboardType: TextInputType.text,
                  autocorrect: true,
                  controller: emailTextInputController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (email) {
                    setState(() {
                      _isEmailValid = EmailValidator.validate(email);
                    });
                  },
                  validator: (email){
                    if (email != null && !EmailValidator.validate(email)){
                      return 'Введите правильный Email';
                    }
                    else{
                      return null;
                    }
                  },
                  decoration:  InputDecoration(
                    labelText: 'E-mail',
                    fillColor: emailTextInputController.text.isEmpty 
                            ?Colors.grey[200]
                            : _isEmailValid
                              ? Colors.green[50]
                              : Colors.red[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Введите Email',
                  ),
                ),
                const SizedBox(height: 30),
                //Пароль
                TextFormField(
                  autocorrect: false,
                  controller: passwordTextInputController,
                  obscureText: isHiddenPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,

                  validator: (value) {
                    if (value != null && value.isEmpty){
                      return 'Введите пароль';
                    }
                    if (value != null && value.length < 8){
                      return 'Пароль должен быть не менее 8 символов';
                    }
                    if (value != null && !value.startsWith(RegExp(r'[A-Z]'))){
                      return 'Пароль должен начинаться с заглавной буквы';
                    }
                    if (value != null && !value.contains(RegExp(r'[0-9]'))){
                      return 'Пароль должен содержать хотя бы одну цифру';
                    }
                    return null;
                  },  
                  decoration: InputDecoration(
                    border:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Пароль',
                    label: Text('Пароль'),
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

                //Повтор пароля
                TextFormField(
                  autocorrect: false,
                  controller: passwordTextRepeatInputController,
                  obscureText: isHiddenPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null &&  value != passwordTextInputController.text  
                      ? 'Пароли должны совпадать'
                      : null,
                  decoration: InputDecoration(
                    border:  OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    hintText: 'Повторите пароль',
                    label: Text('Пароль'),
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

                //Реактивная кнопочка регистрации    
                ValueListenableBuilder<bool>(
                  valueListenable: _termsAccepted, 
                  builder: (context, value, child){
                    return ElevatedButton(
                          onPressed: signUp,
                          // onPressed: value ? () => signUp : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: value ? Colors.blue : Colors.grey,
                            foregroundColor: value ? Colors.white : Colors.black,
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

// import 'package:email_validator/email_validator.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import '../services/snack_bar.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   State<SignUpScreen> createState() => _SignUpScreen();
// }

// class _SignUpScreen extends State<SignUpScreen> {
//   bool isHiddenPassword = true;
//   TextEditingController emailTextInputController = TextEditingController();
//   TextEditingController passwordTextInputController = TextEditingController();
//   TextEditingController passwordTextRepeatInputController =
//       TextEditingController();
//   final formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     emailTextInputController.dispose();
//     passwordTextInputController.dispose();
//     passwordTextRepeatInputController.dispose();

//     super.dispose();
//   }

//   void togglePasswordView() {
//     setState(() {
//       isHiddenPassword = !isHiddenPassword;
//     });
//   }

//   Future<void> signUp() async {
//     final navigator = Navigator.of(context);

//     final isValid = formKey.currentState!.validate();
//     if (!isValid) return;

//     if (passwordTextInputController.text !=
//         passwordTextRepeatInputController.text) {
//       SnackBarService.showSnackBar(
//         context,
//         'Пароли должны совпадать',
//         true,
//       );
//       return;
//     }

//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: emailTextInputController.text.trim(),
//         password: passwordTextInputController.text.trim(),
//       );
//     } on FirebaseAuthException catch (e) {
//       print(e.code);

//       if (e.code == 'email-already-in-use') {
//         SnackBarService.showSnackBar(
//           context,
//           'Такой Email уже используется, повторите попытку с использованием другого Email',
//           true,
//         );
//         return;
//       } else {
//         SnackBarService.showSnackBar(
//           context,
//           'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
//           true,
//         );
//       }
//     }

//     navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text('Зарегистрироваться'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: Form(
//           key: formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 keyboardType: TextInputType.emailAddress,
//                 autocorrect: false,
//                 controller: emailTextInputController,
//                 validator: (email) =>
//                     email != null && !EmailValidator.validate(email)
//                         ? 'Введите правильный Email'
//                         : null,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   hintText: 'Введите Email',
//                 ),
//               ),
//               const SizedBox(height: 30),
//               TextFormField(
//                 autocorrect: false,
//                 controller: passwordTextInputController,
//                 obscureText: isHiddenPassword,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value) => value != null && value.length < 6
//                     ? 'Минимум 6 символов'
//                     : null,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Введите пароль',
//                   suffix: InkWell(
//                     onTap: togglePasswordView,
//                     child: Icon(
//                       isHiddenPassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               TextFormField(
//                 autocorrect: false,
//                 controller: passwordTextRepeatInputController,
//                 obscureText: isHiddenPassword,
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 validator: (value) => value != null && value.length < 6
//                     ? 'Минимум 6 символов'
//                     : null,
//                 decoration: InputDecoration(
//                   border: const OutlineInputBorder(),
//                   hintText: 'Введите пароль еще раз',
//                   suffix: InkWell(
//                     onTap: togglePasswordView,
//                     child: Icon(
//                       isHiddenPassword
//                           ? Icons.visibility_off
//                           : Icons.visibility,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed: signUp,
//                 child: const Center(child: Text('Регистрация')),
//               ),
//               const SizedBox(height: 30),
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text(
//                   'Войти',
//                   style: TextStyle(
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }