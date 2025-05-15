import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/main/presentation/screens/main_page_screen.dart';
import 'package:flutter_application_3/features/user/presentation/bloc/auth_bloc.dart';
import 'package:flutter_application_3/features/user/presentation/screens/account_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageBase extends StatefulWidget {
  const MainPageBase({super.key});

  @override
  State<MainPageBase> createState() => _MainPageBase();
}

class _MainPageBase extends State<MainPageBase> {
  int _selectedIndex = 0;

  late final List<WidgetBuilder> _screensBuilders;

  @override
  void initState() {
    super.initState();
    _screensBuilders = [
      (context) => MainScreen(),
      (context) => MainScreen(),
      (context) => MainScreen(),
      (context) => AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated){
          
        return Scaffold(
          body: _screensBuilders[_selectedIndex](context),
          bottomNavigationBar: NavigationBar(
            backgroundColor: Color(0xffF7FBFC),
            selectedIndex: _selectedIndex,
            indicatorColor: Color(0xffDEEFF3),
            indicatorShape: CircleBorder(),
            onDestinationSelected:
                (index) => setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.location_on_outlined),
                selectedIcon: Icon(Icons.location_on, color: Color(0xff005e63)),
                label: 'Главная',
              ),
              NavigationDestination(
                icon: Icon(Icons.location_on_outlined),
                selectedIcon: Icon(Icons.location_on, color: Color(0xff005e63)),
                label: 'Карта',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark_outline),
                selectedIcon: Icon(Icons.bookmark, color: Color(0xff005e63)),
                label: 'Обучение',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person, color: Color(0xff005e63)),
                label: 'Профиль',
              ),
            ],
          ),
        );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
