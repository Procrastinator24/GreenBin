import 'package:flutter/material.dart';
import 'package:flutter_application_3/services/get_user_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_application_3/screens/userScreens/BloC/auth_bloc.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/BLoC.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/event.dart';
import 'package:flutter_application_3/screens/userScreens/BloC/state.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _hasLoadedUser = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Загружаем пользователя только один раз при первом встраивании экрана
    if (!_hasLoadedUser) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        context.read<UserBloc>().add(LoadUserEvent(authState.userId));
        _hasLoadedUser = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    // Обрабатываем наши состояния
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is UserLoading || state is UserInitial) {
          return _buildLoadingView();
        } else if (state is UserLoaded) {
          return _buildProfileView(context, state.user);
        } else if (state is UserError) {
          return _buildErrorView(state.message);
        } else {
          return _buildErrorView('Неизвестное состояние');
        }
      },
    );
  }

  Widget _buildLoadingView() => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );

  Widget _buildErrorView(String message) => Scaffold(
        body: Center(child: Text(message)),
      );

  Widget _buildProfileView(BuildContext context, UserModel user) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: IconButton(
            color: const Color(0xff005E63),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xffDEEFF3),
            ),
            onPressed: () {},
            icon: const Icon(Icons.person_2_outlined, size: 31),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: const TextStyle(fontSize: 28)),
            Text(
              user.email ?? 'Email не указан',
              style: const TextStyle(fontSize: 14, color: Color(0xff4b4c4d)),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.create_outlined, size: 31),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 33, 16, 22),
        child: Column(
          children: [
            _buildButton(
              icon: Icons.settings_outlined,
              label: "Мои данные",
              onPressed: () => Navigator.of(context).pushNamed('/user_data'),
            ),
            const SizedBox(height: 16),
            _buildButton(
              icon: Icons.create_outlined,
              label: "Сменить пароль",
              onPressed: () {},
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _signOut(context),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: const BorderSide(color: Color(0xff00858C)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 91),
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xff00858C),
              ),
              child: const Text('Выйти из аккаунта', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffBCE6e6),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 26),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const Spacer(),
          const Icon(Icons.navigate_next_outlined, size: 26),
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    context.read<AuthBloc>().add(AuthLogout());
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}


















// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_3/screens/userScreens/BloC/BLoC.dart';
// import 'package:flutter_application_3/screens/userScreens/BloC/auth_bloc.dart';
// import 'package:flutter_application_3/screens/userScreens/BloC/event.dart';
// import 'package:flutter_application_3/screens/userScreens/BloC/state.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AccountScreen extends StatefulWidget {
//   // final String userId;;
//   const AccountScreen({super.key});

//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }

// class _AccountScreenState extends State<AccountScreen> {
//   final _user = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   User? _currentUser;
//   Map<String, dynamic>? _userData;
//   bool _isLoading = true;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     try {
//       _currentUser = _user.currentUser;

//       if (_currentUser == null) {
//         throw Exception('Пользователь не авторизован');
//       }
//       final DocumentSnapshot userDoc =
//           await _firestore.collection('users').doc(_currentUser!.uid).get();
//       if (!userDoc.exists) {
//         throw Exception('Данные пользователя не найдены');
//       }

//       setState(() {
//         _userData = userDoc.data() as Map<String, dynamic>;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> signOut() async {
//     final navigator = Navigator.of(context);

//     await FirebaseAuth.instance.signOut();

//     navigator.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Center(child: CircularProgressIndicator());
//     }

//     if (_errorMessage != null) {
//       return Center(child: Text('Ошибка: $_errorMessage'));
//     }

//     if (_userData == null) {
//       return const Center(child: Text('Данные пользователя не найдены'));
//     }
//     // final authBloc = AuthBloc()..add(AuthCheckRequested());
//     // final userBloc = UserBloc(authBloc: context.read<AuthBloc>());
//     return BlocBuilder<UserBloc, UserState>(
//       builder: (context, state) {
//         final user = UserBloc.currentUser(context);
//         if (user != null){
//           print(user.name);
//         }
//         if (state is UserInitial){
//           context.read<UserBloc>().add(LoadUserEvent(_currentUser!.uid));
//         }
//         if (state is UserLoaded){
//           String user_name = 'asdasd';
//           // user_name = state.user.name;
//           return Scaffold(
//             resizeToAvoidBottomInset: false,
//             appBar: AppBar(
//               leading: Padding(
//                 padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
//                 child: IconButton(
//                   color: Color(0xff005E63),
//                   style: IconButton.styleFrom(
//                     backgroundColor: Color(0xffDEEFF3),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const AccountScreen(),
//                       ),
//                     );
//                   },
//                   icon: const Icon(Icons.person_2_outlined, size: 31),
//                 ),
//               ),
//               title: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       _userData!['name'],
//                       style: TextStyle(fontSize: 28),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       // state.user,
//                       user.toString(),
//                       // _currentUser!.email ?? 'Загрузка...',
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: Color(0xff4b4c4d),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: IconButton(
//                     onPressed: () {},
//                     icon: Icon(Icons.create_outlined, size: 31),
//                   ),
//                 ),
//               ],
//             ),
//             body: Center(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(16, 33, 16, 22),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.max,
//                   children: [
//                     //Изменение пользовательских данных
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xffBCE6e6),
//                         foregroundColor: Colors.black,
//                         shape: RoundedRectangleBorder(
//                           // форма (например, скруглённые углы)
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           vertical: 16,
//                           horizontal: 18,
//                         ),
//                       ),
//                       onPressed:
//                           () => Navigator.of(context).pushNamed('/user_data'),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Icon(Icons.settings_outlined, size: 26),
//                           SizedBox(width: 10),
//                           Text(
//                             "Мои данные",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Spacer(flex: 1),
//                           Icon(Icons.navigate_next_outlined, size: 26),
//                         ],
//                       ),
//                     ),
    
//                     SizedBox(height: 16),
    
//                     // Сменить пароль
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xffBCE6e6),
//                         foregroundColor: Colors.black,
//                         shape: RoundedRectangleBorder(
//                           // форма (например, скруглённые углы)
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           vertical: 16,
//                           horizontal: 18,
//                         ),
//                       ),
//                       onPressed: () {},
//                       child: Row(
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Icon(Icons.create_outlined, size: 26),
//                           SizedBox(width: 10),
//                           Text(
//                             "Сменить пароль",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Spacer(flex: 1),
//                           Icon(Icons.navigate_next_outlined, size: 26),
//                         ],
//                       ),
//                     ),
//                     Spacer(),
//                     ElevatedButton(
//                       onPressed: () => signOut(),
    
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                           side: BorderSide(color: Color(0xff00858C)),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                           vertical: 14,
//                           horizontal: 91,
//                         ),
//                         backgroundColor: Colors.white,
//                         foregroundColor: Color(0xff00858C),
//                       ),
//                       child: Text(
//                         'Выйти из аккаунта',
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }else{
//           // userBloc.add(LoadUserEvent())
//           return SafeArea(child: Text(user.toString()));
//         };
//       },
//     );
//   }
// }
