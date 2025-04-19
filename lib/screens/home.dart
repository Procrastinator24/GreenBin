import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/screens/account_screen.dart';
import '../widgets/CustomButton.dart';
import '../screens/login_screen.dart';
import 'package:flutter_application_3/screens/sign_up_screen.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build (BuildContext context){
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Главная страница'),
        actions: [
          IconButton(
            onPressed: () {
              if ((user == null)){
                Navigator.push(context, 
                MaterialPageRoute(builder: (context) => const LoginScreen()),);
              }else {
                Navigator.push(context,
                 MaterialPageRoute(builder: (context) => const AccountScreen()),);
              }
            }, 
            icon: Icon(
              Icons.person,
              color: (user==null) ? Colors.white : Colors.amber,
            ))
        ],
      ),
            body:
            Row( 
                mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Image(image: AssetImage('images/greenbin.png'),
                            height: 89,
                            width: 97,
                            semanticLabel: "fuck",
                            ),
                        Text("GreenBin", style:TextStyle( 
                            fontSize: 64,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Lato',
                            color: Colors.black,)
                        ),
                        Text("get best", style:TextStyle( 
                            fontSize: 36,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Lato',
                            color: Colors.black,)
                            ),
                    Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            CustomButton(
                                text: "Создать аккаунт", width: 249,
                                onPressed: ()=>{
                                  Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => const SignUpScreen()))
                                }, 
                            ),
                            CustomButton(
                              text: "Вход", width: 249,
                              onPressed: ()=>{
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            )
                            }, 
                           ),
                            CustomButton(onPressed: ()=>{
                              }, 
                            text: "Посмотреть карту", width: 249, color: Colors.white, textColor: Colors.black, borderColor: Colors.blueAccent, borderWidth: 2,),

                    ],)
                    
                    ],)
                    
                    ],)
            );

}

}