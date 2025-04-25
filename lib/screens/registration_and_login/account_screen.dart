import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _user = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _currentUser;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;


  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      _currentUser = _user.currentUser;

      if(_currentUser == null){
        throw Exception('Пользователь не авторизован');
      }
      final DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
      if (!userDoc.exists){
        throw Exception('Данные пользователя не найдены');
      }

      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  Future<void> signOut() async {
    final navigator = Navigator.of(context);

    await FirebaseAuth.instance.signOut();

    navigator.pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text('Ошибка: $_errorMessage'));
    }

    if (_userData == null) {
      return const Center(child: Text('Данные пользователя не найдены'));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: IconButton(
            color: Color(0xff005E63),
            style: IconButton.styleFrom(
              backgroundColor: Color(0xffDEEFF3),
              

            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountScreen()));
            }, icon: const Icon(
                          Icons.person_2_outlined, 
                          size: 31, )),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(_userData!['name'], style: TextStyle(fontSize: 28)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(_currentUser!.email ?? 'Загрузка...', style: TextStyle(fontSize: 14, color: Color(0xff4b4c4d)), ),
            )
          ],
        ),  
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: (){}, icon: Icon(Icons.create_outlined, size: 31,)),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 33, 16, 22),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              //Изменение пользовательских данных 
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffBCE6e6),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(    // форма (например, скруглённые углы)
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                ),
                onPressed: (){}, 
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.settings_outlined, size: 26,),
                    SizedBox(width: 10,),
                    Text("Мои данные", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                    Spacer(flex: 1,),
                    Icon(Icons.navigate_next_outlined, size: 26)
                  ],
                ) ),
              
              SizedBox(height: 16,),

              // Сменить пароль
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffBCE6e6),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(    // форма (например, скруглённые углы)
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                ),
                onPressed: (){}, 
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.create_outlined, size: 26,),
                    SizedBox(width: 10,),
                    Text("Сменить пароль", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                    Spacer(flex: 1,),
                    Icon(Icons.navigate_next_outlined, size: 26)
                  ],
                ) ),
              Spacer(),  
              ElevatedButton(
                onPressed: () => signOut(),
                
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color:Color(0xff00858C),
                    )
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 91),
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xff00858C),
                ), 
                child: Text('Выйти из аккаунта', style: TextStyle(fontSize: 16),))
            ],
          ),
        ),
      ),
    );
  }
}