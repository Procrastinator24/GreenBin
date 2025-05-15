import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/user/data/models/user_model.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/user_bloc.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/user_event.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';


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
      // Слушаем наши состояния
      listener: (context, state) {
        if (state is UserError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      // Отрисовываем в зависимости от состояния
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
            //Редактирование данных пользователя
            _buildButton(
              icon: Icons.settings_outlined,
              label: "Мои данные",
              onPressed: () => Navigator.of(context).pushNamed('/user_data_screen'),
              nextArrow: true,
            ),
            const SizedBox(height: 16),

            //Смена пароля пользователя
            _buildButton(
              icon: Icons.create_outlined,
              label: "Сменить пароль",
              onPressed: () => Navigator.of(context).pushNamed('/change_password_screen'),
            ),
            
            const SizedBox(height: 16),
            //Помощь
            _buildButton(
              icon: Icons.help_outline,
              label: "Помощь",
              onPressed: () => SnackBar(content: Text("Еще в разработке"))),
              // onPressed: () => Navigator.of(context).pushNamed('/help_screen'))
            
            const Spacer(),
            //Выход
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

  // Создали отдельный виджет для генерации отднотипных кнопок
  Widget _buildButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool? nextArrow,
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
          if (nextArrow!=null)
          const Icon(Icons.navigate_next_outlined, size: 26),
        ],
      ),
    );
  }

  // Отдельная функция выхода 
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    context.read<AuthBloc>().add(AuthLogout());
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
  }
}
















