import 'package:flutter/material.dart';
import '../widgets/CustomButton.dart';
import '../screens/login_screen.dart';
import '../screens/sign_in.dart';


class Home_screen extends StatelessWidget {
  const Home_screen({super.key});
  @override
  Widget build (BuildContext context){
    return Scaffold(
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
                              MaterialPageRoute(builder: (context) => const Login_screen()),
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