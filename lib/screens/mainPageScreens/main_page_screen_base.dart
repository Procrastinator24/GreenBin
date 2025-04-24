import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/mainPageScreens/main_page_screen.dart';
import 'package:flutter_application_3/screens/registration_and_login/account_screen.dart';

class MainPageBase  extends StatefulWidget{
  const MainPageBase({super.key});


  @override
  State<MainPageBase> createState() => _MainPageBase();

}

class _MainPageBase extends State<MainPageBase>{

  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MainScreen(), 
    MainScreen(), 
    MainScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context){
    int _currentIndex = 0;

      return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Color(0xffF7FBFC),
          selectedIndex: _selectedIndex,
          indicatorColor: Color(0xffDEEFF3),
          indicatorShape: CircleBorder(),
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.location_on_outlined),
              selectedIcon: Icon(Icons.location_on, color: Color(0xff005e63),),
              label: 'Главная',
            ),
            NavigationDestination(
              icon: Icon(Icons.location_on_outlined),
              selectedIcon: Icon(Icons.location_on, color: Color(0xff005e63), ),
              label: 'Карта',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_outline),
              selectedIcon: Icon(Icons.bookmark, color: Color(0xff005e63),),
              label: 'Обучение',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined),
              selectedIcon: Icon(Icons.person, color: Color(0xff005e63),),
              label: 'Профиль',
            ),
          ],
        ),
    );
  }
}