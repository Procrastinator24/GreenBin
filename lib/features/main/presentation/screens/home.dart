import 'package:flutter/material.dart';
import 'package:flutter_application_3/core/widgets/CustomButton.dart';
import 'package:flutter_application_3/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_application_3/features/auth/presentation/screens/sign_up_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build (BuildContext context){

    
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {              
              Navigator.push(context, 
              MaterialPageRoute(builder: (context) => const LoginScreen()),);
            }, 
            icon: Icon(
              Icons.person,
              color: Colors.grey,
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
                            semanticLabel: "trashBox",
                            ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          height: 70,
                          
                          child: Text("GreenBin", style:TextStyle( 
                            fontSize: 64,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Lato',
                            color: Colors.black,)
                        ),
                        ),
                        
                        SizedBox(height: 0,),

                        Container(
                          width: 150,
                          height: 60,
                          
                          child: Text("get best", style:TextStyle(
                              height: 1, 
                              fontSize: 36,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Lato',
                              color: Colors.black,)
                              ),

                        ),
                        SizedBox(height: 30,),
                    Column(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            CustomButton(
                                
                                color: Color(0xff00858C),
                                text: "Создать аккаунт", width: 249,
                                onPressed: ()=>{
                                  Navigator.push(context, 
                                  MaterialPageRoute(builder: (context) => const SignUpScreen()))
                                }, 
                            ),
                            CustomButton(
                              color: Color(0xff00858C),
                              text: "Вход", width: 249,
                              onPressed: ()=>{
                              Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            )
                            }, 
                           ),
                            CustomButton(onPressed: ()=>{
                              //pased
                              }, 
                            text: "Посмотреть карту", 
                            width: 249, 
                            color: Colors.white,
                            textColor: Color(0xff00858C),
                            borderColor: Color(0xff00858C), 
                            borderWidth: 2,),

                    ],)
                    
                    ],)
                    
                    ],)
          );

  }

}